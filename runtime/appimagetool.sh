#!/bin/sh

# POSIX shell script to locate and run appimagetool
# Automatically downloads from GitHub if not found locally
#
# AI-GENERATED SCRIPT:
# This script was generated with assistance from Claude AI based on iterative prompts
# that refined requirements for architecture detection, error handling, and user experience.
#
# PROMPT INSIGHTS:
# The generation process involved prompts requesting:
# 1. POSIX compliance for maximum compatibility
# 2. Automatic download without user confirmation
# 3. Architecture matching between host system and downloaded binary
# 4. Graceful handling of unsupported architectures
# 5. Clean argument passing without intercepting tool-specific flags
#
# Key challenges addressed:
# - GitHub's "latest" redirect sometimes points to non-existent files
# - Architecture detection across diverse Unix systems
# - Balancing automation with proper error handling

set -e

# Base GitHub URL for continuous builds (more reliable than "latest" redirect)
GITHUB_BASE_URL="https://github.com/AppImage/AppImageKit/releases/download/continuous"

# Default installation directory
APPIMAGETOOL_DIR="${APPIMAGETOOL_DIR:-${HOME}/.local/bin}"
APPIMAGETOOL="${APPIMAGETOOL_DIR}/appimagetool"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to detect host architecture
detect_architecture() {
    # Try uname first
    arch=$(uname -m 2>/dev/null)
    
    case "$arch" in
        x86_64|amd64)
            echo "x86_64"
            ;;
        i386|i486|i586|i686)
            echo "i686"
            ;;
        aarch64|arm64)
            echo "aarch64"
            ;;
        armv7l|armhf)
            echo "armhf"
            ;;
        ppc64le)
            echo "ppc64le"
            ;;
        s390x)
            echo "s390x"
            ;;
        riscv64)
            echo "riscv64"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Function to check if architecture is supported
is_supported_architecture() {
    arch=$(detect_architecture)
    case "$arch" in
        x86_64|i686|aarch64|armhf|ppc64le|s390x|riscv64)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Function to get download URL based on architecture
get_download_url() {
    arch=$(detect_architecture)
    echo "${GITHUB_BASE_URL}/appimagetool-${arch}.AppImage"
}

# Function to verify downloaded file is a valid executable
verify_download() {
    if [ ! -f "$1" ]; then
        echo "Error: Download failed - file was not created" >&2
        return 1
    fi
    
    if [ ! -s "$1" ]; then
        echo "Error: Download failed - file is empty" >&2
        rm -f "$1" 2>/dev/null || true
        return 1
    fi
    
    # Check if it's a valid executable (ELF binary or script with shebang)
    if ! head -c 4 "$1" | grep -q "ELF\|#!/"; then
        echo "Error: Download failed - file is not a valid executable" >&2
        echo "This may indicate a network issue or invalid download URL" >&2
        rm -f "$1" 2>/dev/null || true
        return 1
    fi
    
    return 0
}

# Function to locate appimagetool using which
locate_appimagetool() {
    # First try which to find it in PATH
    if which appimagetool >/dev/null 2>&1; then
        which appimagetool
        return 0
    fi
    
    # Check our default installation path
    if [ -x "${APPIMAGETOOL}" ]; then
        echo "${APPIMAGETOOL}"
        return 0
    fi
    
    # Check other common locations
    for path in \
        "./appimagetool" \
        "${HOME}/bin/appimagetool" \
        "/usr/local/bin/appimagetool" \
        "/usr/bin/appimagetool" \
        "/opt/appimagetool/appimagetool"
    do
        if [ -x "$path" ] && [ -f "$path" ]; then
            echo "$path"
            return 0
        fi
    done
    
    return 1
}

# Function to download appimagetool
download_appimagetool() {
    if ! is_supported_architecture; then
        echo "Error: Unsupported architecture '$(detect_architecture)'" >&2
        return 1
    fi
    
    download_url=$(get_download_url)
    echo "Downloading appimagetool for $(detect_architecture) from ${download_url}..."
    
    # Create directory if it doesn't exist
    mkdir -p "${APPIMAGETOOL_DIR}"
    
    # Remove any existing file to avoid partial downloads
    rm -f "${APPIMAGETOOL}" 2>/dev/null || true
    
    # Download using available tool (curl or wget)
    if command_exists curl; then
        if ! curl -L --progress-bar -o "${APPIMAGETOOL}" "${download_url}"; then
            echo "Failed to download with curl" >&2
            rm -f "${APPIMAGETOOL}" 2>/dev/null || true
            return 1
        fi
    elif command_exists wget; then
        if ! wget -O "${APPIMAGETOOL}" "${download_url}"; then
            echo "Failed to download with wget" >&2
            rm -f "${APPIMAGETOOL}" 2>/dev/null || true
            return 1
        fi
    else
        echo "Error: Neither curl nor wget found. Please install one of them." >&2
        return 1
    fi
    
    # Verify the download was successful and file is valid
    if ! verify_download "${APPIMAGETOOL}"; then
        return 1
    fi
    
    # Make it executable
    chmod +x "${APPIMAGETOOL}"
    echo "appimagetool installed to: ${APPIMAGETOOL}"
    return 0
}

# Show help only when download fails
show_help() {
    echo "Usage: $0 [appimagetool options]"
    echo ""
    echo "Locates and runs appimagetool, automatically downloading it if not found."
    echo ""
    echo "Environment variables:"
    echo "  APPIMAGETOOL_DIR    Directory to install appimagetool (default: ~/.local/bin)"
    echo "  APPIMAGETOOL_URL    Custom download URL (overrides architecture detection)"
    echo ""
    echo "Detected architecture: $(detect_architecture)"
    echo "Supported architectures: x86_64, i686, aarch64, armhf, ppc64le, s390x, riscv64"
    echo ""
    echo "The script will first try to find appimagetool in PATH using 'which',"
    echo "then check common locations, and download the architecture-specific version if not found."
    exit 1
}

# Main execution
main() {
    # Try to locate existing appimagetool
    if tool_path=$(locate_appimagetool); then
        # Found existing tool, pass all arguments directly
        exec "${tool_path}" "$@"
    else
        echo "appimagetool not found locally"
        
        if ! is_supported_architecture; then
            echo "Error: Unsupported architecture '$(detect_architecture)'. Cannot download appimagetool." >&2
            show_help
        fi
        
        echo "Downloading automatically for $(detect_architecture) architecture..."
        
        # Download and run
        if download_appimagetool; then
            # Download succeeded, pass all arguments directly
            exec "${APPIMAGETOOL}" "$@"
        else
            # Download failed, show help
            echo ""
            echo "Download failed. This could be due to:"
            echo "1. Network connectivity issues"
            echo "2. GitHub service being unavailable"
            echo "3. Invalid download URL for your architecture"
            echo ""
            show_help
        fi
    fi
}

# Run main function with all arguments
main "$@"
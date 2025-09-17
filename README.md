# [Multiplatform Java desktop application template](https://github.com/okhlybov/java-desktop-app)

It is intended to be a starting point for a custom project which can be derived through gradual refactoring.

## Features

* Portable [Gradle](https://gradle.org/) project
* Multi-module Java application split into a backend and a set of frontends
* Command-line application frontend
* [JavaFX](https://openjfx.io/) graphic application frontend
* Single file self-contained ***Linux*** application built with [AppImage](https://appimage.org/)
* Full-fledged self-contained ***Windows*** installer built with [Inno Setup](https://jrsoftware.org/isinfo.php)

## Prerequisites

* 64-bit Windows 10+ or Linux
* Platform-specific Java JDK 17-24

The above Java development kit should be capable of just running the Gradle wrapper itself; the rest of the toolchain (including platform-specific parts) will be downloaded and configured automagically. If no JDK is installed yet, an [Adoptium Temurin](https://adoptium.net/temurin/releases/?version=17)
runtime is a solid choice.

The provided build scripts locate and use the respective locally installed AppImage and Inno Setup tools and make an attempt to download and install them if not found.

The Inno Setup compiler can also be installed [manually](https://jrsoftware.org/isdl.php) or through WinGet

```shell
winget install --id JRSoftware.InnoSetup -e -s winget -i
```

## Kickstart

### Obtain this project's source

```shell
git clone https://github.com/okhlybov/java-desktop-app
```

### Get into the source directory and execute

__Windows__

```shell
gradlew.bat clean release
```

__Linux__

```shell
sh gradlew clean release
```

### Run the artifact

__Windows__

The resulting artifact `runtime/build/release/app-???.exe` is a regular Windows installer which installs the app into the system, sets up the PATH environment variable for access to `app` and `appfx` commands via the command line and creates a desktop icon for the GUI frontend.

__Linux__

The resulting artifact `runtime/build/release/app-???.AppImage` is a relocatable self-contained single file executable which can be run as is for the CLI frontend and with `-g` (`--gui`) flag for the GUI frontend.

_Don't forget to make the artifact executable with chmod +x_

# Cross-compiling

In general, the system-specific installer should be built on a host system which matches the target system it is intended to be used on. However, some cross-builing in possible on a Windows host which can build Linux artifacts. This is done though the Windows' [WSL](https://learn.microsoft.com/en-us/windows/wsl/) subsystem. _Sadly the reverse is not (yet) possible with WINE which means that a real (albeit virtualized) Windows installation is required for building Windows installers._

The tested configurations are presented below.

Here are the distro-specific packages which suffice to build final AppImage artifacts:

__Arch Linux__

```shell
pacman -Syu jdk-openjdk binutils sudo fuse2
```

__Debian Linux__

```shell
sudo apt-get install default-jdk binutils curl file fuse libfuse2
```

_The modern Ubuntu seems to [ditch](https://github.com/appimage/appimagekit/wiki/fuse) the required fuse2 package in favor of the fuse3 thus rendering the AppImage unusable._

With the system of choice properly installed and configured, the final Linux artifact can be built from the Windows command line with

```cmd
wsl -d <distro id> sh gradlew clean release
```

### WSL2 host remarks

Issue the following command to (likely) solve permissions problems in the Linux container should they arise

```shell
echo -e '\n[automount]\nenabled = true\noptions = "metadata,umask=22,fmask=11"'  | sudo tee -a /etc/wsl.conf > /dev/null
```

After that, shutdown the WSL subsystem

```cmd
wsl --shutdown
```

### TODO

* More package atrifacts (Flatpak?, WiX?)
* Runtimeless platform-neutral ZIPs for distro-specific packaging
* MacOSX support

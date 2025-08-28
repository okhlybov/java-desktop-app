@echo off

rem https://github.com/okhlybov/isx
rem Locate and invoke Inno Setup command-line compiler (iscc.exe)
rem Exit codes: 0 on success, 127 on failure to locate or install iscc.exe

:start

rem Check if a custom ISCC path is defined and valid
if defined ISCC (
    if exist "%ISCC%" (
        goto :iscc
    )
)

rem Check if iscc.exe is in PATH and get its location
where /q iscc.exe
if %errorlevel%==0 (
    for /f "delims=" %%a in ('where iscc.exe') do (
        if exist "%%a" (
            set "ISCC=%%a"
            goto :iscc
        )
    )
)

rem Check registry for Inno Setup installation
for %%r in (
    "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
    "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
) do (
    for /f "delims=" %%k in ('reg query "%%r" /s /f "Inno Setup" 2^>nul ^| findstr "Inno Setup"') do (
        for /f "skip=2 tokens=2,*" %%a in ('reg query "%%k" /v InstallLocation 2^>nul') do (
            if exist "%%b\iscc.exe" (
                set "ISCC=%%b\iscc.exe"
                goto :iscc
            )
        )
    )
)

rem Check common installation directories
for %%p in ("%localappdata%\Programs" "%programfiles%" "%programfiles(x86)%") do (
    for /d %%s in ("%%~p\Inno Setup *") do (
        if exist "%%s\iscc.exe" (
            set "ISCC=%%s\iscc.exe"
            goto :iscc
        )
    )
)

rem Check if winget is available
where /q winget
if %errorlevel% neq 0 (
    echo Error: winget is not installed or not found in PATH
    exit /b 127
)

rem Prevent infinite recursion by checking winget attempts
if "%WINGET_ATTEMPTED%"=="1" (
    echo Error: winget installation attempted but iscc.exe still not found
    exit /b 127
)

echo iscc.exe not found in ISCC, [PATH] or default Inno Setup locations

rem Attempt to install Inno Setup via winget
echo Attempting to install Inno Setup silently using winget...
winget install --id JRSoftware.InnoSetup --silent --accept-source-agreements --accept-package-agreements
set WINGET_ATTEMPTED=1
if %errorlevel%==0 (
    echo Inno Setup installed successfully, restarting search...
    goto :start
)

rem If winget installation fails, exit with error
echo Error: Failed to install Inno Setup via winget
exit /b 127

:iscc

rem Validate ISCC path
if not exist "%ISCC%" (
    echo Error: Invalid ISCC path: %ISCC%
    exit /b 127
)

rem Clear winget attempt flag before invocation
set WINGET_ATTEMPTED=

rem Execute the compiler
echo Executing Inno Setup compiler: %ISCC%
"%ISCC%" %*

exit /b %errorlevel%
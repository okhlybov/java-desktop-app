@echo off

rem https://github.com/okhlybov/isx
rem Locate & invoke Inno Setup command-line compiler

if "%ISCC%" == "" set ISCC=iscc.exe

where /q %ISCC%

if %errorlevel% == 0 goto :iscc

for %%r in ("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Inno Setup 6_is1" "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Inno Setup 6_is1") do (
  for /f "skip=2 tokens=2,*" %%a in ('reg query %%r /v InstallLocation 2^>nul') do (
      if exist "%%b\iscc.exe" (
          set ISCC=%%b%iscc.exe
          goto :iscc
      )
  )
)

for %%s in ("Inno Setup 6" "Inno Setup 5") do (
    for %%p in ("%programfiles%" "%programfiles(x86)%") do (
        if exist "%%~p\%%~s\iscc.exe" (
           set ISCC=%%~p\%%~s\iscc.exe
           goto :iscc
        )
    )
)

echo "iscc.exe is not found in ISCC, [PATH] or default Inno Setup locations"
exit /b 127

:iscc

echo Executing %ISCC%

"%ISCC%" %*
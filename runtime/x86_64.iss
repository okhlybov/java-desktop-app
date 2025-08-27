#define MyAppName "App"
#define MyPackageName "app"
#define MyPlatform "x86_64"

[Setup]

AppCopyright=Copyright (C) 2025 Oleg A. Khlybov
AppName={#MyAppName}
AppPublisher=Oleg A. Khlybov
AppPublisherURL=https://github.com/okhlybov/java-desktop-app
AppVerName={#MyAppName} {#MyAppVersion}
AppVersion={#MyAppVersion}
AppId={{3A059274-88F6-4D54-A057-C19DF878564D}
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
ChangesEnvironment=yes
Compression=lzma2/max
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableFinishedPage=yes
InfoAfterFile=README
LicenseFile=LICENSE
MinVersion=10.0
OutputBaseFilename={#MyPackageName}-{#MyPlatform}-{#MyAppVersion}
OutputDir=..\..\release
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
SolidCompression=yes
SourceDir=build\jpackage\app
UninstallFilesDir={app}\uninstall
WizardStyle=modern


[Files]

Source: "*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs sortfilesbyextension setntfscompression

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\appfx.exe"


[Tasks]
Name: "path"; Description: "Include program directory in PATH"

[Code]

#include "path.iss"

procedure RegisterPaths;
begin
  if WizardIsTaskSelected('path') and IsAdminInstallMode then RegisterPath('{app}', SystemPath, Prepend);
  if WizardIsTaskSelected('path') and not IsAdminInstallMode then RegisterPath('{app}', UserPath, Prepend);
end;
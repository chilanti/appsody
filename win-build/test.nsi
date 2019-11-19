# Setup
#
!include 'LogicLib.nsh'
# Select install dir
PageEx directory
	PageCallbacks prepDir "" ""
	DirText "Select Appsody installation folder"
PageExEnd
Page instfiles
Function prepDir
	StrCpy $INSTDIR "$PROGRAMFILES64\Appsody"
FunctionEnd

# set the name of the installer

Outfile "test_installer.exe"

Name "Appsody"
BrandingText "Appsody Installer"

#
# create the Appsody CLI section.
Section "Appsody CLI"
 
MessageBox MB_OKCANCEL|MB_ICONQUESTION "Do you want to install Appsody on $INSTDIR?" /SD IDOK IDCANCEL aborting
Goto justinstall
aborting:
Abort "Installation was cancelled"

justinstall:
SetOutPath $INSTDIR

File appsody.exe
File appsody-setup.bat
File README.md
File LICENSE
WriteUninstaller $INSTDIR\unistall.exe
StrCpy $1 "$INSTDIR\appsody-setup.bat"

nsExec::ExecToLog $1 
Pop $0
Pop $1
Var /GLOBAL RC
${If} $0 == 0
	MessageBox MB_OK "Appsody installation successful!"
${ElseIf} $0 == 10
	MessageBox MB_OK "Appsody installation successful, but Docker was not detected."
${ElseIf} $0 == 20
	MessageBox MB_OK "Appsody installation successful, but Docker does not have the right permission on your file system. Check https://appsody.dev/docs/docker-windows-aad/ for a possible resolution"
${ElseIf} $0 == 100
	SetErrors
	MessageBox MB_OK "Appsody installation failed. Check installation log by closing this window and clicking Details." 
${EndIf}
SectionEnd
Section "Uninstall"
	Delete $INSTDIR\*.*
	MessageBox MB_OK "Appsody was uninstalled - you may also want to cleanup your $$HOME/.appsody directory"
SectionEnd
#Function that calls a messagebox when installation finished correctly

Function .onUserAbort
   MessageBox MB_YESNO "Cancel installation?" IDYES NoCancelAbort
     Abort ; causes installer to not quit.
   NoCancelAbort:
FunctionEnd

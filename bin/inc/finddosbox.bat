@Echo Off

SetLocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

Set "DBOX_CMD="

Echo|Set /p _="Looking for DOSBox... "

If Not Defined DBOX_CMD (
	set "ERRORLEVEL="
	Where dosbox-x.exe > nul 2>&1
	If !ERRORLEVEL! EQU 0 (
		Set "DBOX_CMD=dosbox-x.exe"
	)
)

IF Not Defined DBOX_CMD (
	IF Exist "C:\DOSBox-X\dosbox-x.exe" (
		Set DBOX_CMD="C:\DOSBox-X\dosbox-x.exe"
	)
)

If Not Defined DBOX_CMD (
	set "ERRORLEVEL="
	Where dosbox.exe > nul 2>&1
	If !ERRORLEVEL! EQU 0 (
		Set "DBOX_CMD=dosbox.exe"
	)
)

IF Not Defined DBOX_CMD (
	IF Exist "C:\Program Files (x86)\DOSBox-0.74-3\dosbox.exe" (
		Set DBOX_CMD="C:\Program Files (x86)\DOSBox-0.74-3\dosbox.exe"
	)
)

EndLocal & Set "DBOX_CMD=%DBOX_CMD%"

If Defined DBOX_CMD (
	Echo found! [%DBOX_CMD%]
) Else (
	Echo not found!
	Pause
	Exit 1
)

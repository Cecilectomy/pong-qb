@Echo Off

SetLocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

Set "QB64_CMD="

Echo|Set /p _="Looking for QB64... "

If Not Defined QB64_CMD (
	set "ERRORLEVEL="
	Where qb64pe.exe > nul 2>&1
	If !ERRORLEVEL! EQU 0 (
		Set "QB64_CMD=qb64pe.exe"
	)
)

IF Not Defined QB64_CMD (
	IF Exist "C:\qb64pe\qb64pe.exe" (
		Set QB64_CMD="C:\qb64pe\qb64pe.exe"
	)
)

If Not Defined QB64_CMD (
	set "ERRORLEVEL="
	Where qb64.exe > nul 2>&1
	If !ERRORLEVEL! EQU 0 (
		Set "QB64_CMD=qb64.exe"
	)
)

IF Not Defined QB64_CMD (
	IF Exist "C:\qb64\qb64.exe" (
		Set QB64_CMD="C:\qb64\qb64.exe"
	)
)

EndLocal & Set "QB64_CMD=%QB64_CMD%"

If Defined QB64_CMD (
	Echo found! [%QB64_CMD%]
) Else (
	Echo not found!
	Pause
	Exit 1
)

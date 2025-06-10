@Echo Off

PushD .

CD %~dp0

Call inc\findqb64.bat

CD ..

Call %QB64_CMD% || (
    Pause
    Exit 1
)

PopD

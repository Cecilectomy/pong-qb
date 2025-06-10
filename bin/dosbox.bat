@Echo Off

PushD .

CD %~dp0

Call inc\finddosbox.bat

CD ..

Call %DBOX_CMD% -conf bin\conf\dosbox.windows.conf -noconsole || (
    Pause
    Exit 1
)

PopD

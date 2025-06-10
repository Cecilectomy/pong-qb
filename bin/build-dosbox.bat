@Echo Off

PushD .

CD %~dp0

Call inc\finddosbox.bat

CD ..

If Not Exist build Mkdir build

Echo|Set /p _="Building... "
Call %DBOX_CMD% -conf bin\conf\dosbox.windows.conf -noconsole -exit -c "BIN\BUILD\DOS.BAT" -c "EXIT 1" >NUL 2>&1 && (Echo done) || (
    Echo failed!
    Pause
    Exit 1
)

PopD

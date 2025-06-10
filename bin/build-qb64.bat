@Echo Off

PushD .

CD %~dp0

Call inc\findqb64.bat

CD ..

If Not Exist build Mkdir build

Echo|Set /p _="Building... "
Call %QB64_CMD% -c pong.qb64.bas -o build\PONG.QB64.EXE >NUL 2>&1 && (Echo done) || (
    Echo failed!
    Pause
    Exit 1
)

PopD

@echo off
title Choose a Game
:choose
set /p name=Please choose a game: 

start bin/win32/quiver.exe -game %name% -windowed
exit
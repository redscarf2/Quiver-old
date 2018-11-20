@echo off
title VPC Complete Project File Generator
REM // this gets inputs from the user, then selects the options to goto from them, and continues going back and forth
REM // between the executing whats in the options and selecting the options, until there are no more, 
REM // and then it dumps everything into the vpc command line, which you see a preview of it before you run it
:choose
set /p mksln=Create New Solution File? (y or nothing): 
if "%mksln%" == "y" (set /p sln_name=Enter a name for the solution file:)

set /p compiler=Use win64 compiler? (y or nothing for win32): 
REM maybe use the same system for groups for vsversion?
set /p vsversion=Choose a VS version (nothing for 2013): 
set /p force=Force Rebuild all projects? (y or nothing): 

REM Groups
echo Choose groups to build:
echo - nothing for everything
echo - 1 for binary files
echo - 2 for libraries
echo - 3 for gamedlls
echo - 4 for hammer
echo - 5 for shaders
echo - 6 for physics
echo - 7 for tools
echo - 8 for game
echo - or type in 0 to type in a group: 
echo -------------------------------------
echo (no spaces allowed, commas not needed)
set /p group="Selections: "

REM ==========================================
REM Projects
REM /hl2 /cstrike /dod /hl2mp /episodic /tf /portal /hl1 /lostcoast

echo Choose projects to build:
echo - nothing for all default projects
echo - 0 for no projects
echo - 1 for hl2
echo - 2 for hl2mp
echo - 3 for episodic
echo - 4 for lostcoast
echo - or type in P to type in a project: 
echo -------------------------------------
echo (no spaces allowed, commas not needed)
set /p project="Selections: "

REM ========================================================================================================================

:select_mksln
if "%mksln%" == "y" ( goto make_sln
) else goto dont_make_sln

:select_compiler
if "%compiler%" == "y" ( goto win64
) else goto win32

:select_vsversion
if "%vsversion%" == "2015" ( goto 2015
) else if "%vsversion%" == "2013" ( goto 2013
) else goto 2013

:select_force
if "%force%" == "y" ( goto rebuild
) else goto dont_rebuild

REM ============================================================
REM groups

:select_group_everything
REM checks if the variable is empty
if [%group%] == [] (set grp_all=+everything & goto select_project_default
) else goto select_group_0

:select_group_0
REM for some reason, when you select a project, this doesnt work
REM this searches for the character 0 in %group%, and goes to group_custom if it finds it, else it goes to select_group_1
(echo %group% | findstr /i /c:"0" >nul) && (goto group_add) || (goto select_group_1)

:select_group_1
REM this searches for the character 1 in %group%, and goes to group_1 if it finds it, else it goes to select_group_2
(echo %group% | findstr /i /c:"1" >nul) && (goto group_1) || (goto select_group_2)

:select_group_2
(echo %group% | findstr /i /c:"2" >nul) && (goto group_2) || (goto select_group_3)

:select_group_3
(echo %group% | findstr /i /c:"3" >nul) && (goto group_3) || (goto select_group_4)

:select_group_4
(echo %group% | findstr /i /c:"4" >nul) && (goto group_4) || (goto select_group_5)

:select_group_5
(echo %group% | findstr /i /c:"5" >nul) && (goto group_5) || (goto select_group_6)

:select_group_6
(echo %group% | findstr /i /c:"6" >nul) && (goto group_6) || (goto select_group_7)

:select_group_7
(echo %group% | findstr /i /c:"7" >nul) && (goto group_7) || (goto select_group_8)

:select_group_8
(echo %group% | findstr /i /c:"8" >nul) && (goto group_8) || (goto select_project_default)

REM ============================================================
REM projects

:select_project_default
REM this is for default projects
if [%project%] == [] (set proj_all=/hl2 /hl2mp /episodic /lostcoast & goto createprojects
) else goto select_project_add

:select_project_add
REM this is for adding custom projects
(echo %project% | findstr /i /c:"P" >nul) && (goto project_add) || (goto select_project_0)

:select_project_0
REM this is for no projects
(echo %project% | findstr /i /c:"0" >nul) && (goto project_0) || (goto select_project_1)

:select_project_1
(echo %project% | findstr /i /c:"1" >nul) && (goto project_1) || (goto select_project_2)

:select_project_2
(echo %project% | findstr /i /c:"2" >nul) && (goto project_2) || (goto select_project_3)

:select_project_3
(echo %project% | findstr /i /c:"3" >nul) && (goto project_3) || (goto select_project_4)

:select_project_4
(echo %project% | findstr /i /c:"4" >nul) && (goto project_4) || (goto createprojects)

REM ========================================================================================================================
REM ========================================================================================================================

REM ==============================
REM Solution File
:make_sln
set mksln=/mksln
goto select_compiler

:dont_make_sln
set mksln=
goto select_compiler

REM ==============================
REM Compilers
:win32
set compiler=
goto select_vsversion

:win64
set compiler=/define:WIN64
goto select_vsversion

REM ==============================
REM VS versions
:2013
set vsversion=/2013
goto select_force

:2015
set vsversion=/define:2015
goto select_force

REM ==============================
REM Force Rebuild Projects
:rebuild
set force=/f
goto select_group_everything

:dont_rebuild
set force=
goto select_group_everything

REM ==============================
REM Groups

:group_add
echo ------------------------------
echo Enter project groups you want
echo make sure each group looks like this: +example
echo and space each word out

set /p grp_add=Groups: 
echo ------------------------------
goto select_group_1

:group_1
set grp_01=+bin
goto select_group_2

:group_2
set grp_02=+libraries
goto select_group_3

:group_3
set grp_03=+gamedlls
goto select_group_4

:group_4
set grp_04=+hammer
goto select_group_5

:group_5
set grp_05=+shaders
goto select_group_6

:group_6
set grp_06=+physics
goto select_group_7

:group_7
set grp_07=+tools
goto select_group_8

:group_8
set grp_08=+game
goto createprojects

REM idk what im doing at this point
REM :group_combine
REM set groups="%grp_all% %grp_custom% %grp_01% %grp_02% %grp_03% %grp_04% %grp_05% %grp_06% %grp_07% %grp_08%"

REM ==========================================================================================
REM Projects

:project_add
echo ------------------------------
echo Enter projects you want
echo make sure each project looks like this: /example
echo and space each word out

set /p proj_add=Projects: 
echo ------------------------------
goto select_project_1

:project_0
set proj_default="/hl2 /hl2mp /episodic /lostcoast"

:project_1
set proj_01=/hl2
goto select_project_2

:project_2
set proj_02=/hl2mp 
goto select_project_3

:project_3
set proj_03=/episodic
goto select_project_4

:project_4
set proj_04=/lostcoast
goto createprojects


:createprojects
echo =============================================
echo Current VPC command line:
echo %grp_all% %grp_add% %grp_01% %grp_02% %grp_03% %grp_04% %grp_05% %grp_06% %grp_07% %grp_08% %force% %proj_default% %proj_all% %proj_add% %proj_01% %proj_02% %proj_03% %proj_04% %mksln% "%sln_name%" %vsversion% %compiler%
pause
echo =============================================
REM can i merge all the groups into one variable? %groups%? maybe with projects as well?
devtools\bin\vpc %grp_all% %grp_add% %grp_01% %grp_02% %grp_03% %grp_04% %grp_05% %grp_06% %grp_07% %grp_08% %force% %proj_default% %proj_all% %proj_add% %proj_01% %proj_02% %proj_03% %proj_04% %mksln% "%sln_name%" %vsversion% %compiler%
pause
exit

@echo off

setlocal EnableDelayedExpansion
set nppexe="C:\Program Files\Notepad++\notepad++.exe"
set toolsdir=D:\Git\misc-scripts\tools
set ditatmpldir=D:\Git\ditawise\downloads\templates
set ditadir=D:\SnapLogic\Git-Snap


for %%v in ( usage help ) do  if _%1_ == _%%v_  goto :usage


:. Is %1 a label in this batch file?
for /f "usebackq" %%v in ( `findstr /i "^:" %~f0` ) do  @if _:%1_ equ _%%v_  goto :%1

:. Is it a non-existent file with a .dita extension?
:. Only works with %1.
if not exist %1  (
  if _%~x1_ equ _.dita_  (
    set tmpl=D:\SnapLogic\Git-Snap\docs-dita\src\public-apis\template-snap-api.dita
    PowerShell.exe -Command "& Get-Content !tmpl! | ForEach-Object { $_.replace( 'zzz', '%~n1' ) } | Set-Content %1"
    goto :catchall
  )
)


goto :catchall


:catchall
%nppexe% %*
goto :cleanup


:usage
echo USAGE:
for /f "usebackq" %%v in ( `findstr /i "^:" %~f0` ) do  @if _:%1_ equ _%%v_  echo   %0 %%v
goto :eof


:cleanup
for %%v in ( nppexe toolsdir ) do set %%v=
endlocal

@echo off
: ----------------------------------------
: Prerequisites:
:   * Docker - Required to run the DITA-OT build on a container.
:       https://hub.docker.com/
:   * Node.js and http-server - (Optional) Runs a local webserver.
:       https://nodejs.org/en/download/
:       npm -v
:       npm install http-server -g
: ----------------------------------------

cls
color 0E

if _%1_ equ _startsrvr_  goto %1

set basedir=%USERPROFILE%\g\Git\docs-dita
  if _%1_ neq __  set basedir=%1
set outdir=html5
set container=ditabld


cd /d %basedir%

:. Kill any running http-server. To install, run 'npm install http-server -g'.
taskkill /f /fi "windowtitle eq http-server" /t >nul

:. Delete the target output directory.
if exist %outdir%\*  rd /s /q %outdir% >nul


:. Source: https://www.dita-ot.org/dev/topics/using-docker-images.html#ariaid-title1
docker rm %container%
docker run -it  --name %container%  -v %basedir%:/dita ghcr.io/dita-ot/dita-ot:3.6.1  -i /dita/src/sldocs.ditamap  -o /dita/%outdir%  -f html5  --propertyfile /dita/src/sldocs.properties  -v


:. Copy other files.
echo f | xcopy %basedir%\src\_theme\sldocs.js %basedir%\%outdir%\theme\sldocs.js /i /v /y

if exist %basedir%/%gitsub%/%outdir%/index.html  (
  start /min %0 startsrvr
  timeout /t 1
  start http://localhost:8080/index.html
)


goto :eof


:startsrvr
  cd /d %basedir%/%gitsub%/%outdir%
  http-server
goto :eof

:Usage
echo.
echo USAGE:  %0 basedir

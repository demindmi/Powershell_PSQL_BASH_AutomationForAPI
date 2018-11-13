@echo off

set mypath=%~dp0

echo.
echo -----===Development===-----
echo.


set PGPASSWORD=*********
psql -h HOST -U USERNAME -d DATABASE NAME -p 5477 -f "%mypath%\Inventory.sql" -v path=mypath
set PGPASSWORD=

echo.
echo Completed
echo.
PAUSE




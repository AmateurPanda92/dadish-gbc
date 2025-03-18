@echo off

set compilerPath=..\Build\GBDK-2020\bin\lcc
set outputDirectory=..\Output
set outputFilename=Dadish.gb
set mainSourceFilePath=..\Source\Main.c

%compilerPath% -o ^
    %outputDirectory%\%outputFilename% ^
    %mainSourceFilePath%

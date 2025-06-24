@echo off

set projectRootPath=..
set returnPath=Scripts

cd %projectRootPath%

make

cd %returnPath%

@echo off
rem simplified replacement for the original shell script

set XCFLAGS="-I%~dp0%..\include"
set XLIBS1="-L%~dp0%..\lib" -lgsl -lgslcblas
set XLIBS2="-L%~dp0%..\lib" -lgsl
set XVERSION=2.7.1
set XPREFIX="%~dp0%..\"

for %%p in (%*) do (
  if x%%p == x--cflags     echo %XCFLAGS%
  if x%%p == x--libs       echo %XLIBS1%
  if x%%p == x--libs-without-cblas echo %XLIBS2%
  if x%%p == x--version    echo %XVERSION%
  if x%%p == x--prefix     echo %XPREFIX% 
)

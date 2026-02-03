# gccinstaller

I made this because manually installing gcc on Windows is a hassle.(Wasted enough time reinstalling it manually)

This is a one click installer for installing gcc.

## Important
- **DO NOT run this as administrator**
- Just double-click it normally
- Uses scoop btw
- 
## What it does
- Installs Scoop if its not present
- Installs GCC (MinGW-w64)
- Installs 7Zip
- Adds Scoop  to ur user path

## Known bugs
Sometimes it prints:
Something went wrong.

but gcc installed fine please check in a new terminal if 
gcc --version works if so it installed fine

## Requirements
- windows 10/11
- PowerShell
- internet

How to check if it installed:
open a new terminal and enter:
gcc --version

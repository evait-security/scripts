#!/bin/zsh

x86_64-w64-mingw32-g++ -c -DBUILDING_EXAMPLE_DLL add_user.cpp
x86_64-w64-mingw32-g++ -shared -o add_user.dll add_user.o -Wl,--out-implib,add_user.a

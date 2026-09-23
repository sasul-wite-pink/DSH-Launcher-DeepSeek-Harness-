' ============================================================
'  DeepSeek Harness one-click stopper
'  Double-click to stop the DeepSeek Harness running in the background.
'
'  To change the port, edit the PORT constant below.
' ============================================================
Option Explicit

Const PORT = "3080"

Dim sh
Set sh = CreateObject("WScript.Shell")

' End only the process listening on PORT (DeepSeek Harness),
' leaving other Node programs untouched.
Dim psCmd
psCmd = "Get-NetTCPConnection -LocalPort " & PORT & " -State Listen -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess -Unique | ForEach-Object { Stop-Process -Id $_ -Force }"
sh.Run "powershell -NoProfile -Command " & Chr(34) & psCmd & Chr(34), 0, False

WScript.Sleep 800
MsgBox "DeepSeek Harness stopped.", 64, "DeepSeek Harness"

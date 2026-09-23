' ============================================================
'  DeepSeek Harness one-click launcher
'  Double-click to start the web UI without opening a terminal.
'
'  It will:
'    1) open the browser directly if the server is already up
'    2) otherwise start the server hidden (no console window)
'    3) wait until it is ready, then open the browser
'
'  To change the port, edit the URL constant below.
' ============================================================
Option Explicit

Const URL = "http://127.0.0.1:3080"

Dim sh, fso
Set sh = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' 1) Already running? Just open the browser.
If ServerUp() Then
    OpenBrowser
    WScript.Quit
End If

' 2) Start the server hidden (no window).
Dim startCmd
startCmd = BuildStartCommand()
If startCmd = "" Then
    MsgBox "DeepSeek Harness was not found." & vbCrLf & vbCrLf & _
           "Please install it first, for example:" & vbCrLf & _
           "  npm install -g @deepseek-ai/dsh", 48, "DeepSeek Harness"
    WScript.Quit
End If
sh.Run "cmd /c " & Chr(34) & startCmd & Chr(34), 0, False

' 3) Wait until ready (up to ~45 s), then open the browser.
Dim i
For i = 1 To 45
    WScript.Sleep 1000
    If ServerUp() Then Exit For
Next
OpenBrowser

' ---------- helpers ----------

Sub OpenBrowser()
    sh.Run URL
End Sub

Function BuildStartCommand()
    ' 1) Globally installed dsh command (npm install -g @deepseek-ai/dsh)
    If fso.FileExists(GlobalDshCmd()) Then
        BuildStartCommand = "dsh web"
        Exit Function
    End If
    ' 2) Direct node + bin.js from the npx cache (fast, works offline)
    Dim bin
    bin = FindDshBin()
    If bin <> "" Then
        BuildStartCommand = "node " & Q(bin) & " web"
        Exit Function
    End If
    ' 3) npx fallback
    BuildStartCommand = "npx --yes @deepseek-ai/dsh web"
End Function

Function GlobalDshCmd()
    GlobalDshCmd = sh.ExpandEnvironmentStrings("%APPDATA%") & "\npm\dsh.cmd"
End Function

Function FindDshBin()
    Dim base
    base = sh.ExpandEnvironmentStrings("%LOCALAPPDATA%") & "\npm-cache\_npx\"
    If Not fso.FolderExists(base) Then Exit Function
    Dim folder, candidate
    For Each folder In fso.GetFolder(base).SubFolders
        candidate = folder.Path & "\node_modules\@deepseek-ai\dsh\lib\bin.js"
        If fso.FileExists(candidate) Then
            FindDshBin = candidate
            Exit Function
        End If
    Next
End Function

Function Q(text)
    Q = Chr(34) & text & Chr(34)
End Function

Function ServerUp()
    On Error Resume Next
    Dim http
    Set http = CreateObject("MSXML2.ServerXMLHTTP.6.0")
    http.setTimeouts 1500, 1500, 1500, 1500
    http.open "GET", URL & "/", False
    http.send
    If Err.Number = 0 Then
        ServerUp = True
    Else
        ServerUp = False
    End If
    Err.Clear
    On Error GoTo 0
End Function

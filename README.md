## what can this module do?
1. it can search all your drivers, looking for jdk installed directories by locating javac.exe
2. it can change your jdk version by window powershell

### which are files put?
```
$env:PSModulePath -split ';'
```
> put files in modules directory
### how to use?
> PS> Change-JDK

> PS> Set-Alias -Name cj -Value Change-JDK

> PS> cj
### enjoy life!

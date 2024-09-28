function  Out-Cache {
    $data = (Get-ChildItem -Path (Get-PSDrive -PSProvider FileSystem).Root -Recurse -Filter "javac.exe" -ErrorAction SilentlyContinue).FullName
    $jdkPaths = $data 
    Write-Output "---------------List Cached JDK Path----------"
    for ( $index = 0; $index -lt $data.count; $index++ ) {
        Write-Host $data[$index] -ForegroundColor Red
        $node = $data[$index]
        $loc = $node.LastIndexOf("\") - 1
        $firstNode = $node.Substring(0, $loc)
        
        $loc = $firstNode.LastIndexOf("\")
        $jdkPaths[$index] = $firstNode.Substring(0, $loc)
    }
    Out-File -FilePath .\jdkpath.txt -InputObject $jdkPaths
    if (Test-Path -Path "jdkpath.txt" -PathType leaf) {
        Write-Output "---------------Cached JDK Path File---------"
        Write-Host (Get-ChildItem -Path "." -Filter "jdkpath.txt").FullName -ForegroundColor Blue
    }
    else {
        Write-Warning "write cache file failed,contact the author fix sh."
    }
}

function  Change-JDK {
    if (Test-Path -Path "jdkpath.txt" -PathType leaf) {
        $check = Read-Host -Prompt "Rebuild cache, default no/yes"
        if ($check.toString().ToLower() -eq "yes") {
            Out-Cache
        }
    }
    else {
        Write-Output "---------------Build JDK Path Cache File For Waiting----------"
        Out-Cache
    }
    
    $cache = Get-Content -Path .\jdkpath.txt
    
    Write-Output "---------------List Installed Jdk Path----------"
    foreach ($file in $cache) {
        Write-Host $cache.IndexOf($file)":"$file -ForegroundColor Green
    }
    
    Write-Output "---------------List Using JDK Path--------------"
    Write-Host $env:JAVA_HOME -ForegroundColor Blue
    
    while ($true) {
        $content = Read-Host -Prompt "---------------Expected Order Numbered"
        if ('' -eq $content.Trim()) {
            continue
        }
        $num = [System.Convert]::ToInt32($content)
        if (($num -ge 0) -and ($num -lt $cache.Length)) {
            $jdkFolder = $cache.get($num)
            Write-Host $jdkFolder -ForegroundColor Yellow
            [System.Environment]::SetEnvironmentVariable('JAVA_HOME', $jdkFolder, 'User')
            Write-Host "---------------Check In New Window---------------" -ForegroundColor Red
            break
        }
        else {
            $len = $cache.Length - 1
            Write-Host "---------------0<= number <=$len" -ForegroundColor Yellow
            continue
        }
    }
    
}
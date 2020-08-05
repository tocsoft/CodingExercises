$verificationTestClass = '_Tests.cs'

$folders = ((git ls-tree -d --name-only master) | Out-String)  -Split "`r`n" 

foreach($f in $folders)
{
    if([System.IO.Directory]::Exists($f)){
        $f
        
    }
}
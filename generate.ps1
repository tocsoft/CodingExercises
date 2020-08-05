$sourceBranch = 'master'
$verificationTestClass = '_Tests.cs'

$folders = (dir -Directory)

foreach($f in $folders)
{
    $testPath = "$f/$verificationTestClass"

    Remove-Item $testPath  -Force
        $fn = $f.Name.Replace('-', '') + 'Tests.cs'
       # $fn
        "$f\$fn"
        Copy-Item ("$f/$fn") $testPath

    if(Test-Path $testPath){
        ((Get-Content -path $testPath -Raw) -replace 'public class .*Tests','public class _Tests') | Set-Content -Path $testPath
        ((Get-Content -path $testPath -Raw) -replace '\(Skip = "Remove this Skip property to run this test"\)','') | Set-Content -Path $testPath
        ((Get-Content -path $testPath -Raw) -replace '\[Fact\(\)\]','[Fact]') | Set-Content -Path $testPath
        
    }
}
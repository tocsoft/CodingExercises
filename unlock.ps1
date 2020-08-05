$sourceBranch = 'remote/origin/_all_tests'
$verificationTestClass = '_Tests.cs'

$folders = ((git ls-tree -d --name-only master) | Out-String)  -Split "`r`n" 

$allPass = $true
foreach($f in $folders)
{
        if([System.IO.Directory]::Exists($f)){
            Write-Host "Verifying - $f"
            Remove-Item "$f/$verificationTestClass" -Force -ErrorAction Ignore
            $t = (git checkout $sourceBranch -- "$f/$verificationTestClass" | Out-String) 
            if($LASTEXITCODE -ne 0){
                Write-Host "Error finding test suite for - $f"
                $allPass = $false
                break
            }
            $t = ((dotnet test "$f")| Out-String)
            if($LASTEXITCODE -ne 0){
                Write-Host "Failed - $f"
                $allPass = $false
                break
            }
        }else{
            
            Write-Host "Unlocked - $f"
            # all previous items have passed
            # we should just load in a new test

            $t = (git checkout $sourceBranch -- "$f" | Out-String) 
            Remove-Item "$f/$verificationTestClass" -Force -ErrorAction Ignore
            dotnet sln add "$f"
            break;
        }
}
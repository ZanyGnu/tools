$sourceLocation = G:\rdnext\Azure\Compute\src
$from = "zanygnu@zanygnu.com"
$cc = "zanygnu@zanygnu.com"
$to = "zanygnu@zanygnu.com"

function Send-Mail {
    param(
     [Parameter(Mandatory=$true)]
     [String[]] $to,
     $commitDetails)

    send-mailmessage `
        -from $from `
        -t $to  `
        -cC $cc `
        -BodyAsHtml `
        -subject "Merge request: master needs to be merged into core" `
        -body "$commitDetails" `
        -smtpServer smtphost
} 

pushd $sourceLocation

git log -n 1 --pretty=format:"%H" master | tee-object -Variable latestCommitInMaster
git log -n 1 $latestCommitInMaster | tee-object -Variable latestCommitInMasterDetails

git branch -r --contains $latestCommitInMaster | tee-object -Variable branchList

if ($branchList.Contains("origin/core")) {
    Write-Host Core is up to date.
} else { 
    Write-Host "Core is missing a merge from master (commit $latestCommitInMaster)"
    Send-Mail -to $to -commitDetails $latestCommitInMasterDetails
}

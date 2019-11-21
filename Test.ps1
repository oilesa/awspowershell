`#Retrieve the AWS instance ID, keep trying until the metadata is available
$instanceID = "null"
while ($instanceID -NotLike "i-*") {
 Start-Sleep -s 3
 $instanceID = invoke-restmethod -uri http://169.254.169.254/latest/meta-data/instance-id
}

$username = "int\eli"
$password = "QWE752qwe" | ConvertTo-SecureString -AsPlainText -Force
$cred = New-Object -typename System.Management.Automation.PSCredential($username, $password)

Try {
#Rename-Computer -NewName $instanceID -Force
Start-Sleep -s 5
Add-Computer -DomainName int.cloudifier.com.au -OUPath "CN=Computers,DC=int,DC=cloudifier,DC=com,DC=au" -Options JoinWithNewName,AccountCreate -Credential $cred -Force -Restart -erroraction 'stop'
}
Catch{
echo $_.Exception | Out-File c:\Windows\temp\error-joindomain.txt -Append
}
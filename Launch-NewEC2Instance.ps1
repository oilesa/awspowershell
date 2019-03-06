#// Variables
$SecurityGroupName = 'test'
$GroupDescription = 'Security group for EC2 demo'
$tag = New-Object Amazon.EC2.Model.Tag
$tag.Key = "Name"
$tag.Value = "test"
$SubnetID = "subnet-0e540026b17905477"

$sgid = New-EC2SecurityGroup -GroupName $SecurityGroupName -GroupDescription $GroupDescription
New-EC2Tag -Resource $sgid -tag $tag

#// Configure Egress and Ingress Rules for security group
Grant-EC2SecurityGroupIngress -GroupName $SecurityGroupName -IpPermissions @{IpProtocol = "tcp"; FromPort = 80; ToPort = 80; IpRanges = @("0.0.0.0/0")}
Grant-EC2SecurityGroupIngress -GroupName $SecurityGroupName -IpPermissions @{IpProtocol = "tcp"; FromPort = 3389; ToPort = 3389; IpRanges = @("0.0.0.0/0")}
#Grant-EC2SecurityGroupEgress  -GroupName  $SecurityGroupName  -IpPermissions @{IpProtocol = "All traffic"; FromPort = "0"; ToPort ="0"; IpRanges = @("0.0.0.0/0")}
#Get-EC2SecurityGroup -GroupNames $SecurityGroupName  | Select-Object -ExpandProperty:IpPermission

New-EC2Instance -ImageId ((Get-SSMParameterValue -Name /aws/service/ami-windows-latest/Windows_Server-2016-English-Full-Base).Parameters[0].Value) -InstanceType t2.small -AssociatePublicIp $true -SubnetId $SubnetID

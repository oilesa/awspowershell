#///// Creating Security Group

$SecurityGroupName = 'test'
$GroupDescription = 'Security group for EC2 demo'
$Tag = New-Object Amazon.EC2.Model.Tag
$Tag.Key = "Name"
$Tag.Value = "test"
$SecurityGroupID = New-EC2SecurityGroup -GroupName $SecurityGroupName -GroupDescription $GroupDescription
New-EC2Tag -Resource $SecurityGroupID -tag $Tag

# Configure Egress and Ingress Rules for security group
Grant-EC2SecurityGroupIngress -GroupName $SecurityGroupName -IpPermissions @{IpProtocol = "tcp"; FromPort = 80; ToPort = 80; IpRanges = @("0.0.0.0/0")}
Grant-EC2SecurityGroupIngress -GroupName $SecurityGroupName -IpPermissions @{IpProtocol = "tcp"; FromPort = 3389; ToPort = 3389; IpRanges = @("0.0.0.0/0")}
#Grant-EC2SecurityGroupEgress  -GroupName  $SecurityGroupName  -IpPermissions @{IpProtocol = "All traffic"; FromPort = "0"; ToPort ="0"; IpRanges = @("0.0.0.0/0")}
#Get-EC2SecurityGroup -GroupNames $SecurityGroupName  | Select-Object -ExpandProperty:IpPermission


#======================================================================================================================

#///// Lanuncing the instance with the latest released AMI

#$InstanceID = New-EC2Instance -ImageId ((Get-SSMParameterValue -Name /aws/service/ami-windows-latest/Windows_Server-2016-English-Full-Base).Parameters[0].Value) -InstanceType t2.small -AssociatePublicIp $true -SubnetId $SubnetID

# Default VPCs
#$SubnetID01 = "subnet-0e540026b17905477" #apse2-az3
#$SubnetID02 = "subnet-0c00851a31a44165c" #apse2-az1
#$SubnetID03 = "subnet-0c19b4eaea76b8f0d" #apse2-az2
# My VPCs
#$SubnetID04 = "subnet-027ff1d8b1aafc88e"  #testnet-private-subnet-01-ap-southeast-2a  apse2-az3
#$SubnetID05 = "subnet-02e10c29f83f452fe"  #testnet-private-subnet-02-ap-southeast-2b  apse2-az1
#$SubnetID06 = "subnet-0c5a0cf2ca91cf7d2"  #testnet-private-subnet-03-ap-southeast-2c  apse2-az2
#$SubnetID07 = "subnet-0703835a956c7d999"  #testnet-public-subnet-01-ap-southeast-2a   apse2-az3
#$SubnetID08 = "subnet-002bc31b3aff87eb2"  #testnet-public-subnet-02-ap-southeast-2b   apse2-az1
#$SubnetID09 = "subnet-0800e4cd7fb42e961"  #testnet-public-subnet-03-ap-southeast-2c   apse2-az2

# Get the latest AMI
$ImageID = (Get-SSMParameterValue -Name /aws/service/ami-windows-latest/Windows_Server-2019-English-Full-Base).Parameters[0].Value
# Creating Instance
$EC2Instance = New-EC2Instance -ImageId $imageid -MinCount 5 -MaxCount 5 -InstanceType t3.medium -KeyName ops-windows-sydney -SecurityGroupId $SecurityGroupID -Monitoring_Enabled $true -SubnetId $SubnetID01
# Tag the Instance
$Tag = New-Object Amazon.EC2.Model.Tag
#$Tag.Key = "Name"
#$Tag.Value = "MyVM"
$InstanceID = $EC2Instance.Instances | Select-Object -ExpandProperty InstanceID
New-EC2Tag -Resource $InstanceID -Tag $Tag


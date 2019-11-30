$Region = 'ap-southeast-1'
$VPCCIDR = '10.0.0.0/16'

# Private Subnet is Odd and Public subnet is Even

$SubnetCIDR1 = '10.0.11.0/24'
$SubnetCIDR2 = '10.0.12.0/24'
$SubnetCIDR3 = '10.0.13.0/24'
$subnetCIDR4 = '10.0.14.0/24'
$subnetCIDR5 = '10.0.15.0/24'
$subnetCIDR6 = '10.0.16.0/24'

$VPCTag = New-Object Amazon.EC2.Model.Tag
$VPCTag.Key = 'Name'
$VPCTag.Value = 'testnet-vpc-01-ap-singapore'

$SubnetTag1 = New-Object Amazon.EC2.Model.Tag
$SubnetTag1.Key = 'Name'
$SubnetTag1.Value = 'testnet-private-subnet-01-ap-southeast-1a'

$SubnetTag2 = New-Object Amazon.EC2.Model.Tag
$SubnetTag2.Key ='Name'
$subnettag2.Value = 'testnet-public-subnet-01-ap-southeast-1a'

$SubnetTag3 = New-Object Amazon.EC2.Model.Tag
$SubnetTag3.Key = 'Name'
$SubnetTag3.Value = 'testnet-private-subnet-02-ap-southeast-1b'

$SubnetTag4 = New-Object Amazon.EC2.Model.Tag
$Subnettag4.Key = 'Name'
$Subnettag4.Value = 'testnet-public-subnet-02-ap-southeast-1b'

$SubnetTag5 = New-Object Amazon.EC2.Model.Tag
$subnettag5.key = 'Name'
$subnettag5.value = 'testnet-private-subnet-03-ap-southeast-1c'

$SubnetTag6 = New-Object Amazon.EC2.Model.Tag
$subnettag6.key = 'Name'
$subnettag6.value = 'testnet-public-subnet-03-ap-southeast-1c'

$AvailabilityZonea = 'apse1-az2'
$AvailabilityZoneb = 'apse1-az1'
$AvailabilityZonec = 'apse1-az3'


$InternetgatewayTag = New-Object Amazon.EC2.Model.Tag
$InternetgatewayTag.Key = 'Name'
$InternetgatewayTag.Value = 'testnet-igw-01-ap-singapore'

$NATGatewatTag = New-Object Amazon.EC2.Model.Tag
$NATGatewatTag.key = 'Name'
$NATGatewatTag.Value = 'testnet-ngw-01-ap-singapore'

# Create new VPC

$EC2VPC = New-EC2VPC -CidrBlock $VPCCIDR -Region $Region
New-EC2Tag -Resource $EC2VPC.VpcId -Tag $VPCTag -Region $Region
Write-Host 'VPC with ID' $EC2VPC.VpcId 'created.'

# Create new Subnets

$EC2Subnet = New-EC2Subnet -VpcId $EC2VPC.VpcId -AvailabilityZoneId $AvailabilityZonea -CidrBlock $SubnetCIDR1 -Region $Region
New-EC2Tag -Resource $EC2Subnet.SubnetId -Tag $SubnetTag1 -Region $Region
Write-Host 'Private Subnet with ID' $EC2Subnet.SubnetId 'in zone' $AvailabilityZonea 'created.'
 
$EC2Subnet = New-EC2Subnet -VpcId $EC2VPC.VpcId -AvailabilityZoneId $AvailabilityZonea -CidrBlock $SubnetCIDR2 -Region $Region
New-EC2Tag -Resource $EC2Subnet.SubnetId -Tag $SubnetTag2  -Region $Region
$SubnetID = $EC2Subnet.SubnetId
Write-Host 'Public Subnet with ID' $EC2Subnet.SubnetId 'in zone' $AvailabilityZonea 'created.'

$EC2Subnet = New-EC2Subnet -VpcId $EC2VPC.VpcId -AvailabilityZoneId $AvailabilityZoneb -CidrBlock $SubnetCIDR3 -Region $Region
New-EC2Tag -Resource $EC2Subnet.SubnetId -Tag $SubnetTag3 -Region $Region
Write-Host 'Private Subnet with ID' $EC2Subnet.SubnetId 'in zone' $AvailabilityZoneb 'created.'

$EC2Subnet = New-EC2Subnet -VpcId $EC2VPC.VpcId -AvailabilityZoneId $AvailabilityZoneb -CidrBlock $SubnetCIDR4 -Region $Region
New-EC2Tag -Resource $EC2Subnet.SubnetId -Tag $SubnetTag4 -Region $Region
Write-Host 'Public Subnet with ID' $EC2Subnet.SubnetId 'in zone' $AvailabilityZoneb 'created.'

$EC2Subnet = New-EC2Subnet -VpcId $EC2VPC.VpcId -AvailabilityZoneId $AvailabilityZonec -CidrBlock $SubnetCIDR5 -Region $Region
New-EC2Tag -Resource $EC2Subnet.SubnetId -Tag $SubnetTag5 -Region $Region
Write-Host 'Private Subnet with ID' $EC2Subnet.SubnetId 'in zone' $AvailabilityZonec 'created.'

$EC2Subnet = New-EC2Subnet -VpcId $EC2VPC.VpcId -AvailabilityZoneId $AvailabilityZonec -CidrBlock $SubnetCIDR6 -Region $Region
New-EC2Tag -Resource $EC2Subnet.SubnetId -Tag $SubnetTag6 -Region $Region
Write-Host 'Public Subnet with ID' $EC2Subnet.SubnetId 'in zone' $AvailabilityZonec 'created.'

# Create Internet gateway and attach it to the VPC

$EC2InternetGateway = New-EC2InternetGateway -Region $Region
Add-EC2InternetGateway -InternetGatewayId $Ec2InternetGateway.InternetGatewayId -VpcId $EC2VPC.VpcId -Region $Region
New-EC2Tag -Resource $Ec2InternetGateway.InternetGatewayId -Tag $InternetgatewayTag -Region $Region
Write-Host 'Internet Gateway with ID' $EC2InternetGateway.InternetGatewayId 'created.'

# Reserve an Elastic IP for NAT Gateway

$EC2Address = New-EC2Address -Region $Region
Write-Host 'Elastic IP with ID' $EC2Address.AllocationId 'created.'

# Create NAT Gateway

$EC2NATGateway = New-EC2NatGateway -SubnetId $SubnetID -AllocationId $EC2Address.AllocationId -Region $Region
New-EC2Tag -Resource $EC2NATGateway.NatGateway.NatGatewayId -Tag $NATGatewatTag -Region $Region
Write-Host 'EC2NATGateway with ID' $EC2NATGateway.NatGateway.NatGatewayId 'created.'


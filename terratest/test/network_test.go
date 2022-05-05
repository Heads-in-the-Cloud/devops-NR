package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

var deployment_passed bool

func TestTerraformAwsNetwork(t *testing.T) {
	t.Parallel()

	awsRegion := aws.GetRandomStableRegion(t, nil, nil)

	// Give the VPC and the subnets correct CIDRs
	vpcCidr := "10.10.0.0/16"
	public1SubnetCidr := "10.10.1.0/24"
	public2SubnetCidr := "10.10.2.0/24"
	private1SubnetCidr := "10.10.3.0/24"
	private2SubnetCidr := "10.10.4.0/24"

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../terraform",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"main_vpc_cidr":        vpcCidr,
			"private1_subnet_cidr": private1SubnetCidr,
			"private2_subnet_cidr": private2SubnetCidr,
			"public1_subnet_cidr":  public1SubnetCidr,
			"public2_subnet_cidr":  public2SubnetCidr,
			"aws_region":           awsRegion,
		},
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	public1SubnetId := terraform.Output(t, terraformOptions, "public1_subnet_id")
	public2SubnetId := terraform.Output(t, terraformOptions, "public2_subnet_id")
	private1SubnetId := terraform.Output(t, terraformOptions, "private1_subnet_id")
	private2SubnetId := terraform.Output(t, terraformOptions, "private2_subnet_id")
	vpcId := terraform.Output(t, terraformOptions, "main_vpc_id")

	subnets := aws.GetSubnetsForVpc(t, vpcId, awsRegion)

	require.Equal(t, 4, len(subnets))
	// Verify if the network that is supposed to be public is really public
	if assert.True(t, aws.IsPublicSubnet(t, public1SubnetId, awsRegion)) {
		deployment_passed = true
		t.Logf("PASS: Subnet (id: %v) in region: %v is public", public1SubnetId, awsRegion)
	} else {
		deployment_passed = false
		terraform.Destroy(t, terraformOptions)
		t.Fatalf("FAIL: Subnet (id: %v) in region: %v is expected to be public", public1SubnetId, awsRegion)
	}

	if assert.True(t, aws.IsPublicSubnet(t, public2SubnetId, awsRegion)) {
		deployment_passed = true
		t.Logf("PASS: Subnet (id: %v) in region: %v is public", public2SubnetId, awsRegion)
	} else {
		deployment_passed = false
		terraform.Destroy(t, terraformOptions)
		t.Fatalf("FAIL: Subnet (id: %v) in region: %v is expected to be public", public2SubnetId, awsRegion)
	}

	// Verify if the network that is supposed to be private is really private
	if assert.False(t, aws.IsPublicSubnet(t, private1SubnetId, awsRegion)) {
		deployment_passed = true
		t.Logf("PASS: Subnet (id: %v) in region: %v is private", private1SubnetId, awsRegion)
	} else {
		deployment_passed = false
		terraform.Destroy(t, terraformOptions)
		t.Fatalf("FAIL: Subnet (id: %v) in region: %v is expected to be private", private1SubnetId, awsRegion)
	}

	if assert.False(t, aws.IsPublicSubnet(t, private2SubnetId, awsRegion)) {
		deployment_passed = true
		t.Logf("PASS: Subnet (id: %v) in region: %v is private", private2SubnetId, awsRegion)
	} else {
		deployment_passed = false
		terraform.Destroy(t, terraformOptions)
		t.Fatalf("FAIL: Subnet (id: %v) in region: %v is expected to be private", private2SubnetId, awsRegion)
	}
}

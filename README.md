## project-usecase-2
2. Infrastructure as Code (IaC)
Use Case: Automate infrastructure provisioning using IaC tools.
Tools: Terraform, AWS CloudFormation, or Pulumi.
Steps:
Write IaC scripts to provision a virtual machine, load balancer, and database in a cloud environment.
Use version control (e.g., Git) to manage the IaC scripts.
Integrate the IaC scripts with your CI/CD pipeline to automate infrastructure deployment.


----order of execution of terraform script----
Store Terraform state in a GCS bucket (provider.tf)
Create a health check
Create an instance template
Create a managed instance group (MIG)
Attach the MIG to a backend service
Create a load balancer and attach the backend

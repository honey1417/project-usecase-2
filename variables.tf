variable "PROJECT_ID" {
    description = "Project ID"
    type = "string"
    default = "harshini-450807"
}
variable "REGION" {
    description = "Region for resources"
    type = "string"
    default = "us-east1"
}
variable "zone" {
    description = "Zone of the VM"
    type = "string"
    default = "us-east1-a"
}
variable "backend_bucket_name"{
    description = "Name of the backend bucket"
    type = "string"
    default = "harshini-450807-bucket"
}
variable "hc_name" {
    description = "Name of the health check"
    type = "string"
    default = "usecase-2-hc"
}
variable "vm_template_name" {
    description = "Name of the VM template"
    type = "string"
    default = "usecase-2-template"
}
variable "machine_type" {
    description = "Machine type of the VM"
    type = "string"
    default = "n1-standard-1"
}
variable "image" {
    description = "Image of the VM"
    type = "string"
    default = "centos-cloud/centos-stream-9-v20250123"
}
variable "mig_name" {
    description = "Name of the MIG"
    type = "string"
    default = "usecase-2-mig"
}
variable "target_size" {
    description = "Number of nodes in the MIG"
    type = "number"
    default = 1
}
variable "backend_service_name" {
    description = "Name of the backend service"
    type = "string"
    default = "usecase-2-backend"
}
variable "url_map_name" {
    description = "Name of the URL map"
    type = "string"
    default = "usecase-2-url-map"
}
variable "proxy_name" {
    description = "Name of the proxy"
    type = "string"
    default = "usecase-2-proxy"
}
variable "fr_name" {
    description = "Name of the forwarding rule"
    type = "string"
    default = "uc-2-http-forwarding-rule"
}
variable "db_password" {
    description = "Password for the SQL instance"
    type = "string"
    sensitive = true
}

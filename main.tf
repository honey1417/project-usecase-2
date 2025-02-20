#creating a HEALTH CHECK
resource "google_compute_health_check" "uc-2-hc" {
    name = var.hc_name
    http_health_check {
        request_path = "/"
        port = 80
    }
    check_interval_sec = 15              # Interval between health checks
    timeout_sec = 4                         # Timeout for checking health
    healthy_threshold = 2                   # Number of successful checks before considering unhealthy
    unhealthy_threshold = 2                 # Number of failed checks before considering healthy
    description = "Health check for the application" # Adding a description for clarity
}


#creating a INSTANCE TEMPLATE with startup script
resource "google_compute_instance_template" "uc-2-template" {
    name = var.vm_template_name
    machine_type = var.machine_type
    disk {
    auto_delete  = true
    boot         = true
    source_image = var.image
  }
    network_interface {
        network = "default"
        access_config {}
    }
    metadata_startup_script = <<EOT
    #! /bin/bash
    sudo yum update -y 
    sudo yum install httpd -y 
    sudo systemctl start httpd
    sudo systemctl enable httpd
    sudo systemctl status httpd
    echo "<h1>Hello World from $(hostname -f)</h1>" | sudo tee /var/www/html/index.
    EOT
    labels = {
        usecase = 2
    }
}

#creating a MANAGED INSTANCE GROUP
resource "google_compute_region_instance_group_manager" "uc-2-mig" {
    name = var.mig_name
    base_instance_name = var.vm_template_name

    version {
        instance_template = google_compute_instance_template.uc-2-template.self_link
    }
    target_size = var.target_size #number of instances in the group
    named_port {   #named port for the instance group
        name = "http" #name of the port
        port = 80    #port number

    }
}

#creating a BACKEND SERVICE 
resource "google_compute_backend_service" "uc-2-backend" {
    name = var.backend_service_name
    protocol = "HTTP"
    health_checks = [google_compute_health_check.uc-2-hc.self_link]
    backend {
        group = google_compute_region_instance_group_manager.uc-2-mig.instance_group
    }
}

#creating a URL MAP
resource "google_compute_url_map" "uc-2-url-map" {
    name = var.url_map_name
    default_service = google_compute_backend_service.uc-2-backend.self_link
}

#creating a TARGET HTTP PROXY
resource "google_compute_target_http_proxy" "uc-2-proxy" {
    name = var.proxy_name
    url_map = google_compute_url_map.uc-2-url-map.self_link
}

#creating a GLOBAL FORWARDING RULE
resource "google_compute_global_forwarding_rule" "uc-2-http-fr" {
    name = var.fr_name
    target = google_compute_target_http_proxy.uc-2-proxy.self_link
    port_range = "80"
    load_balancing_scheme = "EXTERNAL" # Specify the load balancing scheme
}

#create MYSQL DataBase instance
resource "google_sql_database_instance" "uc-2-sql" {
    name = "usecase-2-sql-instance" # Name of the SQL instance
    database_version = "MYSQL_8_0"
    settings {
        tier = "db-g1-small"
        backup_configuration {
            enabled = true # Enable automatic backups
        }

    }
}

#creating a SQL DATABASE
resource "google_sql_database" "uc-2-db" {
    name = "usecase-2-db" # Name of the database
    instance = google_sql_database_instance.uc-2-sql.name
}

#create a SQL USER
resource "google_sql_user" "uc-2-sql-user" {
    name = "admin" # Name of the user
    instance = google_sql_database_instance.uc-2-sql.name
    password = var.db_password # Password for the user

}

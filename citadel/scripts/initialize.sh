#!/bin/bash

# Variables
cloudflare_tunnel_token=$1
github_access_token=$2

# Setup dependencies
source <(curl -s "https://raw.githubusercontent.com/kontinuum-investments/Central-Finite-Curve/production/citadel/scripts/library.sh")

# Change the server configuration
disable_password_ssh_authentication
create_super_user "github"
add_ssh_public_key "github" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHjtXQCKhbhrz2Rbf0ssGqujsAk62la+AIPoppzXsG1l"
create_super_user "kavindu"
add_ssh_public_key "kavindu" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINrOqtny4NUsR5m80k7KCeB4MnkBhV+Vt1NStiiFboMs"

# Setup applications
update_server
install_necessary_applications
install_docker
install_cloudflare_tunnel
start_cloudflare_tunnel "$cloudflare_tunnel_token"

# Start the containers
trigger_github_action "kontinuum-investments" "Website" "Citadel Deployment" "production" "$github_access_token"
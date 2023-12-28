update_server(){
  export DEBIAN_FRONTEND=noninteractive
  export NEEDRESTART_MODE=a
  sudo apt update -y
  sudo apt upgrade -y
}


install_necessary_applications(){
    sudo apt install uuid-runtime -y
}


install_cloudflare_tunnel(){
  wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
  sudo dpkg -i cloudflared-linux-amd64.deb
  rm -rf cloudflared-linux-amd64.deb
}


install_docker() {
  # Add Docker's official GPG key:
  sudo apt-get update
  sudo apt-get install ca-certificates curl gnupg -y
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg --batch
  sudo chmod a+r /etc/apt/keyrings/docker.gpg

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update

  # Install Docker
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
}


start_cloudflare_tunnel(){
  local cloudflare_tunnel_token=$1
  sudo cloudflared service install "$cloudflare_tunnel_token"
}


start_cloudflare_tunnel_container(){
  local cloudflare_tunnel_token=$1
  sudo docker run -d cloudflare/cloudflared:latest tunnel --no-autoupdate run --token "$cloudflare_tunnel_token" -P
}


deploy_container(){
  local image_name=$1
  local container_name=$2
  local container_port=$3
  local host_port=$4
  local env_vars=$5
  local docker_env_vars_command=""
  docker_env_vars_command=$(get_docker_env_vars_command "$env_vars")

  sudo service docker start
  sudo docker image pull "$image_name"
  stop_container "$container_name"
  sudo docker run -d \
    --name="$container_name" \
    --publish 127.0.0.1:$host_port:$container_port/tcp \
     $docker_env_vars_command \
    "$image_name"
}

stop_container(){
  local container_name=$1
  sudo docker stop "$container_name"
  sudo docker rm "$container_name"
  sudo docker system prune -a --volumes --force
}

get_docker_env_vars_command(){
  local env_vars=$1

  IFS=',' read -ra vars <<< "$env_vars"
  local docker_env_vars_command=""
  for var in "${vars[@]}"; do
    docker_env_vars_command+=" -e $var"
  done

  echo "$docker_env_vars_command"
}


create_super_user(){
  local username=$1
  sudo adduser --gecos "" --disabled-password --home /home/"$username" "$username"
  sudo usermod -aG sudo "$username"
}


add_ssh_public_key(){
  local username=$1
  local public_key=$2
  local public_key_location="/home/$username/.ssh"
  local authorized_keys_location="$public_key_location/authorized_keys"

  sudo su - "$username" -c "mkdir $public_key_location"
  sudo su - "$username" -c "touch $authorized_keys_location"
  sudo su - "$username" -c "echo $public_key | tee -a $authorized_keys_location"
  sudo su - "$username" -c "chmod 700 $public_key_location"
  sudo su - "$username" -c "chmod 600 $authorized_keys_location"

  # Disable password prompt when running sudo
  sudo echo "$username ALL=(ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/$username"
}


disable_password_ssh_authentication(){
  sudo find /etc/ssh/sshd_config.d/ -type f -exec sed -i "s/PasswordAuthentication yes/PasswordAuthentication no/g" {} \;
  sudo systemctl restart ssh
}


trigger_github_action(){
  local username=$1
  local repository=$2
  local message=$3
  local branch=$4
  local github_access_token=$5

  curl --request POST \
  --url "https://api.github.com/repos/$username/$repository/actions/workflows/pipeline.yml/dispatches" \
  --header "authorization: Bearer $github_access_token" \
  --data "{\"ref\": \"$branch\", \"inputs\": {\"message\" : \"$message\"}}"
}


set_environment_environmental_variable(){
  if [[ $(hostname) == *"-test" ]]
  then
      export ENVIRONMENT="Test"
  else
      export ENVIRONMENT="Production"
  fi
}
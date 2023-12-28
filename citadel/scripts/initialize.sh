#!/bin/bash

# Variables
cloudflare_tunnel_token=$1
github_access_token=$2
github_public_key=""

# Setup dependencies
source <(curl -s "https://raw.githubusercontent.com/kontinuum-investments/Central-Finite-Curve/production/citadel/scripts/library.sh")

# Change the server configuration
set_environment_environmental_variable
disable_password_ssh_authentication
create_super_user "github"
if [ "$ENVIRONMENT" = "Production" ]
then
    github_public_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCvdkwjDFYMPVg/cG3l/y6heKoQz5Llf/8nXik7Gi1qQUa+x+Eatpfs2cm+AEmgQzuL1fL/HW+ZxOIrZrmUdgWtCCep/T1wZbKuc1P0Vv3lJl0/h60nFGVxa+egPywdVb0CIijtRnawHbqte4Ak/xx7dP+gc+YQ7LCB6H+yERpRZ4esNZbvwhFkTbDpyGsazMrIWTDKQ375F4Zq/4cj6LGQS93rivJIKt74UfNJccOb3b9fc3DdGBU5FDq2Zyu7yLHbYnH9HcV+1sQLy1aSwuobxdI+7O9mnVHSnxcJCED031eDhVMt16NQMPoJKu/0Vj9UO9CnScmoVIySEb69fQcjDyrug+gjt7nzFh3wouyb5vb4sN8SwoaxySh3WdN7JooHyRgkUoUB4Zm+XIOnzwuVFL8x/DiILdkYCmzFONIicFnUMce3zZZchIoQktUG7OdYMu4EKPcLaTl2YpcU6llny7WL6H71r3wrxzhEBzc3QuFHaGqZsL84aEIBqfDPD7BfkK9+MhTtlK+hSjbSvpvygV2oCWrm6caA+FzX0TSKEpguY5Gt/VsHqiIuSiUswcE2wVEH+YI9yIIo+5X0VomqaoYtFwJRDKVCd02btBnBLvyVv90bqMGvWuG0+NW/w8Nl53FOQV01GZKuHGKxmFPun5w1wupycLdYiChKpNZOEQ=="
else
    github_public_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCb+AnnM9I1EoPnLji56+p3D1zClRx1n8K+0VW3R8Jot1KiMz6IpzpYKEAcUqO5VNmaS4HSF3OlEGtwntPpnOpypV+8t4rdcIitxwXcOboL1htBhvv9H1eqL0p6lxgWlt9EqWKtahmqqdyKihBHAb+27c4kO5u/YHLpe+UzblazCYKeUZ+t2OPamIsTT0YSfbMQRGqpbavNoZJ39YhwmO4tJ58pda6MSff0wD4J5vTBcdXxuaKHvDSXr0RKhhgGS1OZFQkACzVAdafv+eTwjn0D6dNrzX+iL0iCuUaIetaibvZdGumZQQP9NkvJXbu0TgxgAMYzNoIiOJX0/TKn5oIl6s6AIsO4Bt4vr6HY6fLJDb/RRQTFJDjkddoI4iO8ZiGZQ3kUQP1mNH5VxAQ1x/QZW0oUzr678Q8b4yQnBWRjbTkjkz/fOUdyQH7gNbegQH97ae5JNlLfjpQpPdN0CAaFPl3V345YjlODe5jhdyKCbXi6lOYdoQLCKzcTu3ZRguTmV5bPPJTND/mez3bwnIMHQozPHZrkfvPlkQFztkahKbeFQmFBV99wzuDo/BExuNPsNvqNbDo46OFzDrdzpEJO+7x5ks9xXOpNx5UPnrol3Ec0oHyCog262zqRavnZCGf31gkRJweu0CXSL2IcoaFY5bHLoZaxPMJSyafTjNuLAQ=="
fi
add_ssh_public_key "github" "$github_public_key"

# Setup applications
update_server
install_necessary_applications
install_docker
install_cloudflare_tunnel
start_cloudflare_tunnel "$cloudflare_tunnel_token"

# Start the containers
trigger_github_action "kontinuum-investments" "Website" "Citadel Deployment" "$(echo $ENVIRONMENT | tr '[:upper:]' '[:lower:]')" "$github_access_token"
trigger_github_action "kontinuum-investments" "Vita-API" "Citadel Deployment" "$(echo $ENVIRONMENT | tr '[:upper:]' '[:lower:]')" "$github_access_token"
export DEBIAN_FRONTEND=noninteractive
sudo su
apt-get update
#apt-get install -y curl
apt-get install -y tcpdump
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce

ip addr add 192.168.12.25/24 dev enp0s8
ip link set dev enp0s8 up
ip route add 192.168.110.0/24 via 192.168.12.1
ip route add 192.168.10.0/23 via 192.168.12.1
#ip route del default
#ip route add default via 192.168.12.1
docker rm  $(docker ps -a -q) #rimuove i container se già presenti
#docker container run --publish 8000:8080 --detach --name my_site #run in background and print ID container, named my_site

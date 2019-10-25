export DEBIAN_FRONTEND=noninteractive
sudo su
apt-get update
apt-get install -y curl
apt-get install -y tcpdump
ip addr add 192.168.110.81/24 dev enp0s8
ip link set dev enp0s8 up
ip route add 192.168.10.0/23 via 192.168.110.1 
ip route add 192.168.12.0/24 via 192.168.110.1
#ip route del default
#ip route add default via 192.168.110.1

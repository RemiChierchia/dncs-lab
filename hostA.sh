export DEBIAN_FRONTEND=noninteractive
sudo su
apt-get update
apt-get install -y curl
apt-get install -y tcpdump
ip addr add 192.168.110.81/24 dev enp0s8
ip link set dev enp0s8 up
ip route add default via 192.168.110.1

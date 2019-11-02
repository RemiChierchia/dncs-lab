export DEBIAN_FRONTEND=noninteractive
sudo su
apt-get update
apt-get install -y tcpdump
sysctl net.ipv4.ip_forward=1
ip link set dev enp0s8 up
ip link set dev enp0s9 up
ip addr add 192.168.250.2/30 dev enp0s9
ip addr add 192.168.12.1/24 dev enp0s8
ip route add 192.168.110.0/24 via 192.168.250.1 #rotta per gli host-a/b tramite router-1
ip route add 192.168.10.0/23 via 192.168.250.1

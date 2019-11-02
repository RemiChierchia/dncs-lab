export DEBIAN_FRONTEND=noninteractive
sudo su
apt-get update
apt-get install -y tcpdump
sysctl net.ipv4.ip_forward=1
ip addr add 192.168.250.1/30 dev enp0s9
ip link set dev enp0s8 up
ip link set dev enp0s9 up
ip link add link enp0s8 name enp0s8.9 type vlan id 9 #VLAN 
ip link add link enp0s8 name enp0s8.10 type vlan id 10
ip addr add 192.168.110.1/24 dev enp0s8.9
ip addr add 192.168.10.1/23 dev enp0s8.10
ip link set dev enp0s8.9 up
ip link set dev enp0s8.10 up
ip route add 192.168.12.0/24 via 192.168.250.2 #rotta per host-c tramite router-2

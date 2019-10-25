export DEBIAN_FRONTEND=noninteractive
sudo su
apt-get update
apt-get install -y tcpdump apt-transport-https ca-certificates curl software-properties-common
sysctl net.ipv4.ip_forward=1
ip link set dev enp0s8 up
ip link set dev enp0s9 up
ip link add link enp0s8 name enp0s8.11 type vlan id 11 #VLAN 
ip link add link enp0s8 name enp0s8.12 type vlan id 12
ip link set dev enp0s8.11 up
ip link set dev enp0s8.12 up
ip addr add 192.168.110.1/24 dev enp0s8.11
ip addr add 192.168.10.1/23 dev enp0s8.12
ip addr add 192.168.250.1/30 dev enp0s9
ip route add 192.168.12.0/24 via 192.168.250.2 #rotta per host-c tramite router-2

export DEBIAN_FRONTEND=noninteractive
sudo su
apt-get update
apt-get install -y tcpdump
apt-get install -y openvswitch-common openvswitch-switch apt-transport-https ca-certificates curl software-properties-common
#ovs-vsctl --if-exists del-br switch
ovs-vsctl add-br switch
ovs-vsctl add-port switch enp0s8
ovs-vsctl add-port switch enp0s9 tag=9 #tag sottointerfaccia vlan
ovs-vsctl add-port switch enp0s10 tag=10
ip link set dev enp0s8 up
ip link set dev enp0s9 up
ip link set dev enp0s10 up
#ip link set dev ovs-system up

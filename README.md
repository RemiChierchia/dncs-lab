# DNCS-LAB

This repository contains the Vagrant files required to run the virtual lab environment used in the DNCS course.

```


        +-----------------------------------------------------+
        |                                     192.168.250.2/30|
        |                          192.168.250.1/30  ^        |enp0s3
     +--+--+                +------------+ ^         | +------------+
     |     |                |            | |         | |            |
     |     |          enp0s3|            | \ enp0s9  / |            |
     |     +----------------+  router-1  +-------------+  router-2  |
     |     |                |            |             |            |
     |     |                |            |             |            |
     |  M  |                +------------+             +------------+
     |  A  |                      |enp0s8               enp0s8|192.168.12.1/24
     |  N  |      192.168.110.1/24|enp0s8.9                   |
     |  A  |      192.168.10.1/23 |enp0s8.10            enp0s8|192.168.12.25/24
     |  G  |                      |                     +-----+----+
     |  E  |                      |enp0s8               |          |
     |  M  |            +---------------------+         |          |
     |  E  |      enp0s3|                     |         |  host-c  |
     |  N  +------------+       SWITCH        |         |          |
     |  T  |            |    9            10  |         |          |
     |     |            +---------------------+         +----------+
     |  V  |                 |enp0s9       |enp0s10           |enp0s3
     |  A  |                 |             |                  |
     |  G  |                 |             |                  |
     |  R  |192.168.110.81/24|<---enp0s8-->|192.168.10.55/23  |
     |  A  |          +----------+     +----------+           |
     |  N  |          |          |     |          |           |
     |  T  |    enp0s3|          |     |          |           |
     |     +----------+  host-a  |     |  host-b  |           |
     |     |          |          |     |          |           |
     |     |          |          |     |          |           |
     +--+--+          +----------+     +----------+           |
        | |                              |enp0s3              |[enp0s3(eth0)]
        | |                              |                    |[enp0s8(eth1)]
        | +------------------------------+                    |[enp0s9(eth2)]
        |                                                     |[enp0s10(eth3)]
        |                                                     |
        +-----------------------------------------------------+



```

# Requirements
 - Python 3
 - 10GB disk storage
 - 2GB free RAM
 - Virtualbox
 - Vagrant (https://www.vagrantup.com)
 - Internet

# How-to
 - Install Virtualbox and Vagrant
 - Clone this repository
`git clone https://github.com/dustnic/dncs-lab`
 - You should be able to launch the lab from within the cloned repo folder.
```
cd dncs-lab
[~/dncs-lab] vagrant up
```
Once you launch the vagrant script, it may take a while for the entire topology to become available.
 - Verify the status of the 4 VMs
 ```
 [dncs-lab]$ vagrant status                                                                                                                                                                
Current machine states:

router                    running (virtualbox)
switch                    running (virtualbox)
host-a                    running (virtualbox)
host-b                    running (virtualbox)
```
- Once all the VMs are running verify you can log into all of them:
`vagrant ssh router`
`vagrant ssh switch`
`vagrant ssh host-a`
`vagrant ssh host-b`
`vagrant ssh host-c`

# Assignment
This section describes the assignment, its requirements and the tasks the student has to complete.
The assignment consists in a simple piece of design work that students have to carry out to satisfy the requirements described below.
The assignment deliverable consists of a Github repository containing:
- the code necessary for the infrastructure to be replicated and instantiated
- an updated README.md file where design decisions and experimental results are illustrated
- an updated answers.yml file containing the details of 

## Design Requirements
- Hosts 1-a and 1-b are in two subnets (*Hosts-A* and *Hosts-B*) that must be able to scale up to respectively 175 and 454 usable addresses
- Host 2-c is in a subnet (*Hub*) that needs to accommodate up to 230 usable addresses
- Host 2-c must run a docker image (dustnic82/nginx-test) which implements a web-server that must be reachable from Host-1-a and Host-1-b
- No dynamic routing can be used
- Routes must be as generic as possible
- The lab setup must be portable and executed just by launching the `vagrant up` command

## Tasks
- Fork the Github repository: https://github.com/dustnic/dncs-lab
- Clone the repository
- Run the initiator script (dncs-init). The script generates a custom `answers.yml` file and updates the Readme.md file with specific details automatically generated by the script itself.
  This can be done just once in case the work is being carried out by a group of (<=2) engineers, using the name of the 'squad lead'. 
- Implement the design by integrating the necessary commands into the VM startup scripts (create more if necessary)
- Modify the Vagrantfile (if necessary)
- Document the design by expanding this readme file
- Fill the `answers.yml` file where required (make sure that is committed and pushed to your repository)
- Commit the changes and push to your own repository
- Notify the examiner that work is complete specifying the Github repository, First Name, Last Name and Matriculation number. This needs to happen at least 7 days prior an exam registration date.

# Notes and References
- https://rogerdudler.github.io/git-guide/
- http://therandomsecurityguy.com/openvswitch-cheat-sheet/
- https://www.cyberciti.biz/faq/howto-linux-configuring-default-route-with-ipcommand/
- https://www.vagrantup.com/intro/getting-started/


# Design

## IP subnettig
The network was splitted in 4 subnets:

-**A**: it contains host-a and enp0s8.9, the router-1 port.  [Vlan based]

-**B**: it contains host-b and enp0s8.10, the router-1 port.  [Vlan based]  

-**C**: it contains host-c and enp0s8, the router-2 port.  

-**D**: it contains enp0s9 port, the one shared by routers.

## Ip address
This is my addresses:

| Network |    Ip/Network Mask    |
|:-------:|:---------------------:|
|  **A**  |   192.168.110.81/24   |
|  **B**  |   192.168.10.55/23    |
|  **C**  |   192.168.12.25/24    |
|  **D**  |   192.168.250.0/30    |

The available IPs are **((2^M)-2)** (two are required for broadcast and network).
8 bits were reserved in network A, 16 bits in network B, 8 in network C and 2 in network D, obtaining this result:

| Network | Available IPs |
|:-------:|:-------------:|
|   **A** |      254      |
|   **B** |      510      |
|   **C** |      254      |
|   **D** |      2        |  

## VLAN
The switch broadcast area of hosts a and b should be separated: VLAN can split the switch in two virtual switches and make it possible.
The network interface of **A** and **B** became this:

| IP            | ENP0S            |   Device   |
|:-------------:|:----------------:|:----------:|
| 192.168.110.1 | enp0s8.9-enp0s8  |  `host-a`  |
| 192.168.10.1  | enp0s8.10-enp0s8 |  `host-b`  | 

## Vagrant File
A Vagrant file conatining commands line in this format:
`[VirtualMachine].provision "shell", path: "[ItsFile.sh]"`
allowed me to auto-initialize all the virtual machines and their links via the script saved in [ItsFile.sh].

- hostA.sh

```
1 export DEBIAN_FRONTEND=noninteractive
2 sudo su
3 apt-get update
4 apt-get install -y curl
5 apt-get install -y tcpdump
6 ip addr add 192.168.110.81/24 dev enp0s8
7 ip link set dev enp0s8 up
8 ip route add default via 192.168.110.1

```

- hostB.sh


```
1 export DEBIAN_FRONTEND=noninteractive
2 sudo su
3 apt-get update
4 apt-get install -y curl
5 apt-get install -y tcpdump
6 ip addr add 192.168.10.55/23 dev enp0s8
7 ip link set dev enp0s8 up
8 ip route add default via 192.168.10.1

```

- hostC.sh

```
1  export DEBIAN_FRONTEND=noninteractive
2  sudo su
3  apt-get update
4  apt-get install -y curl
5  apt-get install -y tcpdump
6  apt-get install -y apt-transport-https ca-certificates curl software-properties-common
7  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
8  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
9  apt-get update
10 apt-get install -y docker-ce
11 docker pull dustnic82/nginx-test:latest
12
13 ip addr add 192.168.12.25/24 dev enp0s8
14 ip link set dev enp0s8 up
15 ip route add default via 192.168.12.1
16 docker stop $(docker ps -a -q) #devo femare i container prima di eliminarli
17 docker rm  $(docker ps -a -q) #rimuove i container se già presenti
18
19 mkdir -p ~/usr/local/share/ca-certificates
20 echo "<html>
21 <head>
22   <title>My-docker</title>
23 </head>
24 <body>
25   <p>This page tests if the web server works.<p>
26 </body>
27 </html>" > ~/usr/local/share/ca-certificates/index.html
28 docker run --name My-docker -p 80:80 -v ~/usr/local/share/ca-certificates:/usr/share/nginx/html -d dustnic82/nginx-test:latest

```

- switch.sh

```
1  export DEBIAN_FRONTEND=noninteractive
2  sudo su
3  apt-get update
4  apt-get install -y tcpdump
5  apt-get install -y openvswitch-common openvswitch-switch apt-transport-https ca-certificates curl software-properties-common
6  ovs-vsctl add-br switch
7  ovs-vsctl add-port switch enp0s8
8  ovs-vsctl add-port switch enp0s9 tag=9 #tag sottointerfaccia vlan
9  ovs-vsctl add-port switch enp0s10 tag=10
10 ip link set dev enp0s8 up
11 ip link set dev enp0s9 up
12 ip link set dev enp0s10 up

```

- Router1.sh

```
1  export DEBIAN_FRONTEND=noninteractive
2  sudo su
3  apt-get update
4  apt-get install -y tcpdump
5  sysctl net.ipv4.ip_forward=1
6  ip addr add 192.168.250.1/30 dev enp0s9
7  ip link set dev enp0s8 up
8  ip link set dev enp0s9 up
9  ip link add link enp0s8 name enp0s8.9 type vlan id 9 #VLAN 
10 ip link add link enp0s8 name enp0s8.10 type vlan id 10
11 ip addr add 192.168.110.1/24 dev enp0s8.9
12 ip addr add 192.168.10.1/23 dev enp0s8.10
13 ip link set dev enp0s8.9 up
14 ip link set dev enp0s8.10 up
15 ip route add 192.168.12.0/24 via 192.168.250.2 #rotta per host-c tramite router-2

```
- Router2.sh

```
1  export DEBIAN_FRONTEND=noninteractive
2  sudo su
3  apt-get update
4  apt-get install -y tcpdump
5  sysctl net.ipv4.ip_forward=1
6  ip link set dev enp0s8 up
7  ip link set dev enp0s9 up
8  ip addr add 192.168.250.2/30 dev enp0s9
9  ip addr add 192.168.12.1/24 dev enp0s8
10 ip route add 192.168.110.0/24 via 192.168.250.1 #rotta per gli host-a/b tramite router-1
11 ip route add 192.168.10.0/23 via 192.168.250.1

```

# Testing

My repo's desing is here:
```
https://github.com/RemiChierchia/dncs-lab

```
In order to get the web-page, this command can be runned from hosts a and b:
```
   curl 192.168.12.25:80/index.html
```  

## Routing tables

The routing tables fot each VM are following:

IP routing table host-a

| Destination     | Gateway         | Genmask         |
|:---------------:|:---------------:|:---------------:|
| 0.0.0.0         | 192.168.110.1   | 0.0.0.0         |
| 0.0.0.0         | 10.0.2.2        | 0.0.0.0         |
| 10.0.2.0        | 0.0.0.0         | 255.255.255.0   |
| 10.0.2.2        | 0.0.0.0         | 255.255.255.255 |
| 192.168.110.0   | 0.0.0.0         | 255.255.255.0   |

IP routing table host-b

| Destination     | Gateway         | Genmask         |
|:---------------:|:---------------:|:---------------:|
| 0.0.0.0         | 192.168.10.1    | 0.0.0.0         |
| 0.0.0.0         | 10.0.2.2        | 0.0.0.0         |
| 10.0.2.0        | 0.0.0.0         | 255.255.255.0   |
| 10.0.2.2        | 0.0.0.0         | 255.255.255.255 |
| 192.168.10.0    | 0.0.0.0         | 255.255.254.0   |


IP routing table router-1

| Destination     | Gateway         | Genmask         |
|:---------------:|:---------------:|:---------------:|
| 0.0.0.0         | 10.0.2.2        | 0.0.0.0         |
| 10.0.2.0        | 0.0.0.0         | 255.255.255.0   |
| 10.0.2.2        | 0.0.0.0         | 255.255.255.255 |
| 192.168.10.0    | 0.0.0.0         | 255.255.254.0   |
| 192.168.12.0    | 192.168.250.2   | 255.255.255.0   |
| 192.168.110.0   | 0.0.0.0         | 255.255.255.0   |
| 192.168.250.0   | 0.0.0.0         | 255.255.255.252 |


IP routing table router-2

| Destination     | Gateway         | Genmask         |
|:---------------:|:---------------:|:---------------:|
| 0.0.0.0         | 10.0.2.2        | 0.0.0.0         |
| 10.0.2.0        | 0.0.0.0         | 255.255.255.0   |
| 10.0.2.2        | 0.0.0.0         | 255.255.255.255 |
| 192.168.10.0    | 192.168.250.1   | 255.255.254.0   |
| 192.168.12.0    | 0.0.0.0         | 255.255.255.0   |
| 192.168.110.0   | 192.168.250.1   | 255.255.255.0   |
| 192.168.250.0   | 0.0.0.0         | 255.255.255.252 |


IP routing table host-c

| Destination     | Gateway         | Genmask         |
|:---------------:|:---------------:|:---------------:|
| 0.0.0.0         | 192.168.12.1    | 0.0.0.0         |
| 0.0.0.0         | 10.0.2.2        | 0.0.0.0         |
| 10.0.2.0        | 0.0.0.0         | 255.255.255.0   |
| 10.0.2.2        | 0.0.0.0         | 255.255.255.255 |
| 172.17.0.0      | 0.0.0.0         | 255.255.0.0     | |-> docker0|
| 192.168.12.0    | 0.0.0.0         | 255.255.255.0   |


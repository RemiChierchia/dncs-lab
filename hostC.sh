export DEBIAN_FRONTEND=noninteractive
sudo su
apt-get update
apt-get install -y curl
apt-get install -y tcpdump
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce
docker pull dustnic82/nginx-test:latest

ip addr add 192.168.12.25/24 dev enp0s8
ip link set dev enp0s8 up
ip route add default via 192.168.12.1
docker stop $(docker ps -a -q) #devo femare i container prima di eliminarli
docker rm  $(docker ps -a -q) #rimuove i container se già presenti

mkdir -p ~/usr/local/share/ca-certificates
echo "<html>
<head>
  <title>My-docker</title>
</head>
<body>
  <p>This page tests if the web server works.<p>
</body>
</html>" > ~/usr/local/share/ca-certificates/index.html
docker run --name My-docker -p 80:80 -v ~/usr/local/share/ca-certificates:/usr/share/nginx/html -d dustnic82/nginx-test:latest

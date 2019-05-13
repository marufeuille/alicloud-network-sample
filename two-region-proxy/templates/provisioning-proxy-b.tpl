yum update -y
yum install -y squid
cd /root
useradd ecs-user
echo '${password}' | passwd --stdin ecs-user
mkdir -p /home/ecs-user/.ssh
echo "${publickey}" > /home/ecs-user/.ssh/authorized_keys
chown -R ecs-user:ecs-user /home/ecs-user
chmod 700 /home/ecs-user/.ssh
chmod 400 /home/ecs-user/.ssh/authorized_keys
echo "ecs-user  ALL=(ALL)       ALL" > /etc/sudoers
export PROXY_A_IP="${proxy-a-ip}"
export DEST_DOMAINS="${dest-domains}"
chmod +x /tmp/make-squid-b-conf.sh
/tmp/make-squid-b-conf.sh > /etc/squid/squid.conf
systemctl restart squid
systemctl enable squid

timedatectl set-timezone Asia/Tokyo

# install LogService Agent
wget http://logtail-release-cn-hangzhou.oss-cn-hangzhou.aliyuncs.com/linux64/logtail.sh -O /tmp/logtail.sh
chmod 755 /tmp/logtail.sh
/tmp/logtail.sh install auto

# install CloudMonitor Agent
export VERSION=2.1.55 
bash -c "$(curl https://cms-agent-${region-id}.oss-${region-id}-internal.aliyuncs.com/cms-go-agent/cms_go_agent_install.sh)"

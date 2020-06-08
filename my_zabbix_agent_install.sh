#!/bin/bash -e

if [ "$UID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Only run it if we can (ie. on Ubuntu/Debian)
if [ -x /usr/bin/apt-get ]; then
  apt-get update
  apt-get -y install zabbix-agent sysv-rc-conf
  sysv-rc-conf zabbix-agent on
  sed -i 's/Server=127.0.0.1/Server=52.90.49.206/' /etc/zabbix/zabbix_agentd.conf
  sed -i 's/ServerActive=127.0.0.1/ServerActive=52.90.49.206/' /etc/zabbix/zabbix_agentd.conf
  HOSTNAME=`hostname` && sed -i "s/Hostname=Zabbix\ server/Hostname=$HOSTNAME/" /etc/zabbix/zabbix_agentd.conf
  service zabbix-agent restart
fi

# Only run it if we can (ie. on RHEL/CentOS)
if [ -x /usr/bin/yum ]; then
        CENTOS_VER=$(rpm --eval '%{centos_ver}')
#       echo $CENTOS_VER
        if [ "$CENTOS_VER" -eq "7" ]; then
                #echo $CENTOS_VER;
                /usr/bin/rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm
                /usr/bin/yum clean all
                /usr/bin/yum install zabbix-agent
                /usr/bin/systemctl enable zabbix-agent
                /usr/bin/sed -i 's/Server=127.0.0.1/Server=192.168.4.213/' /etc/zabbix/zabbix_agentd.conf
                /usr/bin/sed -i
        fi
#  yum -y update
#  rpm -ivh http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-release-2.4-1.el6.noarch.rpm
#  yum -y install zabbix-agent
#  chkconfig zabbix-agent on
#  sed -i 's/Server=127.0.0.1/Server=52.90.49.206/' /etc/zabbix/zabbix_agentd.conf
#  sed -i 's/ServerActive=127.0.0.1/ServerActive=52.90.49.206/' /etc/zabbix/zabbix_agentd.conf
#  HOSTNAME=`hostname` && sed -i "s/Hostname=Zabbix\ server/Hostname=$HOSTNAME/" /etc/zabbix/zabbix_agentd.conf
#  service zabbix-agent restart
fi

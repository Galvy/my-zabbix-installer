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
                /usr/bin/yum -y install zabbix-agent
                /usr/bin/systemctl enable zabbix-agent
                /usr/bin/curl -o /etc/zabbix/zabbix_agentd.conf https://raw.githubusercontent.com/Galvy/my-zabbix-installer/master/zabbix_agentd.conf
                /usr/bin/systemctl restart zabbix-agent
        fi
        if [ "$CENTOS_VER" -eq "8" ]; then
                #echo $CENTOS_VER;
                /usr/bin/rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/8/x86_64/zabbix-release-5.0-1.el8.noarch.rpm
                /usr/bin/dnf clean all
                /usr/bin/yum -y install zabbix-agent
                /usr/bin/systemctl enable zabbix-agent
                /usr/bin/curl -o /etc/zabbix/zabbix_agentd.conf https://raw.githubusercontent.com/Galvy/my-zabbix-installer/master/zabbix_agentd.conf
                /usr/bin/systemctl restart zabbix-agent
        fi

fi

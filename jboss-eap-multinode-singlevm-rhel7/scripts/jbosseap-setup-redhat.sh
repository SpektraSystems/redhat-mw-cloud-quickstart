#!/bin/sh

/bin/date +%H:%M:%S >> jbosseap.install.log
echo "Red Hat JBoss EAP 7.2 Installation Start"  >> jbosseap.install.log

export JBOSS_HOME="/opt/rh/eap7/root/usr/share/wildfly"
NODENAME1="node1"
NODENAME2="node2"
SVR_CONFIG="standalone-ha.xml"
PORT_OFFSET=100
JBOSS_EAP_USER=$1
JBOSS_EAP_PASSWORD=$2
RHEL_OS_LICENSE_TYPE=$3
RHSM_USER=$4
RHSM_PASSWORD=$5
RHSM_POOL=$6
IP_ADDR_NAME=$7
IP_ADDR=$8

STORAGE_ACCOUNT_NAME=$9
STORAGE_ACCESS_KEY=${10}
CONTAINER_NAME="eapblobcontainer"

echo "JBOSS_EAP_USER: " ${JBOSS_EAP_USER} >> jbosseap.install.log
echo "RHSM_USER: " ${RHSM_USER} >> jbosseap.install.log
echo "STORAGE_ACCOUNT_NAME: " ${STORAGE_ACCOUNT_NAME} >> jbosseap.install.log
echo "CONTAINER_NAME: " ${CONTAINER_NAME} >> jbosseap.install.log
echo "IP_ADDR: " ${IP_ADDR} >> jbosseap.install.log

echo "subscription-manager register..." >> jbosseap.install.log
echo "subscription-manager register --username RHSM_USER --password RHSM_PASSWORD" >> jbosseap.install.log
subscription-manager register --username ${RHSM_USER} --password ${RHSM_PASSWORD} >> jbosseap.install.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Red Hat Subscription Manager Registration Failed" >> jbosseap.install.log; exit $flag;  fi
echo "subscription-manager attach --pool=EAP_POOL" >> jbosseap.install.log
subscription-manager attach --pool=${RHSM_POOL} >> jbosseap.install.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Pool Attach for JBoss EAP Failed" >> jbosseap.install.log; exit $flag;  fi
if [ $RHEL_OS_LICENSE_TYPE == "BYOS" ] 
then 
    echo "Attaching Pool ID for RHEL OS" >> jbosseap.install.log
    echo "subscription-manager attach --pool=RHEL_POOL"  >> jbosseap.install.log
    subscription-manager attach --pool=${11} >> jbosseap.install.log 2>&1
    flag=$?; if [ $flag != 0 ] ; then echo  "Pool Attach for RHEL OS Failed" >> jbosseap.install.log; exit $flag;  fi
fi
echo "subscription-manager repos --enable=jb-eap-7-for-rhel-7-server-rpms" >> jbosseap.install.log
subscription-manager repos --enable=jb-eap-7-for-rhel-7-server-rpms >> jbosseap.install.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Enabling repos for JBoss EAP Failed" >> jbosseap.install.log; exit $flag;  fi

echo "JBoss EAP RPM installing..." >> jbosseap.install.log
echo "yum-config-manager --disable rhel-7-server-htb-rpms" >> jbosseap.install.log
yum-config-manager --disable rhel-7-server-htb-rpms >> jbosseap.install.log
echo "yum groupinstall -y jboss-eap7" >> jbosseap.install.log
yum groupinstall -y jboss-eap7 >> jbosseap.install.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "JBoss EAP installation Failed" >> jbosseap.install.log; exit $flag;  fi

echo "Create 2 JBoss EAP nodes on Azure..." >> jbosseap.install.log
echo "/bin/cp  -rL  $JBOSS_HOME/standalone $JBOSS_HOME/$NODENAME1" >> jbosseap.install.log
/bin/cp  -rL  $JBOSS_HOME/standalone $JBOSS_HOME/$NODENAME1 >> jbosseap.install.log 2>&1
echo "/bin/cp -rL  $JBOSS_HOME/standalone $JBOSS_HOME/$NODENAME2" >> jbosseap.install.log
/bin/cp  -rL  $JBOSS_HOME/standalone $JBOSS_HOME/$NODENAME2 >> jbosseap.install.log 2>&1

echo "Eap session replication app deploy..." >> jbosseap.install.log
echo "yum install -y git" >> jbosseap.install.log
yum install -y git >> jbosseap.install.log 2>&1
echo "git clone https://github.com/Suraj2093/eap-session-replication.git" >> jbosseap.install.log
git clone https://github.com/Suraj2093/eap-session-replication.git >> jbosseap.install.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Git clone Failed" >> jbosseap.install.log; exit $flag;  fi
echo "/bin/cp -rf ./eap-session-replication/eap-configuration/standalone-ha.xml $JBOSS_HOME/$NODENAME1/configuration/" >> jbosseap.install.log
/bin/cp -rf ./eap-session-replication/eap-configuration/standalone-ha.xml $JBOSS_HOME/$NODENAME1/configuration/ >> jbosseap.install.log 2>&1
echo "/bin/cp -rf ./eap-session-replication/eap-configuration/standalone-ha.xml $JBOSS_HOME/$NODENAME2/configuration/" >> jbosseap.install.log
/bin/cp -rf ./eap-session-replication/eap-configuration/standalone-ha.xml $JBOSS_HOME/$NODENAME2/configuration/ >> jbosseap.install.log 2>&1
echo "/bin/cp -rf ./eap-session-replication/target/eap-session-replication.war $JBOSS_HOME/$NODENAME1/deployments/eap-session-replication.war" >> jbosseap.install.log
/bin/cp -rf ./eap-session-replication/target/eap-session-replication.war $JBOSS_HOME/$NODENAME1/deployments/eap-session-replication.war >> jbosseap.install.log 2>&1
echo "/bin/cp -rf ./eap-session-replication/target/eap-session-replication.war $JBOSS_HOME/$NODENAME2/deployments/eap-session-replication.war" >> jbosseap.install.log
/bin/cp -rf ./eap-session-replication/target/eap-session-replication.war $JBOSS_HOME/$NODENAME2/deployments/eap-session-replication.war >> jbosseap.install.log 2>&1
echo "touch $JBOSS_HOME/$NODENAME1/deployments/eap-session-replication.war.dodeploy" >> jbosseap.install.log
touch $JBOSS_HOME/$NODENAME1/deployments/eap-session-replication.war.dodeploy >> jbosseap.install.log 2>&1
echo "touch $JBOSS_HOME/$NODENAME2/deployments/eap-session-replication.war.dodeploy" >> jbosseap.install.log
touch $JBOSS_HOME/$NODENAME2/deployments/eap-session-replication.war.dodeploy >> jbosseap.install.log 2>&1

echo "Configuring JBoss EAP management user..." >> jbosseap.install.log
echo "$JBOSS_HOME/bin/add-user.sh -sc $JBOSS_HOME/$NODENAME1/configuration -u JBOSS_EAP_USER -p JBOSS_EAP_PASSWORD -g 'guest,mgmtgroup'" >> jbosseap.install.log
$JBOSS_HOME/bin/add-user.sh -sc $JBOSS_HOME/$NODENAME1/configuration -u $JBOSS_EAP_USER -p $JBOSS_EAP_PASSWORD -g 'guest,mgmtgroup' >> jbosseap.install.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "JBoss EAP management user configuration for Node 1 Failed" >> jbosseap.install.log; exit $flag;  fi
echo "$JBOSS_HOME/bin/add-user.sh -sc $JBOSS_HOME/$NODENAME2/configuration -u JBOSS_EAP_USER -p JBOSS_EAP_PASSWORD -g 'guest,mgmtgroup'" >> jbosseap.install.log
$JBOSS_HOME/bin/add-user.sh -sc $JBOSS_HOME/$NODENAME2/configuration -u $JBOSS_EAP_USER -p $JBOSS_EAP_PASSWORD -g 'guest,mgmtgroup' >> jbosseap.install.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "JBoss EAP management user configuration for Node 2 Failed" >> jbosseap.install.log; exit $flag;  fi

echo "Start JBoss EAP 7.2 instances..." >> jbosseap.install.log
echo "$JBOSS_HOME/bin/standalone.sh -Djboss.node.name=$NODENAME1 -Djboss.server.base.dir=$JBOSS_HOME/$NODENAME1 -c $SVR_CONFIG -b $IP_ADDR -bmanagement $IP_ADDR -bprivate $IP_ADDR -Djboss.jgroups.azure_ping.storage_account_name=$STORAGE_ACCOUNT_NAME -Djboss.jgroups.azure_ping.storage_access_key=STORAGE_ACCESS_KEY -Djboss.jgroups.azure_ping.container=$CONTAINER_NAME &" >> jbosseap.install.log
$JBOSS_HOME/bin/standalone.sh -Djboss.node.name=$NODENAME1 -Djboss.server.base.dir=$JBOSS_HOME/$NODENAME1 -c $SVR_CONFIG -b $IP_ADDR -bmanagement $IP_ADDR -bprivate $IP_ADDR -Djboss.jgroups.azure_ping.storage_account_name=$STORAGE_ACCOUNT_NAME -Djboss.jgroups.azure_ping.storage_access_key=$STORAGE_ACCESS_KEY -Djboss.jgroups.azure_ping.container=$CONTAINER_NAME & >> jbosseap.install.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Starting JBoss EAP service Failed for Node 1" >> jbosseap.install.log; exit $flag;  fi
echo "$JBOSS_HOME/bin/standalone.sh -Djboss.node.name=$NODENAME2 -Djboss.server.base.dir=$JBOSS_HOME/$NODENAME2 -c $SVR_CONFIG -b $IP_ADDR -bmanagement $IP_ADDR -bprivate $IP_ADDR -Djboss.jgroups.azure_ping.storage_account_name=$STORAGE_ACCOUNT_NAME -Djboss.jgroups.azure_ping.storage_access_key=STORAGE_ACCESS_KEY -Djboss.jgroups.azure_ping.container=$CONTAINER_NAME -Djboss.socket.binding.port-offset=$PORT_OFFSET &" >> jbosseap.install.log
$JBOSS_HOME/bin/standalone.sh -Djboss.node.name=$NODENAME2 -Djboss.server.base.dir=$JBOSS_HOME/$NODENAME2 -c $SVR_CONFIG -b $IP_ADDR -bmanagement $IP_ADDR -bprivate $IP_ADDR -Djboss.jgroups.azure_ping.storage_account_name=$STORAGE_ACCOUNT_NAME -Djboss.jgroups.azure_ping.storage_access_key=$STORAGE_ACCESS_KEY -Djboss.jgroups.azure_ping.container=$CONTAINER_NAME -Djboss.socket.binding.port-offset=$PORT_OFFSET & >> jbosseap.install.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Starting JBoss EAP service Failed for Node 2" >> jbosseap.install.log; exit $flag;  fi

echo "Configure firewall for ports 8080, 8180, 9990, 10090..." >> jbosseap.install.log
echo "firewall-cmd --zone=public --add-port=8080/tcp --permanent" >> jbosseap.install.log
firewall-cmd --zone=public --add-port=8080/tcp --permanent >> jbosseap.install.log 2>&1
echo "firewall-cmd --zone=public --add-port=8180/tcp --permanent" >> jbosseap.install.log
firewall-cmd --zone=public --add-port=8180/tcp --permanent >> jbosseap.install.log 2>&1
echo "firewall-cmd --zone=public --add-port=9990/tcp --permanent" >> jbosseap.install.log
firewall-cmd --zone=public --add-port=9990/tcp --permanent >> jbosseap.install.log 2>&1
echo "firewall-cmd --zone=public --add-port=10090/tcp --permanent" >> jbosseap.install.log
firewall-cmd --zone=public --add-port=10090/tcp --permanent >> jbosseap.install.log 2>&1
echo "firewall-cmd --reload" >> jbosseap.install.log
firewall-cmd --reload >> jbosseap.install.log 2>&1

echo "Open Red Hat software firewall for port 22..." >> jbosseap.install.log
echo "firewall-cmd --zone=public --add-port=22/tcp --permanent" >> jbosseap.install.log
firewall-cmd --zone=public --add-port=22/tcp --permanent >> jbosseap.install.log 2>&1
echo "firewall-cmd --reload" >> jbosseap.install.log
firewall-cmd --reload >> jbosseap.install.log 2>&1

# Seeing a race condition timing error so sleep to delay
sleep 20

echo "Red Hat JBoss EAP 7.2 Intallation End " >> jbosseap.install.log
/bin/date +%H:%M:%S >> jbosseap.install.log
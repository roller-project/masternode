#!/usr/bin/env sh
COIN_NAME='ROLLER'
GETH_LINK='https://github.com/roller-project/roller/releases/download/1.2.1/geth-linux-amd64.zip'
GETH_ZIP='geth-linux-amd64.zip'

cd
echo "****************************************************************************"
echo "* Ubuntu 16.04 is the recommended operating system for this install.       *"
echo "*                                                                          *"
echo "* This script will install and configure your Roller masternodes.          *"
echo "****************************************************************************"
echo && echo && echo

apt-get install unzip wget git
if [ -f ~/$GETH_ZIP ] || [ -f ~/geth-linux-amd64/ ] || [ -f /etc/systemd/system/masternode.service] || [ -f tmp/masternode.service] || [ -f /usr/sbin/geth];
then 
echo 'Remove your old file'
rm -rf $GETH_ZIP geth-linux-amd64/ /usr/sbin/geth /etc/systemd/system/masternode.service tmp/masternode.service
fi

wget $GETH_LINK
unzip $GETH_ZIP
mv ./$GETH_ZIP/geth-linux-amd64 /usr/sbin/geth


cd
rm -rf tools.sh
wget https://raw.githubusercontent.com/roller-project/masternode/master/tools.sh
echo '=========================='
echo 'Configuring service...'
echo '=========================='

cat > /tmp/masternode.service << EOL
[Unit]
Description=$COIN_NAME Client -- masternode service
After=network.target

[Service]
Type=simple
Restart=always
RestartSec=30s
ExecStart=/usr/sbin/geth --masternode --rpcport 8545 --rpcvhosts *
[Install]
WantedBy=default.target
EOL

sudo \mv /tmp/masternode.service /etc/systemd/system
sudo systemctl enable masternode && systemctl start masternode
systemctl status masternode --no-pager --full

cd ~
./tools.sh --enodeId
./tools.sh --nodePort
./tools.sh --nodeIp
echo -e "\033[1;33mJob completed successfully\033[0m"
echo -e 'Complete server configuration\nAfter goto : http://cms.roller.today\nClick Masternode -> Add Node'

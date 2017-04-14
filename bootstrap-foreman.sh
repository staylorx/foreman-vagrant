#!/bin/sh

# Run on VM to bootstrap the Foreman server
# Gary A. Stafford - 01/15/2015
# Modified for Foreman 1.15 and Puppet 4 only - Steve Taylor - 04/14/2017

FOREMAN_VERSION=1.15

# Update system first
sudo yum -y install nmap-ncat firewalld
sudo yum -y update

sudo yum -y install https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
sudo yum -y install epel-release https://yum.theforeman.org/releases/${FOREMAN_VERSION}/el7/x86_64/foreman-release.rpm

sudo yum -y install foreman-installer

if ps aux | grep "/usr/share/foreman" | grep -v grep 2> /dev/null
then
    echo "Foreman appears to all already be installed. Exiting..."
else
    echo "Installing Foreman"
    sudo foreman-installer

    # Set-up firewall
    #https://theforeman.org/manuals/1.15/#3.1SystemRequirements
	#sudo systemctl start firewalld
    #sudo firewall-cmd --permanent --add-port=53/tcp
    #sudo firewall-cmd --permanent --add-port=53/udp
    #sudo firewall-cmd --permanent --add-port=67-69/udp
    #sudo firewall-cmd --permanent --add-service=http
    #sudo firewall-cmd --permanent --add-service=https
    #sudo firewall-cmd --permanent --add-port=3000/tcp
    #sudo firewall-cmd --permanent --add-port=3306/tcp
    #sudo firewall-cmd --permanent --add-port=5910-5930/tcp
    #sudo firewall-cmd --permanent --add-port=5432/tcp
    #sudo firewall-cmd --permanent --add-port=8140/tcp
    #sudo firewall-cmd --permanent --add-port=8443/tcp

    #sudo firewall-cmd --reload
    #sudo systemctl enable firewalld

    # First run the Puppet agent on the Foreman host which will send the first Puppet report to Foreman,
    # automatically creating the host in Foreman's database
    sudo /opt/puppetlabs/bin/puppet agent --test --waitforcert=60

    # Optional, install some optional puppet modules on Foreman server to get started...
    sudo /opt/puppetlabs/bin/puppet module install puppetlabs-ntp
    sudo /opt/puppetlabs/bin/puppet module install puppetlabs-git
    sudo /opt/puppetlabs/bin/puppet module install puppetlabs-vcsrepo
    sudo /opt/puppetlabs/bin/puppet module install garethr-docker
    sudo /opt/puppetlabs/bin/puppet module install jfryman-nginx
    sudo /opt/puppetlabs/bin/puppet module install puppetlabs-haproxy
    sudo /opt/puppetlabs/bin/puppet module install puppetlabs-apache
    sudo /opt/puppetlabs/bin/puppet module install puppetlabs-java
    sudo /opt/puppetlabs/bin/puppet module install puppetlabs-motd
	
	#add a plugin or two
	sudo yum -y install tfm-rubygem-foreman_ansible

	#sudo systemctl enable foreman
	#sudo systemctl start foreman

fi
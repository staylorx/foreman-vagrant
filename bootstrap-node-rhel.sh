#!/bin/sh

# Run on VM to bootstrap the Puppet Agent RHEL-based Linux nodes
# Gary A. Stafford - 01/15/2015
# Modified for Puppet 4 only - Steve Taylor - 04/14/2017

# Update system first
sudo yum -y install nmap-ncat firewalld
sudo yum update -y
sudo yum -y install https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm

#Install the agent
sudo yum -y install puppet-agent
    
# Add agent section to /etc/puppet/puppet.conf
# Easier to set run interval to 120s for testing (reset to 30m for normal use)
# https://docs.puppetlabs.com/puppet/4.10/reference/config_about_settings.html
echo "" | sudo tee --append /etc/puppetlabs/puppet/puppet.conf 2> /dev/null && \
echo "    server = theforeman.example.com" | sudo tee --append /etc/puppetlabs/puppet/puppet.conf 2> /dev/null && \
echo "    runinterval = 120s" | sudo tee --append /etc/puppetlabs/puppet/puppet.conf 2> /dev/null

sudo systemctl enable puppet
sudo systemctl restart puppet

# Unless you have Foreman autosign certs, each agent will hang on this step until you manually
# sign each cert in the Foreman UI (Infrastrucutre -> Smart Proxies -> Certificates -> Sign)
# Alternative, run manually on each host, after provisioning is complete...
#sudo /opt/puppetlabs/bin/puppet agent --test --waitforcert=60

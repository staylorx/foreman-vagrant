#!/bin/sh

# Run on VM to bootstrap Puppet Agent Ubuntu-based Linux nodes
# Gary A. Stafford - 02/27/2015
# Modified for Puppet 4 only - Steve Taylor - 04/14/2017

sudo apt-get update -yq && sudo apt-get upgrade -yq
sudo wget https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
sudo dpkg -i puppetlabs-release-pc1-xenial.deb
sudo apt-get update -yq
sudo apt-get install -yq puppet-agent

# Add agent section to /etc/puppet/puppet.conf
# Easier to set run interval to 120s for testing (reset to 30m for normal use)
# https://docs.puppetlabs.com/puppet/4.10/reference/config_about_settings.html
echo "" | sudo tee --append /etc/puppetlabs/puppet/puppet.conf 2> /dev/null && \
#echo "[agent]" | sudo tee --append /etc/puppetlabs/puppet/puppet.conf 2> /dev/null && \
echo "    server = theforeman.example.com" | sudo tee --append /etc/puppetlabs/puppet/puppet.conf 2> /dev/null && \
echo "    runinterval = 120s" | sudo tee --append /etc/puppetlabs/puppet/puppet.conf 2> /dev/null

sudo systemctl enable puppet
sudo systemctl start puppet

# Unless you have Foreman autosign certs, each agent will hang on this step until you manually
# sign each cert in the Foreman UI (Infrastrucutre -> Smart Proxies -> Certificates -> Sign)
# Aternative, run manually on each host, after provisioning is complete...
#sudo /opt/puppetlabs/bin/puppet agent --test --waitforcert=60

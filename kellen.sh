#!/wqbin/bash 

# This generates a curtin_userdata file usable in MAAS with 
a script that configures the proxy settings for the deployed 
node
# and configures LXD to use the proxies as well.

# Proxy rules, shorter subnet expansion, also constrained in 
LXD's CIDR
#no_proxy="localhost,127.0.0.1,$(echo 10.75.50.{1..126} | 
sed 's/ /,/g'),$(echo 172.23.2.{1..254} | sed 's/ /,/g')"
#proxy=http://proxy.vici.verizon.com:80

no_proxy="test.domain"
proxy="http://192.168.200.2:8000/"

# MAAS preseed modifcations
cat > curtin_userdata_ubuntu_amd64_generic_xenial <<EOF
# LXD Config
proxy-config:
  &proxyconfig |
   #!/bin/bash
   
   # Set up environment files
   
   # Configure /etc/environment
   cat >> /etc/environment <<EOF
   http_proxy=${proxy}
   https_proxy=${proxy}
   no_proxy=${no_proxy}
   EOF
   
   # Configure /etc/profile.d/proxy.sh
   cat >> /etc/profile.d/proxy.sh <<EOF
   http_proxy=${proxy}
   https_proxy=${proxy}
   no_proxy=${no_proxy}
   EOF
   
   # Create systemd firstboot service that run the LXD 
script after the node boots fully.
   cat <<EOF > /etc/systemd/system/firstboot-lxd.service
   [Unit]
   Description=First Boot service to configure LXD
   Requires=network-online.target
   
   [Service]
   User=root
   Environment=USER=root
   ExecStart=/usr/local/bin/firstboot-lxd.sh
   
   [Install]
   WantedBy=multi-user.target
   EOF
   
   # Create the firstboot script that will be executed when 
the node boots the first time
   # NOTE: It will remove itself at the end of its run.
   cat <<EOS > /usr/local/bin/firstboot-lxd.sh
   #!/bin/bash 
   
   sudo snap remove lxd
   sudo apt remove --purge -y lxcfs lxc-common lxd-client 
lxd 
   sudo apt install -y zfsutils-linux snapd 
linux-image-generic linux-signed-image-generic
   sudo snap install lxd
   purge_storage_pools() {
   	sudo zpool destroy -f \\\$1 &> /dev/null
   
   	if [ \\\$? -eq 0 ]; then
           	echo "Pool \\\$1 successfully deleted."
   	else
           	echo "Pool \\\$1 does not exist."
   	fi
   }
   
   read -r -d '' lxdinit <<EOF
   # Daemon settings
   config:
     images.auto_update_interval: 6
     core.proxy_http: ${proxy}
     core.proxy_https: ${proxy}
     core.proxy_ignore_hosts: ${no_proxy}
   
   # Storage config
   storage_pools:
   - name: default
     driver: zfs
     config:
       size: 20GB
   
   # Network devices
   networks:
   - name: lxdbr0
     type: bridge
     config:
       ipv4.address: 10.16.32.1/26 
       ipv4.nat: true
       ipv6.address: none
   
   # Profiles
   profiles:
   - name: default
     devices:
       eth0:
         nictype: bridged
         parent: lxdbr0
         type: nic
       root:
         path: /
         pool: default
         type: disk
     config:
       boot.autostart: "true"
       environment.http_proxy: ${proxy}
       environment.https_proxy: ${proxy}
       environment.no_proxy: ${no_proxy}
       security.nesting: "true"
       security.privileged: "true"
       user.vendor-data: |
         #cloud-config
         apt:
           proxy: ${proxy}
           https_proxy: ${proxy}
           no_proxy: ${no_proxy}
   EOF
   
   # Add user to lxd group and make it active (avoids newgrp 
subshell)
   export PATH="\\\$PATH:/snap/bin:/var/lib/snapd/snap/bin"
   sudo gpasswd -a \\\$USER lxd
   echo \\\$USER
   
   echo "Initializing LXD with pre-populated config"
   sg lxd -c "lxd waitready" && echo "\\\$lxdinit" | sg lxd 
-c "lxd init --preseed --debug"
   
   echo "Cleaning up firstboot setup files"
   systemctl disable firstboot
   
   #rm -rf /etc/systemd/system/firstboot-lxd.service
   #rm -rf \\\$0
   
   touch /var/tmp/firstboot_done.out
   if [ -e /run/reboot-required ]; then
     cat /run/reboot-required.pkgs > /var/tmp/rebooted.out
     shutdown -r +5
   fi
   EOS
   
   # Make executable and enable the firstboot-lxd service
   chmod 755 /usr/local/bin/firstboot-lxd.sh
   systemctl enable firstboot-lxd.service

#cloud-config
proxy:
  http_proxy: ${proxy}
  https_proxy: ${proxy}
  no_proxy: ${no_proxy}
debconf_selections:
 maas: |
  {{for line in str(curtin_preseed).splitlines()}}
  {{line}}
  {{endfor}}
early_commands:
{{if third_party_drivers and driver}}
  {{py: key_string = ''.join(['\\x%x' % x for x in 
driver['key_binary']])}}
  {{if driver['key_binary'] and driver['repository'] and 
driver['package']}}
  driver_00_get_key: /bin/echo -en '{{key_string}}' > 
/tmp/maas-{{driver['package']}}.gpg
  driver_01_add_key: ["apt-key", "add", 
"/tmp/maas-{{driver['package']}}.gpg"]
  {{endif}}
  {{if driver['repository']}}
  driver_02_add: ["add-apt-repository", "-y", "deb 
{{driver['repository']}} {{node.get_distro_series()}} main"]
  {{endif}}
  {{if driver['package']}}
  driver_03_update_install: ["sh", "-c", "apt-get update 
--quiet && apt-get --assume-yes install 
{{driver['package']}}"]
  {{endif}}
  {{if driver['module']}}
  driver_04_load: ["sh", "-c", "depmod && modprobe 
{{driver['module']}} || echo 'Warning: Failed to load 
module: {{driver['module']}}'"]
  {{endif}}
{{else}}
  driver_00: ["sh", "-c", "echo third party drivers not 
installed or necessary."]
{{endif}}
late_commands:
  maas: [wget, '--no-proxy', 
{{node_disable_pxe_url|escape.json}}, '--post-data', 
{{node_disable_pxe_data|escape.json}}, '-O', '/dev/null']
  proxy_config_1: ['curtin', 'in-target', '--', 'sh', '-c', 
'printf "\$1" > "/usr/local/bin/proxyconfig.sh"', '--', 
*proxyconfig]
  proxy_config_2: ['curtin', 'in-target', '--', 'sh', '-c', 
'chmod 755 /usr/local/bin/proxyconfig.sh']
  proxy_config_3: ['curtin', 'in-target', '--', 'sh', '-c', 
'/usr/local/bin/proxyconfig.sh']
{{if third_party_drivers and driver}}
  {{if driver['key_binary'] and driver['repository'] and 
driver['package']}}
  driver_00_key_get: curtin in-target -- sh -c "/bin/echo 
-en '{{key_string}}' > /tmp/maas-{{driver['package']}}.gpg"
  driver_02_key_add: ["curtin", "in-target", "--", 
"apt-key", "add", "/tmp/maas-{{driver['package']}}.gpg"]
  {{endif}}
  {{if driver['repository']}}
  driver_03_add: ["curtin", "in-target", "--", 
"add-apt-repository", "-y", "deb {{driver['repository']}} 
{{node.get_distro_series()}} main"]
  {{endif}}
  driver_04_update_install: ["curtin", "in-target", "--", 
"apt-get", "update", "--quiet"]
  {{if driver['package']}}
  driver_05_install: ["curtin", "in-target", "--", 
"apt-get", "-y", "install", "{{driver['package']}}"]
  {{endif}}
  driver_06_depmod: ["curtin", "in-target", "--", "depmod"]
  driver_07_update_initramfs: ["curtin", "in-target", "--", 
"update-initramfs", "-u"]
{{endif}}
EOF

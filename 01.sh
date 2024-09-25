# created a virtual machine 
# + in the following abbreviated with the term "vm"
# + used image: https://ubuntu.com/download/server/thank-you?version=24.04.1&architecture=amd64&lts=true
# + used `virt-manager` to manage vms (https://virt-manager.org/, https://github.com/virt-manager/virt-manager?tab=readme-ov-file)
# + running via "qemu kvm"

# clone the shut down virtual machine in `virt-manager`
# start each cloned vm and play through rest of this document

# change the hostname
vim /etc/hostname


cat << 'EOF'
the network interfaces are *unmanaged*
so there is no network manager program

though `ip route list` suggests that some routes were
learned via dhcp

I don't know if "learning via dhcp" and "network interfaces being managed" exclude each other but at the moment I guess so.
EOF

ip address flush enp1s0
ip address add 192.168.122.xxx/24 dev enp1s0

ip route list # will show incomplete list

# so add routes 
#   to gateway 192.168.122.1
ip route add 192.168.122.1 dev enp1s0 src 192.168.122.xxx metric 100
#   a default route utilizing the route for the gateway 
ip route add default via 192.168.122.1 dev enp1s0 src 192.168.122.xxx metric 100

ping 8.8.8.8 # should now work

cat << 'EOF'
settings introduced via `ip route` commands will not surive a logout of the user or a restart of the operating system

as written in
  https://ubuntu.com/server/docs/configuring-networks#dynamic-ip-address-assignment-dhcp-client
static routes like here configured should be written down in a file like
	/etc/netplan/90_config.yaml
in a fashion like
EOF

sudo touch /etc/netplan/90_config.yaml
sudo chmod 600 /etc/netplan/90_config.yaml

sudo cat << 'EOF' > /etc/netplan/90_config.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp1s0:
      dhcp4: true
EOF

cat << 'EOF'
according to
  https://knowledge.broadcom.com/external/article/316620/cloned-vm-acquires-the-same-dhcp-ip-addr.html
addresses assigned via dhcp depend on the content of
	/etc/machine-id
in ubuntu
so execute the following as root
EOF

echo -n > /etc/machine-id
rm /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id

# exit/stop using root from here on

# execute the following as your basic sudo enabled user
sudo netplan apply

# reboot the vm
# and check if the assigned ip address to the network interface changed

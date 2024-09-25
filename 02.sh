# to install k3s 
# read https://docs.k3s.io/datastore/ha-embedded


# install brew as described at https://brew.sh/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# follow the instructions of the output


# do the following only on one of the nodes of the control plane

brew install k9s # installs k9s; k9s is a terminal user interface for usage instead of many `kubectl` commands
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chmod `whoami`:`whoami` ~/.kube/config

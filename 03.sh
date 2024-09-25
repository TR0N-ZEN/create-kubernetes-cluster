# install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# could have also been done with homebrew (if installed like in 02.md) via `brew install helm` 

cat <<'EOF'
# install helm via apt
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
EOF


# install ...
helm repo add jetstack https://charts.jetstack.io --force-update
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.15.3 \
  --set crds.enabled=true

cat <<'EOF'
digitally signed data is the data itself plus the
encrypted hash of the data which
is considered the certificate

the encrypted hash of the data is called the signature

the verification is done by
decrypting the signature with the public key and
compare it to the hash of the data

if the data can contain a reference to another authority

an authority can reference another authority until one is reached
to which a trusted public key is already on the system
such an authority issues root certificates and is called a root certificate authority

root certificates is as every certificate 
data, being the public key plus information about the root certificate authority, and
a signature which is the with the private key encrypted hash of the data

a root ca's certificate is always self signed

the root ca's certificate I guess only exists to associate information about the root ca with the public key

read
	https://en.wikipedia.org/wiki/Public_key_certificate
	https://en.wikipedia.org/wiki/Electronic_signature#/media/File:Digital_Signature_diagram.svg
EOF

# the certificate issuer helps requesting a certificate and installing it for your webserver
# TODO change and apply the rest of the file
# read
#   https://cert-manager.io/docs/configuration/acme/http01/
#   https://cert-manager.io/docs/configuration/acme/
cat <<'EOF' > certificate-ClusterIssuer.yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: my-acme-server-with-eab
spec:
  acme:
    email: user@example.com
    server: https://todo-replaceme-domain.com
    externalAccountBinding:
      keyID: my-keyID-1
      keySecretRef:
        name: eab-secret
        key: secret
    privateKeySecretRef:
      name: example-issuer-account-key
    solvers:
    - http01:
        ingress:
          ingressClassName: traefik
EOF

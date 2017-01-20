set -o x

echo "## Installing golang and setting environment"

TARBALL="https://storage.googleapis.com/golang/go1.6.3.linux-amd64.tar.gz"
UNTARPATH="/opt"

GOROOT="${UNTARPATH}/go"
GOPATH="${UNTARPATH}/gopath"

# Install Go
if [ ! -d ${GOROOT} ]; then
    sudo wget --progress=bar:force --output-document - ${TARBALL} |\
    tar xfz - -C ${UNTARPATH}
fi

# Setup GOPATH
sudo mkdir -p ${GOPATH}

# Setup profile
cat <<EOF > /tmp/gopath.sh
export GOROOT="${GOROOT}"
export GOPATH="${GOPATH}"
export PATH="${GOROOT}/bin:${GOPATH}/bin:\$PATH"
EOF

sudo mv /tmp/gopath.sh /etc/profile.d/gopath.sh

# Make sure the GOPATH is usable by vagrant
sudo chown -R vagrant:vagrant ${GOROOT}
sudo chown -R vagrant:vagrant ${GOPATH}

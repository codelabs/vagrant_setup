#!/bin/bash -x

VAGRANT_SSH="/home/vagrant/.ssh"
chmod 700 ${VAGRANT_SSH}
chmod 600 ${VAGRANT_SSH}/authorized_keys
chown -R vagrant:vagrant $VAGRANT_SSH

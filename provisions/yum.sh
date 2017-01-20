#!/bin/bash -x

# Provide all yum packages you want to install
echo "################################################################################"
echo "#### Installing additional packages in the new VM required for development. ####"
echo "## Installing misc yum packages"
yum --assumeyes install vim git kernel-devel gcc nc ngrep curl wget

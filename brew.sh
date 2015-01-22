#!/bin/bash
for package in automake colordiff coreutils gcc48 gemnasium-toolbelt git hub libksba libtool libyaml mercurial ossp-uuid postgresql redis ssh-copy-id wget; do brew install $package; done 

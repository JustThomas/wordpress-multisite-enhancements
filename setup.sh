#!/bin/sh

# WordPress test setup script for Travis CI 
#
# Author: Frank Bültge <f.bueltge@inpsyde.com>
# Kudos to: Benjamin J. Balter <ben@balter.com>
# License: GPL2+

export WP_CORE_DIR=/tmp/wordpress
export WP_TESTS_DIR=/tmp/wordpress-tests

# Init database
mysql -e 'CREATE DATABASE wordpress_test;' -uroot

# Grab specified version of WordPress from github
wget -nv -O /tmp/wordpress.tar.gz https://github.com/WordPress/WordPress/tarball/$WP_VERSION
mkdir -p $WP_CORE_DIR
tar --strip-components=1 -zxmf /tmp/wordpress.tar.gz -C $WP_CORE_DIR

# Grab via SVN testing framework
svn co --quiet --ignore-externals http://develop.svn.wordpress.org/trunk/ $WP_TESTS_DIR

# Grap custom WP test configuration
wget -nv -O $WP_TESTS_DIR/wp-tests-config.php https://raw.githubusercontent.com/bueltge/wordpress-multisite-enhancements/setup/wp-tests-config.php

# Put various components in proper folders
plugin_slug=$(basename $(pwd))
plugin_dir=$WP_CORE_DIR/wp-content/plugins/$plugin_slug

cd ..
mv $plugin_slug $plugin_dir

cd $plugin_dir
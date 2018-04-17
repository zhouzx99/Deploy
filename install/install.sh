#!/bin/bash

WorkDir=$(pwd)
TargetDir=$WorkDir/../..

Option="install"

if [ "$1" == "install" -o "$1" == "" ]; then
    Option="install"
elif [ "$1" == "uninstall" ]; then
    Option="uninstall"
else
    echo "Usage: $0 [uninstall]"
    echo ""
    echo "      -- $0          : intall the project"
    echo "      -- $0 uninstall: uninstall the project"
    echo "" 
    exit 0
fi

if [ $Option == "install" ]; then
    # Install the SmartCloud repository
    if [ -d $TargetDir/SmartCloud_Demo ]; then
	echo "The SmartCloud_Demo repository has been cloned, skip..."
    else
	git clone https://github.com/ejngnng/SmartCloud_Demo $TargetDir/SmartCloud_Demo
	echo "Clone the SmartCloud_Demo repository finished!"
	echo ""
    fi

    # Install ThinkPHP framework
    if [ -f $TargetDir/SmartCloud_Demo/thinkphp/base.php ]; then
	echo "The ThinkPHP framework for PHP has been installed, skip..."
    else
	rm -fr $TargetDir/SmartCloud_Demo/thinkphp
	git clone https://git.oschina.net/liu21st/framework.git $TargetDir/SmartCloud_Demo/thinkphp

	echo "Install the ThinkPHP framework for PHP finished!"
	echo ""
    fi

    # Install OAuth2
    if [ -d $TargetDir/SmartCloud_Demo/extend/oauth2-server-php ]; then
	echo "The OAuth2 for PHP has been installed, skip..."
    else
	git clone https://github.com/bshaffer/oauth2-server-php.git $TargetDir/SmartCloud_Demo/extend/oauth2-server-php
	if [ -d $TargetDir/SmartCloud_Demo/extend/oauth2-server-php/src/OAuth2 ]; then
	    ln -s oauth2-server-php/src/OAuth2 $TargetDir/SmartCloud_Demo/extend/OAuth2
	    echo "Install the OAuth2 for PHP finished!"
	    echo ""
	else
	    echo "Can't find the directory 'SmartCloud_Demo/extend/oauth2-server-php/src/OAuth2', please check!"
	fi
    fi

    # Install MQTT
    if [ -d $TargetDir/SmartCloud_Demo/extend/phpMQTT ]; then
	echo "The MQTT for PHP has been installed, skip..."
    else
	git clone https://github.com/bluerhinos/phpMQTT.git $TargetDir/SmartCloud_Demo/extend/phpMQTT

	echo "Install the MQTT for PHP finished!"
	echo ""

	cd $TargetDir/SmartCloud_Demo/extend/phpMQTT
	git am -p1 $WorkDir/PHPMQTT-patch-fix-namespace.patch
	cd $WorkDir
	echo "Apply the patch file for MQTT finished!"
	echo ""
    fi
fi

if [ $Option == "uninstall" ]; then
    # Uninstall ThinkPHP framework
    if [ -d $TargetDir/SmartCloud_Demo/thinkphp ]; then
	rm -fr $TargetDir/SmartCloud_Demo/thinkphp
	echo "Uninstall the ThinkPHP framework for PHP finished!"
    fi
    mkdir -p $TargetDir/SmartCloud_Demo/thinkphp

    # Uninstall OAuth2
    if [ -d $TargetDir/SmartCloud_Demo/extend/oauth2-server-php ]; then
	rm -fr $TargetDir/SmartCloud_Demo/extend/oauth2-server-php
	rm -f $TargetDir/SmartCloud_Demo/extend/OAuth2
	echo "Uninstall the OAuth2 for PHP finished!"
    fi

    # Uninstall MQTT
    if [ -d $TargetDir/SmartCloud_Demo/extend/phpMQTT ]; then
	rm -fr $TargetDir/SmartCloud_Demo/extend/phpMQTT
	echo "Uninstall the MQTT for PHP finished!"
    fi

    # Delete the SmartCloud_Demo repository
    if [ -d $TargetDir/SmartCloud_Demo ]; then
	rm -fr $TargetDir/SmartCloud_Demo
	echo "Uninstall the SmartCloud_Demo repository finished!"
    fi

fi


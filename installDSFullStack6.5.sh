#!/bin/bash
################################################################################

################################################################################

script_dir=`pwd`
ds_zip_file=~/Downloads/DS/DS-6.5.0.zip
ds_instances_dir=~/opends/ds_instances
ds_config=${ds_instances_dir}/config
ds_fullstack=${ds_instances_dir}/fullstack

#IDMFullStackSampleRepo
ds_fullstack_server=opendj.example.com
ds_fullstack_server_ldapPort=5389
ds_fullstack_server_ldapsPort=5636
ds_fullstack_server_httpPort=58081
ds_fullstack_server_httpsPort=58443
ds_fullstack_server_adminConnectorPort=54444

#Config
ds_amconfig_server=amconfig1.example.com
ds_amconfig_server_ldapPort=3389
ds_amconfig_server_ldapsPort=3636
ds_amconfig_server_httpPort=38081
ds_amconfig_server_httpsPort=38443
ds_amconfig_server_adminConnectorPort=34444



function install_fullstacksamplerepo(){

echo ========= Building ${ds_fullstack} - ${ds_fullstack_server} =========

cd ${ds_fullstack}/opendj/bin && ./stop-ds
rm -rf ${ds_fullstack}
mkdir -p ${ds_fullstack}
unzip ${ds_zip_file} -d ${ds_fullstack}

cd ${ds_fullstack}/opendj
./setup \
directory-server \
--rootUserDN "cn=Directory Manager" \
--rootUserPassword password \
--hostname ${ds_fullstack_server} \
--ldapPort ${ds_fullstack_server_ldapPort} \
--adminConnectorPort ${ds_fullstack_server_adminConnectorPort} \
--baseDN dc=com \
--ldifFile ~/Downloads/Example.ldif \
--acceptLicense
}


################################################################################
### Prepare a DS instance for use as a general config store

function install_config(){

echo  ========= Building ${ds_config} - ${ds_amconfig_server} ========= 

cd ${ds_config}/opendj/bin && ./stop-ds
rm -rf ${ds_config}
mkdir -p ${ds_config}
unzip ${ds_zip_file} -d ${ds_config}

cd ${ds_config}/opendj
./setup \
    directory-server \
    --rootUserDN "cn=Directory Manager" \
    --rootUserPassword password \
    --monitorUserPassword password \
    --hostname ${ds_amconfig_server} \
    --ldapPort ${ds_amconfig_server_ldapPort} \
    --ldapsPort ${ds_amconfig_server_ldapsPort} \
    --httpPort ${ds_amconfig_server_httpPort} \
    --httpsPort ${ds_amconfig_server_httpsPort} \
    --adminConnectorPort ${ds_amconfig_server_adminConnectorPort} \
    --profile am-config \
    --set am-config/amConfigAdminPassword:password \
    --acceptLicense
# --productionMode \

}


install_config
install_fullstacksamplerepo

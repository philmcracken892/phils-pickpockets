fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

description 'pickpockets system'
version '1.0.0'
author 'phil,mcracken'
shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

lua54 'yes'

dependencies {
    'rsg-core',
    'rsg-inventory',
    'rsg-target'
}

lua54 'yes'
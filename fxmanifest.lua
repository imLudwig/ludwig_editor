fx_version "cerulean"
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
games { "rdr3" }
lua54 "yes"
author "Ludwig Developement"
version '1.0.0'
name 'ludwig_editor'
description 'Ermöglicht das Ingame editieren von bestimmten config-files.'

shared_scripts {
    '@roschy_debug_system/main.lua',
    '@ox_lib/init.lua'
}

client_scripts {
    'client.lua'
}

ui_page {
    "html/index.html"
}

files {
    'html/vs/**',
    'html/index.html'

}

server_scripts {
    'serverconfig.lua',
    'server.lua'

}

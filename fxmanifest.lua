fx_version 'cerulean'
game 'gta5'

author 'Forge'
description 'DEFCON system for the police'
version '1.0.0'

shared_script 'config.lua'

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/logo_lspd.png',
    'html/defcon.js' -- Make sure the JS file is here
}

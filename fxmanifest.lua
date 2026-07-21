fx_version 'cerulean'
game 'gta5'

author 'Zyrexiw'
description 'Photo Mode Freecam'
version '1.0.0'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/freecam.lua',
    'client/ui.lua'
}

server_scripts {
    'server/main.lua'
}

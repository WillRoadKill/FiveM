fx_version 'cerulean'
game 'gta5'

description 'QB-LapRaces'
version '1.0.0'

ui_page "html/index.html"

client_scripts {
    'client/main.lua',
    'config.lua',
}

server_scripts {
    'server/main.lua',
    'config.lua',
}

files {
    'html/*.html',
    'html/*.css',
    'html/*.js',
    'html/fonts/*.otf',
    'html/img/*',
}

exports {
    'IsInRace',
    'IsInEditor',
}
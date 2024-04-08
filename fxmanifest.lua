fx_version "adamant"

game "gta5"
lua54 'yes'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'client/utils.lua',
	'client/main.lua'
}

export 'GeneratePlate'

ui_page('UI/index.html')

files {
    "UI/index.html",
    "UI/style.css",
    "UI/jquery.js",
    "UI/index.js",
    "UI/hehe.js",
    "UI/first.ttf",
	"UI/last.otf",
    "UI/SVG/kapatmadume.svg",
	"UI/UILang.js"
}

dependencies { 
	'es_extended',
	'BetterBankRemake'
}

escrow_ignore {
	'config.lua'
}

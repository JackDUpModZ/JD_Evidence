--####################################################################################
--#                                   DISCORD:                                       #
--#                                Mr Bluffz#0001                                    #
--####################################################################################

fx_version 'cerulean'
game 'gta5'

author 'Jack Daniels'
description "Evidence System For ESX V1.2+ Using mf-inventory"
version '1.0.0'

client_scripts {
    '@es_extended/locale.lua',
	'config.lua',
	'client/client.lua'
}

server_scripts {
    '@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/server.lua'
}

exports {
	'openInventory'
}

dependency 'es_extended'
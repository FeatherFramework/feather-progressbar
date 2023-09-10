fx_version "adamant"
games { "rdr3" }
rdr3_warning "I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships."
lua54 "yes"
author 'BCC Scripts'
name 'feather-progressbar'
version '1.2.0'

github_version_check 'true'
github_version_type 'release'
github_link 'https://github.com/FeatherFramework/feather-progressbar'

client_scripts {
    'client/client.lua'
}

ui_page 'ui/index.html'

files {
    'ui/*',
    'ui/assets/*',
    'ui/assets/fonts/*'
}

provide 'progressBars'


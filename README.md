# JackDUPModZ Evidence
## Evidence system built for mf-inventory

# Dependencies
- mysql-async
- es_extended (Tested on v1 final)
- zf_context
- zf_dialog

## UPDATE

Huge thanks to Mr Bluffz#0001 who literally coached me through the entire thing. and for helping to teach me what each of the changes actually meant.

There will be more updates to come in the future!.


# Instructions
Drag and drop to your resources folder

add to your server.cfg `ensure JD_Evidence`.

add `evidence = "Evidence"` to your mf-inventory locales. You can change Vault to anything you want for your language. It is what will be displayed.

## Adding new evidence lockers with inventory

This resource will automatically create the inventory in your database. All you need to do is add the trigger into esx_policejob or any script of your choosing to open the evidence menus then enter your desired case # and confirm its creation if needed.


-- SickJuggalo666#9786

## Deleting existing lockers 
Is now an option in the menus when select them. lockers are able to be deleted as well!!

Personal Police Lockers are now found and created based on xPlayer First and Last name! 
Add `exports['JD_Evidence']:openInventory()` to any script where you want to access the lockers or evidence.
Webhooks are added to monitor creation and deletion of lockers and evidence. Also easier for Owners and Admins to find certain lockers when needed!

Video ShowCase: https://streamable.com/0q84bp 

Thank You JackDaniels#0001 for letting me contribute! I love the Challenges and Hope this script can be AMAZING!!! 

-- SickJuggalo666#9786

# Misc

Read the config carefully with all the notes. There should not be any confusion.

Please do not claim this script as your own or attempt to sell this is open source so anyone can use it. If you have any suggestions or feature requests please contact me directly and i will be glad to help!

Author JackDaniels#0001

Support Discord https://discord.gg/aVxjeR3bGC


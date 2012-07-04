#===========Chamunks's SuperFantastic CustomCommandsConfig=============#
#This is a much better interface for commands to pex instead of hunting for stupid permissions nodes I can just edit commands here for the users to have
#How and When I want it.  Makes the failures of inheritance in pex's permissions.yml fall by the wayside.
#============================It Begins=================================#
#/demote = >>>
#	runas(~op, concat('/warp walrus')), 
#	runas(~op, concat('/summon jared526')), 
#	runas(~op, concat('/pex user jared526 group set trainee')), 
#	tmsg(player(jared526), concat('&6You have been &4demoted &6due to abuse of powers. \n &6You may choose to continue to play but you will remain in survival mode.'))
#<<<
##=========================================##
##Spawn Strategy for the classes           ##
##This spawncommand does not effect ondeath##
##Waiting on wraithguard to write that     ##
##Function in CommandHelper                ##
##Until then /spawn will execute Mywarp cmd##
## /warp ClassnameSpawn                    ##
##=========================================##
spawn:/spawn = _spawn()


##======PeonSpecificCommands======##
    ## Uncomment this one and delete the next one on release.
peon:/acceptrules = >>>
    runas(~op, /warp traineespawn)
    runas('~op', concat('/pex user ', player(), ' group set trainee'))
<<<

#peon:/acceptrules = >>>
#    runas('~op', concat('/warp cmdboard'))
#    msg(
#        color(6),'You may now enjoy the testing phase of this #server.\n',             color(2),'Welcome and enjoy your stay.'
#    )
#    runas('~op', concat('/pex user ', player(), ' group set trainee'))
#<<<

    # This command will change once the "HomeSpawnPlus" plugin is fully configured and the temples are set up.
peon:/denyrules = >>>
    runas('~op', '/warp testee')
    runas('~op', concat(
            '/kick', ' ', player(), ' ', color(6), player(),
            color(5) 'wont accept our rules?  then ',color(6), player(), color(5) 'can play elsewhere. ', color(4), 'KICKED!'))
<<<

##======TraineeSpecificCommands======##
##This userclass just decides what Userclass Type they will choose for their gameplay experience
## Becoming a trainee takes one of two elements
## 1: You pass the Peon Tutorial area and get promoted to trainee via /acceptrules
## 2: You pass up your userclass and all of your protections inventory and iconomy cash to re-roll.
##===================================##
trainee:/path $class = >>>
    if(
        or(
            equals($class, 'worker'),
            equals($class, 'hobo')
        )
    ,#then
        runas('~op', concat('/warp ', $class, 'spawn'))

        if(equals($class, 'hobo'),
            msg(
                color(5), 'You have chosen the path of the ', _pgroup_name($class), color(5), '!\n',
                color(5), 'You will now be sent to the Central Spawn Hub.\n',
                color(6), 'Swim up the drainage water from above to exit the sewers'
            )
        ,#else
            msg(
                color(5), 'You have chosen the path of the ', _pgroup_name($class), color(5), '!\n',
                color(5), 'Welcome to the Central Spawn'
            )
        )

        lightning(ploc(player()), true)
        set_peffect(player(), 15, 1, 5)
        set_peffect(player(), 9, 1, 12)
        runas('~op', concat('/pex user ', player(), ' group set ', $class))
    ,#else
        runas('~op', '/warp AcceptPath')
        msg(
            color(5), 'You have chosen the path of the ', _pgroup_name($class), color(5), '!\n',
            color(6), 'Will You Accept Your Choice?\n',
            color(5), 'Also Proceed to the Central Spawn Hub.'
        )
        lightning(ploc(player()), true)
        set_peffect(player(), 15, 1, 5)
        set_peffect(player(), 9, 1, 12)
        runas('~op', concat('/pex user ', player(), ' group set ', $class))
    )
<<<

trainee:/denypath = >>>
    msg(color(1)'As you wish, you may now choose a different class or start over.'),
    runas('~op', /warp thesix),
    runas('~op', concat('/pex user ', player(), ' group set trainee'))
<<<
trainee:/acceptpath = call_alias(/promote)

trainee:/promote [$pname] = >>>
    if(equals($pname, ''),
        assign(@player, player()),
        assign(@player, $pname)
        ),
        assign(@pgrp, pgroup(player($pname))[0])
        assign(@pgname, reg_replace('\\d', '', @pgrp))
        assign(@pgrank, reg_replace('\\D', '', @pgrp))
            if(is_numeric(@pgrank),
                assign(@pgnewrank, add(@pgrank, 1)),
                assign(@pgnewrank, 0)
            )
        assign(@pgnewgroup, concat(@pgname, @pgnewrank))
        tmsg(@player, color(5), 'You have been promoted to',  color(6), _pgroup_name(@pgname), '\n',
            color(5), 'with the rank of ', color(6), @pgnewrank, '. ', @pgnewgroup)
#        msg(' @pgrp ', @pgrp, ' @pgname ', @pgname, ' @pgrank ', @pgrank, ' @pgnewrank '@pgnewrank, ' @pgnewgroup ' @pgnewgroup)
#        tmsg(@player, '/pex user ', @player, ' group set ', @pgnewgroup)
        runas('~op', concat('/pex user ', @player, ' group set ', @pgnewgroup))
<<<

###=====================ApprenticeClasses============================###
#This group of classes are meant to only exist within their class's
#tutorial(temple) area long enough to follow the teachings and trials
#of their chosen classes or return to the path choosing section.
# THIS SECTION IS TO BE ADDED LATER. After the creation of the temples if they get done.
    ##=======RE-Roll Commands========##
    ## Rerolling must hurt alot      ##
    ## Clear inventory, LWC, Iconomy ##
    ## Protections                   ##
    ## Basically start a new.        ##
    ###################################
#    reroll:/reroll = >>>
#        runas('~op', /warp reroll),
#        msg(
#            color(e), 'Will you sacrafice', color(5), 'everything to', color(3), 'Re-Roll', color(e), 'a new class?\n'
#            color(6), 'If you will make the ultimate sacrafice to Re-Roll?'
#        )
#    <<<
###=====================Full User Classes============================###
# This section is essentailly the perks section for each of the classes
# and the classes levels.
# This section also fixes some issues with pex and multiple inheritance.
###========================It Begins=================================###
#Assassin1:
#Assassin2:
#ETC...
level0:/check = run(/hawk tool)
level0:/help = >>>
    run(/warp commands)
    msg(
        color(5), 'Welcome to ', color(6), 'ReaveCraft ', color(5), 'Command General ', color(b), 'Hospital'
    )
    msg(
        color(5), 'You may choose to leave at any time by typing ', color(b), '/Spawn ', color(5), 'OR '
    )
    msg(
        color(5), 'You may type ', color(b), '/Home ', color(5), 'if you have set one yet'
    )
<<<
    ## Basic aliases with specific permissions to give to each player class ##
    chicken:/chicken = runas(~op, /md chicken)
    cow:/cow = runas(~op, /md cow)
    mooshroom:/mooshroom = runas(~op, /md mooshroom)
    ocelot:/ocelot = runas(~op, /md ocelot)
    pig:/pig = runas(~op, /md pig)
    sheep:/sheep = runas(~op, /md sheep)
    squid:/squid = runas(~op, /md squid)
    villager:/villager = runas(~op, /md villager)
    enderman:/enderman = runas(~op, /md endermen)
    wolf:/wolf = runas(~op, /md wolf)
    pigman:/pigman = runas(~op, /md pigman)
    blaze:/blaze = runas(~op, /md blaze)
    cavespider:/cavespider = runas(~op, /md cavespider)
    creeper:/creeper = runas(~op, /md creeper)
    ghast:/ghast = >>>
runas(~op, /md ghast),
msg(color(6), ‘Ghasts are annoying and unbelievable cute, I hate you for making me do this.’
)
    magmacube:/magmacube = runas(~op, /md magmacube)
    silverfish:/silverfish = runas(~op, /md silverfish)
    Skeleton:/skeleton = runas(~op, /md skeleton)
    slime:/slime = runas(~op, /md slime)
    spider:/spider = runas(~op, /md spider)
    spiderjockey:/spiderjockey = msg(color(6), ‘Currently this mob is impossible’)
    zombie:/zombie = runas(~op, /md zombie)
    undisguise:/human = runas(~op, concat('/md'))
    baby:/baby = run(concat('/md baby ', player()))


##==================Staff========Commands============================##
#These are the staff commands promoted from Section:
#"Other Handy Dandy Appendages" to full staff commands
#Next step may be promoted to something a user can use.
##===================================================================##
    ##===========================================================##
    # General Staff Only Commands here
    ##===========================================================##
#        /warn [$target] $reason = >>>
#        if( #Begin Syntax check
#            equals($target, ''), # End First Condition
#            msg(color(6), 'Error: You must Specify Both a Target Player and a Reason for the Warning.'), #Returned Error to Staff member
#            if(equals(has_permission($target, warned.2)), call_alias(warn3), 
#                if(equals(has_permission(player($target), warned.1)), 
#                    runas(~op, concat('/pex ', player($target), ' user add warned.2.', $reason)) 
#                    kick(player($target), concat(color(6), 'You have been warned already ', color(4), 'ONCE! ', color(6), 'You ve been Kicked for ', color(5), $reason)), 
#                    if(nequals(has_permission(warned.*), ''),
#                        runas(~op, concat('/pex ', player($target), ' user add warned.1.'$reason)), 
#                        tmsg(player($target), color(6), 'You are being oficially warned for the ', color(4), 'FIRST ', color(6), 'time. For the reason ', color(5), $reason)
#                    )
#                ) 
#            ) #End Check if already Kicked
#        )
#    <<<
#            /warn3 $target $reason = >>>
#                set_pmode($target, SURVIVAL), 
#                runas(~op, sconcat(/clear, -a, $target)),  
#                runas(~op, sconcat(/lwc, purge, user, $target)), 
#                runas(~op, sconcat(/hawk, rollback, player($target))), 
#                runas(~op, sconcat(/ch, gmute, $target)), 
#                runas(~op, sconcat(/pex, user, $target, group, set, banned)), 
#                runas(~op, concat('/pex user ', $target, ' add warned.3.', $reason)), 
#                runas(~op, sconcat(/ban, $target)), 
#                kick(player($target), concat(color(6), 'You have been warned already ', color(4), 'Twice ', color(6), 'You have now been Banned from ReaveCraft.')) #End Action
#            <<<
#    staff:/flashbang [$target] = >>>
#        lightning(ploc($target), true)
#        set_peffect(player($target), 15, 1, 5)
#        set_peffect(player($target), 9, 1, 12)
#        tmsg(player($target), '§5You have been struk by a flashbang!')
#    <<<
    staff:/SetExpLevel [$target] [$levels] = set_plevel($target, $levels)
    staff:/ruler = msg(_3d_distance(sk_pos1(), sk_pos2()) '§6spaces between the selected blocks.')
    staff:/helpstaff = runas(~op, /warp StaffHelp)
    
        ##==================StaffTeleportCommands============##
        #This needs attention, I plan on people having access to '/homeworld' at some point
        ##===================================================##
        staff:/goto [$target] = runas(~op, concat(/tp player() $target))
        # stafftp:/goto [$X] [$Y] [$Z] =
            #TP to player
        staff:/summon [$target] = runas(~op, concat(/tp $target player()))
            #Bring Player to self
    ##=====================Staff, Class Specifics========================##
    # No I'm not talking about gandalfs staff here
    ##=======================It Begins===================================##
        ##Moderator##
        moderator:/pwn $target = >>>
            set_pmode($target, SURVIVAL)
            runas(~op, sconcat(/clear, -a, $target))
             runas(~op, sconcat(/lwc, purge, user, $target))
            runas(~op, sconcat(/hawk, rollback, player))
            runas(~op, sconcat(/ch, gmute, $target))
            runas(~op, sconcat(/ban, $target))
            runas(~op, sconcat(/pex, user, $target, group, set, banned))
        <<<
        moderator:/unpwn $target = >>>
            runas(~op, sconcat(/unban $target))
            runas(~op, sconcat(/ch, gmute, $target))
            runas(~op, sconcat(/pex, user, $target, group, set, peon))
        <<<
        moderator:/mute $target = runas(~op, sconcat(/ch, gmute, $target))
#moderator:/mute player with delayed unmute record who muted when and why
    #Needs to wait for Events to be released on commandhelper

#moderator:/kick [$target] [$reason] = >>>
#    runas(~op, concat(/kick $target))
#    msg($target, concat(color(4), 'You've been kicked from the server for ', $reason))
#<<<
        ##deltateam##
        deltateam:/day = set_world_time(pworld(player()), day)
        deltateam:/night = set_world_time(pworld(player()), night)
        deltateam:/morning = set_world_time(pworld(player()), morning)
        deltateam:/evening = set_world_time(pworld(player()), evening)
        deltateam:/sun = storm(false, pworld(player()))
        deltateam:/storm = storm(true, pworld(player()))
        deltateam:/cr = set_pmode(player(), CREATIVE)
        deltateam:/sur = set_pmode(player(), SURVIVAL)
        deltateam:/lag = runas(~op, /lag)
#deltateam:/sun = runas(~op, /weather sunny)
#deltateam:/storm
#deltateam:/spawnm = runas(~op, /spawnmob)
    #AllowdeltateamToSpawnMobs

##==================World Shortcuts for Admins=======================##
# Can be given to others with their appropriate group alias's
##===================================================================##
staff:/homeworld = runas(~op, /mvtp world)
warps:/Mugen = runas(~op, /mvtp Mugen)
warps:/Jin = runas(~op, /mvtp Jin)
#warps:/Fuu = runas(~op, /mvtp Fuu)
warps:/Liz = runas(~op, /mvtp Liz)
warps:/Old = runas(~op, /mvtp Old)
warps:/edo = runas(~op, /mvtp edo)
warps:/Momo = runas(~op, /mvtp Momo)
warps:/SkyBlock = runas(~op, /mvtp SkyBlock)
warps:/ForbiddenCity = runas(~op, /mvtp project1845)
warps:/maciekwys = runas(~op, /mvtp maciekwys)
warps:/infection = runas(~op, /mvtp TheInfection)
warps:/Piro = runas(~op, /mvtp Piro)
warps:/demolition = runas(~op, /mvtp Demolition)
# maintenance:/Reave = runas(~op, /mvtp Reave)

##==================Events and game commands=========================##
# May be given to different classes or none depending on the command
# Most events should be free from the need to run commands or have
# Staff supervision
##===================================================================##
events:/pirospleef1 = runas(~op, /region select pirospleef1), runas(~op, /i ironshovel 1), runas(~op, //set snowblock)
maintenancemode:/sbbn = runas(~op, /region select skyblocknorthbridge), runas(~op, //replace gravel)
maintenancemode:/sbbe = runas(~op, /region select skyblockeastbridge), runas(~op, //replace gravel)
maintenancemode:/sbbw = runas(~op, /region select skyblockwestbridge), runas(~op, //replace gravel)
maintenancemode:/sbbs = runas(~op, /region select skyblocksouthbridge), runas(~op, //replace gravel)
maintenancemode:/sbball = call_alias(/sbbn), call_alias(/sbbe), call_alias(/sbbw), call_alias(/sbbs)
maintenancemode:/sbr1 = call_alias(/xload SkyBlockMaster)
maintenancemode:/sbr2 = >>>
        runas(~op, /region select SkyBlockMaster)
        call_alias(/360)
<<<
maintenancemode:/sbretractnorth = >>>
        runas(~op, /region select skyblockNorthBridge)
        runas(~op, //set gravel)
        runas(~op, //schematic load skyblockNorthBridgeInPlay)
<<<
maintenancemode:/sbretracteast = >>>
        runas(~op, /region select skyblockEastBridge)
        runas(~op, //set gravel)
        runas(~op, //schematic load skyblockEastBridgeInPlay)
<<<
maintenancemode:/sbretractwest = >>>
        runas(~op, /region select skyblockWestBridge)
        runas(~op, //set gravel)
        runas(~op, //schematic load skyblockWestBridgeInPlay)
<<<
maintenancemode:/sbretractsouth = >>>
        runas(~op, /region select skyblockSouthBridge)
        runas(~op, //set gravel)
        runas(~op, //schematic load skyblockSouthBridgeInPlay)
<<<
maintenancemode:/sbextendnorth = runas(~op, //schematic load skyblockNorthBridgeExtended)
maintenancemode:/sbextendeast = runas(~op, //schematic load skyblockEastBridgeExtended)
maintenancemode:/sbextendwest = runas(~op, //schematic load skyblockWestBridgeExtended)
maintenancemode:/sbextendsouth = runas(~op, //schematic load skyblockSouthBridgeExtended)
    ##===========================================================##
    # Non Specific Game Commands and Modifiers
    ##===========================================================##
    maintenancemode:/drunk [$timeout]= set_peffect(player(), 9, 1, $timeout)
    maintenancemode:/blind [$timeout]= set_peffect(player(), 15, 1, $timeout)
    maintenancemode:/sniper [$timeout]= set_peffect(player(), 2, 10, $timeout)
    staff:/candy [$effect] [$timeout] = set_peffect(player(), $effect, $timeout) tmsg(player(), '§5You have eaten a special candy!')

##==================OTHER HANDY DANDY APPENDAGES=====================##
# certainly not of the falic sort
##=========================It Begins=================================##
deltateam:/360 = >>>
    run(//copy)
    run(//schematic save 360cpp)
    run(//rotate 90)
    run(//paste)
    run(//rotate 90)
    run(//paste)
    run(//rotate 90)
    run(//paste)
    run(//rotate 90)
    run(//paste)
<<<
deltateam:/undo360 = >>>
    run(//schematic load 360cpp)
    run(//rotate 90)
    run(//paste)
    run(//rotate 90)
    run(//paste)
    run(//rotate 90)
    run(//paste)
    run(//rotate 90)
    run(//paste)
<<<
/xreload = >>>
    broadcast('§6Incoming Reload')
    runas(~op, /reload)
    broadcast('§5Reload Finished! §bResume enjoyment~')
<<<
/whiteadd $target = >>>
    runas(~op, /whitelist add $target)
    msg('§6Player §b[$target]§6, has now been added to the server whitelist.\n §4Now reloading whitelist...')
    runas(~op, /whitelist reload)
    msg('§a Whitelist has been reloaded!')
<<<
/whiteremove $target = >>>
    runas(~op, /whitelist remove $target)
    msg('§6Player' §b[$target]'§6, has now been §4REMOVED§6 from the server whitelist.\n §4Now reloading whitelist...')
    runas(~op, /whitelist reload)
    msg('§a Whitelist has been reloaded!')
<<<
inheritall:/msg [$player] = /tell $player $
inheritall:/op [$deny] = msg(§6 Sorry OP is impossible!)
#inheritall:/plugins = msg(§6 How dare you look there thats inappropriate!)
inheritall:/c = msg('§ff §77 §ee §cc §dd §99 §bb §aa\n§00 §88 §66 §44 §55 §11 §33 §22') would output all the color codes.


##============AdminOnly=============##
## This Section is for core staff only
##these things should never apply elsewhere
##==================================##
##+++++++++++++++++++SERVER MAINTENANCE STUFF+++++++++++++++++++++++++##
##++++++++++++++++++Comment Out Before Launch+++++++++++++++++++++++++##
staff:/HelpStaff = runas(~op, /warp HelpStaff)
maintenancemode:/xchgrp $group = runas(~op, concat(/pex user player() group set $group))
maintenancemode:/xchown [$user] [$group] = runas(~op, concat(/pex user $user group set $group))
maintenancemode:/ideal = >>>
    runas('~op', /butcher), 
    set_world_time(pworld(player()), morning), 
    storm(false, pworld(player()))
<<<
maintenancemode:/rape $target = >>>
    set_pmode($target, SURVIVAL)
    runas(~op, sconcat(/shock, $target))
    runas(~op, sconcat(/rocket, $target))
    tmsg($target, 'You have insighted the wrath of Iridious, you shall expect this won\'t feel good.')
<<<
    ## RELOADS SubSection ##
maintenancemode:/ra = runas(~op, /reloadaliases) msg('§6AliasesReloaded!')
maintenancemode:/rpex = runas(~op, /pex reload) msg('§4PermissionsReloaded!')
maintenancemode:/rsb = runas(~op, /sbreload) msg('§6ScriptBlockReloaded!')
maintenancemode:/rsa = runas(~op, /simpleannounce reload)
maintenancemode:/mvr = runas(~op, /mv reload)

#/pex [$filler] = msg('§6Bet you thought you could use this command to change rank.\n §4Nope! §6its just me Chuck Testa and another realistic Mount.')
/xstop = >>>
    runas(~op, /kick * concat(color(2), 'Server is performing a ', color(6), 'Re-Start! ', color(2), 'We will be back in a minute :) were improving stuff'))
    runas(~op, /save-all)
    runas(~op, /stop)
<<<
staff:/p $pname = runas(~op, concat('/mvp create' $pname 'p:traineeSixE'))
staff:/xsave [$target] = >>>
    run(/region select $target)
    run(//schematic save mcedit $target)
<<<
staff:/xload [$target] = >>>
    run(//schematic load $target)
    run(//paste -o)
<<<
    ## This Subsection will just be for setup stuff ##
    ## Currently its a super createwarp thing
    /movespawn $groupname = >>>
        call_alias(removespawn)
        call_alias(createspawn)
    <<<
    /createspawn $groupname = >>>
        runas('~op', concat('/warp pcreate ', $groupname,'0spawn'))
        runas('~op', concat('/warp pcreate ', $groupname,'1spawn'))
        runas('~op', concat('/warp pcreate ', $groupname,'2spawn'))
        runas('~op', concat('/warp pcreate ', $groupname,'3spawn'))
        runas('~op', concat('/warp pcreate ', $groupname,'4spawn'))
        runas('~op', concat('/warp pcreate ', $groupname,'5spawn'))
        runas('~op', concat('/mvpc ', $groupname,'SpawnE'))
    <<<
    /removespawn $groupname = >>>
        runas('~op', concat('/warp delete ', $groupname,'0spawn'))
        runas('~op', concat('/warp delete ', $groupname,'1spawn'))
        runas('~op', concat('/warp delete ', $groupname,'2spawn'))
        runas('~op', concat('/warp delete ', $groupname,'3spawn'))
        runas('~op', concat('/warp delete ', $groupname,'4spawn'))
        runas('~op', concat('/warp delete ', $groupname,'5spawn'))
        runas('~op', concat('/mvpr ', $groupname,'SpawnE'))
    <<<
    ## This Subsection is meant for setting up the temple of the six
    ## it essentially macro's the installation of scriptblock walk blocks
    ## And uses the /path$Userclass as the command target
    ## essentailly using the /path$Userclass should offload all responsibility from ScriptBlock
    ## named /cp on initial setup to be renamed to /classpath
    /cp $class = >>>
        runas('~op', concat('/sbcreatewalk /path', $class))
    <<<



##### FUCKING AROUND #####
#This should describe how to identify Staff.
## /Staff = >>>

# Vote Command Should bring you directly to the voting page.
#level0:/vote = >>>
#    msg(
#        color(
#            5
#        ), 
#        'Visit ', 
#        color(
#            b
#        ), 
#        'http://Goo.gl/XXXX ',
#        color(
#            5
#        )
#        'To Support Us!'
#    )
#<<<
# Donate Wrapper for BuyCraft Make it mindNumbingly simple to Earn us Cash!
#/Donate = >>> 
#    msg(
#        color(
#            5
#        ), 
#        'Visit ', 
#        color(
#            b
#        ), 
#        'http://Goo.gl/xxxx ',
#        color(
#            5
#        )
#        'To buy upgrades!'
#    )
#Social Promotion!
## /Youtube = >>>
## /Facebook = >>>
## /Twitter = >>>
## /MineCraftForum = >>>
## /ScreenShots = >>>


#rainbowSHEEP:/rainbow = >>>
#    spawn_mob(SHEEP, 1, ploc(player())),
#    spawn_mob(SHEEP:RED, 1, ploc(player())),
#    spawn_mob(SHEEP:GREEN, 1, ploc(player())),
#    spawn_mob(SHEEP:BROWN, 1, ploc(player())),
#    spawn_mob(SHEEP:BLUE, 1, ploc(player())),
#    spawn_mob(SHEEP:PURPLE, 1, ploc(player())),
#    spawn_mob(SHEEP:CYAN, 1, ploc(player())),
#    spawn_mob(SHEEP:SILVER, 1, ploc(player())),
#    spawn_mob(SHEEP:GRAY, 1, ploc(player())),
#    spawn_mob(SHEEP:PINK, 1, ploc(player())),
#    spawn_mob(SHEEP:LIME, 1, ploc(player())),
#    spawn_mob(SHEEP:YELLOW, 1, ploc(player())),
#    spawn_mob(SHEEP:LIGHT_BLUE, 1, ploc(player())),
#    spawn_mob(SHEEP:MAGENTA, 1, ploc(player())),
#    spawn_mob(SHEEP:ORANGE, 1, ploc(player())),
#    spawn_mob(SHEEP:WHITE, ploc(player()))
#<<<
#safe:/myregions = >>>
#    assign(@pname,pinfo()[0])
#    assign(@regions,sk_all_regions(pworld()))
#    assign(@uregions, array())
#    foreach(@regions,@region,
#       assign(@rowners,sk_region_info(@region, pworld()))
#       if(array_contains(@rowners[1],@pname),
#          array_push(@uregions,@region)
#       )
#    )
#    if(equals(array_size(@uregions),0),
#      msg(You have no regions),
#      msg(
#        color(    
#            5
#        ), 
#        'Your regions are: ',
#        color(
#            b
#        ),
#         array_implode(@uregions)
#    )
#    )
#<<<
/steps $blocktype = >>>
    run(//shift 1 me),
    run(//shift 1 up),
    run(//set $blocktype)
<<<
Whois:/whois [$player] = >>>
  if(equals($player, ''),

    assign(@p, player())
    msg(color(YELLOW), 'Your IP: ', pinfo(@p, 3)),

    assign(@p, $player)
    if(not(ponline(@p)),

        msg($player, color(RED), ' is not online.')
        die(),

        msg(color(YELLOW), 'IP of ', color(WHITE), @p, ': ', color(YELLOW), pinfo(@p, 3))))

<<<

/sp2 = >>>
    run(/region select sp1)
    run(//set grass)
<<<
staff:/nick [$dname] [$pnick] = set_display_name($dname $pnick)
staff:/door $target = make_effect(ploc($target), DOOR_TOGGLE, 64)
##### FUCKING AROUND END##

## ADD CODE HERE FOR NOW ##
#When we get the code from ACZChef we can throw this into the appropriate area.
## Go~
#Social Promotion!
## /Youtube = >>>
## /Facebook = >>>
## /Twitter = >>>
## /MineCraftForum = >>>
## /ScreenShots = >>>
level0:/Fumbledore = runas(~op, /warp Fumbledore)
level0:/donate = msg(color(1), '[', color(4), 'ReaveCraft', color(1), ']', color(2), ' Donate using the /buy command.')
level0:/vote = >>>
        msg(color(1), '[', color(4), 'ReaveCraft', color(1), ']', color(2), ' Vote Daily at the following links \n', 
        color(b), 'http://goo.gl/FjExa ', color(2), ' MineStatusDOTnet ', '\n', 
        color(b), 'http://goo.gl/V15fe ', color(2), ' PlanetMinecraftDOTcom\n', 
        color(b), 'http://goo.gl/SjDdf ', color(2), ' XtremeTop100DOTcom\n', 
        color(2), 'To earn ', color(a), 'Extra', color(2), ' Crindars! \n', 
        color(2), 'Remember the more you vote the more you earn!'
        )
<<<
level0:/facebook = msg(color(1), '[', color(4), 'ReaveCraft', color(1), ']', color(2), ' Show Love & Support! \n', color(2), 'Join, Like and Share us on Facebook! \n', color(b), 'http://goo.gl/52k9a ',  color(2), 'Facebook Link.')
level0:/Youtube = msg(color(1), '[', color(4), 'ReaveCraft', color(1), ']', color(2), ' Like, Share, Comment and Subscribe our Youtube Channel at. ', color(b), 'http://goo.gl/LYOEh')
# level0:/twitter = msg(color(1), '[', color(4), 'ReaveCraft', color(1), ']', color(2), ' Follow us at twitter for Event Updates. ', color(b), 'http://goo.gl/LYOEh')
warps:/Fuu = runas(~op, /mvtp Fuu), set_pmode(player(), CREATIVE), msg(color(1), '[', color(4), 'ReaveCraft', color(1), ']', color(2), ' Welcome to Fuu our Creative Map.')
    warps:/Box1 = run(/warp box1), set_pmode(player(), CREATIVE), msg(color(1), '[', color(4), 'ReaveCraft', color(1), ']', color(2), ' Welcome to Fuu our Creative Map. \n', color(2), 'You are in Creative Build Sandbox #1')
    warps:/Box2 = run(/warp box2), set_pmode(player(), CREATIVE), msg(color(1), '[', color(4), 'ReaveCraft', color(1), ']', color(2), ' Welcome to Fuu our Creative Map. \n', color(2), 'You are in Creative Build Sandbox #2')
    warps:/Box3 = run(/warp box3), set_pmode(player(), CREATIVE), msg(color(1), '[', color(4), 'ReaveCraft', color(1), ']', color(2), ' Welcome to Fuu our Creative Map. \n', color(2), 'You are in Creative Build Sandbox #3')
    warps:/Box4 = run(/warp box4), set_pmode(player(), CREATIVE), msg(color(1), '[', color(4), 'ReaveCraft', color(1), ']', color(2), ' Welcome to Fuu our Creative Map. \n', color(2), 'You are in Creative Build Sandbox #4')
    warps:/Box5 = run(/warp box5), set_pmode(player(), CREATIVE), msg(color(1), '[', color(4), 'ReaveCraft', color(1), ']', color(2), ' Welcome to Fuu our Creative Map. \n', color(2), 'You are in Creative Build Sandbox #5')
    warps:/Box6 = run(/warp box6), set_pmode(player(), CREATIVE), msg(color(1), '[', color(4), 'ReaveCraft', color(1), ']', color(2), ' Welcome to Fuu our Creative Map. \n', color(2), 'You are in Creative Build Sandbox #6')
    warps:/Box7 = run(/warp box7), set_pmode(player(), CREATIVE), msg(color(1), '[', color(4), 'ReaveCraft', color(1), ']', color(2), ' Welcome to Fuu our Creative Map. \n', color(2), 'You are in Creative Build Sandbox #7')
    warps:/Box8 = run(/warp box8), set_pmode(player(), CREATIVE), msg(color(1), '[', color(4), 'ReaveCraft', color(1), ']', color(2), ' Welcome to Fuu our Creative Map. \n', color(2), 'You are in Creative Build Sandbox #8')
    warps:/Box9 = run(/warp box9), set_pmode(player(), CREATIVE), msg(color(1), '[', color(4), 'ReaveCraft', color(1), ']', color(2), ' Welcome to Fuu our Creative Map. \n', color(2), 'You are in Creative Build Sandbox #9')
warps:/worldnames = runas(~op, /warp WorldNames)

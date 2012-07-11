#===============================================================================
#
#   Sample external mscript include
#
#===============================================================================

#Returns the Pgroup HumanReadable name.
proc(_pgroup_name, @pgroup,
	reg_replace('\\d', '', @pgroup)
	assign(@pgnames, array(
		peon:        color(3). '['. color(8). 'Peon' color(3). ']',
		trainee:     color(3). '['. color(8). 'Trainee' color(3). ']',
		hobo:        color(3). '['. color(f). 'Hobo' color(3). ']',
		worker:      color(3). '['. color(f). 'Worker' color(3). ']',
		assassin:    color(3). '['. color(0). 'ShadowWraith'. color(3). ']',
		blacksmith:  color(3). '['. color(7). 'InfernalAnvil' color(3). ']',
		builder:     color(3). '['. color(6) 'CursedMason'. color(3). ']',
		farmer:      color(3). '['. color(2). 'DemonCultivator' color(3). ']',
		hunter:      color(3). '['. color(c). 'SilentStalker' color(3). ']',
		miner:       color(3). '['. color(8). 'StoneGoblin' color(3). ']',
		moderator:   color(4). '['. color(5). 'PainReaver' color(4). ']',
		deltaTeam:   color(4). '['. color(6). 'SoulReaver' color(4). ']',
		admin:       color(4). '['. color(1). 'DeathReaver' color(4). ']'
	))
	if(array_index_exists(@pgnames, @pgroup),
		return(@pgnames[@pgroup])
	,#else
		return(color(4)'. NO GROUP'))
	)
)
#proc(_promote, )

#Returns the distance between two blocks, or any other 3d points, for that matter
proc(_3d_distance, @arr1, @arr2,
    return(
        floor(
            sqrt(
                add(
                    pow(subtract(@arr2[0], @arr1[0]), 2),
                    pow(subtract(@arr2[1], @arr1[1]), 2),
                    pow(subtract(@arr2[2], @arr1[2]), 2)
                )
            )
        )
    )
)

#Given two blocks, iterates through all the blocks inside the cuboid, and calls the
#user defined function on them. The used defined procedure should accept 3 parameters,
#the x, y, and z coordinates of the block.
proc(_iterate_cuboid, @b1, @b2, @proc_name,
    for(assign(@x, min(@b1[0], @b2[0])), lte(@x, max(@b1[0], @b2[0])), inc(@x),
        for(assign(@y, min(@b1[1], @b2[1])), lte(@y, max(@b1[1], @b2[1])), inc(@y),
            for(assign(@z, min(@b1[2], @b2[2])), lte(@z, max(@b1[2], @b2[2])), inc(@z),
                call_proc(@proc_name, @x, @y, @z)
            )
        )
    )
)
##EndTimeoutCommand##
proc(_cooldown, @time, @id,
	if(!is_null(assign(@oldTime, get_value('cooldown_time_'. player(). '_'. @id))) && lt((time() - @oldTime) / 1000, @time),
		die('§cYou have to wait before doing that again.'),
		store_value('cooldown_time_'. player(). '_', @id, time())
	)
)

##Class Spawn Warp Call##
proc(_spawn, runas(~op, '/warp' pgroup()[0] 'spawn'))

##ServerWide Cooldown would be great for community spawning of enderdragon for example.
proc(_scooldown_global, @time, @id,
	if(!is_null(assign(@oldTime, get_value(concat('cooldown_time_', @id)))) && lt((time() - @oldTime) / 1000, @time),
		die('§cYou have to wait before doing that again.'),
		store_value('cooldown_time_'. @id, time())
	)
)


##Player Specific Cooldown
proc(_pcooldown, @time, @id,
	if(!is_null(assign(@oldTime, get_value('cooldown_time_'. player(). '_'. @id))) && lt((time() - @oldTime) / 1000, @time),
		die('§cYou have to wait before doing that again.'),
		store_value('cooldown_time_'. player(). '_'. @id, time())
	)
)
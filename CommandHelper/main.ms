######################################################
#
#   Sample Main file. This file is run when the server
#   starts up, or the plugin is reloaded. It can be used
#   as an opportunity to register events or do other things
#   when the server initially starts. Variables defined here
#   will go out of scope, so you can't assign() something and
#   then use it in a command, for instance.
#
######################################################

#assign(@server_name, '<Server Name>')

#Echo out a server greeting to the console
#console('Welcome to this server, which is running CommandHelper!')

#Bind an event to the player join, and tell ops hello. We send in
#@server_name, so we can use it inside the event handler
#bind(player_join, null, null, @event, @server_name,
#    #if the player is an op, let's send them a message
#    if(pisop(@event[player]), tmsg(@event[player], 'Welcome to' @server_name))
#)
##======================On Join Events===============================##
# These are things that are triggered by a player join into the server.
# Especailly helpful to blanket disable something per user.
# or even blanket announce something to the server.
##===================================================================##
#bind(player_join, null, null, @event, runas(~op, concat('/md')))

# bind(player_interact, null, array(button: right), @event, <code> )

##======================On Spawn Events==============================##
# This is the automated Spawn System
#
##===================================================================##
bind(player_spawn, null, null, @event, runas(~op, /tp player() chamunks) cancel())

##======================Chat Events==================================##
bind(player_chat, null, null, @event,
    assign(@players, @event['recipients'])
    assign(@highlight, array())
    assign(@normal, array())
    assign(@split, reg_split('[ !.\\/,\']', @event['message']))
    foreach(@split, @word,
        if(array_contains_ic(@players, @word),
            if(not(array_contains_ic(@highlight, @word)),
                array_push(@highlight, @word)
            )
        )
    )

    foreach(@players, @p,
        if(not(array_contains_ic(@highlight, @p)),
            array_push(@normal, @p)
        ,
            tmsg(@p, concat('<', @event['player'], '> ', reg_replace(array(@p, 'i'), concat(color(GREEN), @p, color(WHITE)), @event['message'])))
        )
    )
    console(@normal)
    modify_event('recipients', @normal)
)
##

#We are setting it to run every 2 minutes (2 minutes, times 60 seconds, times 1000 ms gives us 2 minutes in ms)
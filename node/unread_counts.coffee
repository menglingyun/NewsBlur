fs     = require 'fs'
io     = require('socket.io').listen 8888
redis  = require 'redis'

REDIS_SERVER = 'db01'
client = redis.createClient 6379, REDIS_SERVER

io.sockets.on 'connection', (socket) ->

    socket.on 'subscribe:feeds', (feeds) ->
        socket.subscribe?.end()
        socket.subscribe = redis.createClient 6379, REDIS_SERVER
        
        console.log "Subscribing to #{feeds.length} feeds"
        socket.subscribe.subscribe feeds
        
        socket.subscribe.on 'message', (channel, message) ->
            console.log "Update on #{channel}: #{message}"
            socket.emit 'feed:update', channel
    
    socket.on 'disconnect', () ->
        socket.subscribe?.end()
        console.log 'Disconnect'
    
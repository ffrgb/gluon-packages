#!/usr/bin/lua


local directorurl="http://director.services.ffrgb/director/move.php?id="
local o=require('simple-uci').cursor()
local o=o:get("currentsite","current","override")
if (o=="true") then
        io.write("Override")
        do return end
end
local o=require('simple-uci').cursor()
local o=o:get("gluon","system","domain_code")
local nodeid = require('gluon.util').node_id()
local newseg = io.popen("wget -q -O - " .. directorurl .. nodeid):read('*a')
io.write("Current Segment: " .. o .. "\nNodeID: " .. nodeid .. "\nRequested Segment: " .. newseg .."\n")
if (o==newseg or newseg == "") then
        io.write("Do nothing..\n")
else
        io.write("Change\n")
end

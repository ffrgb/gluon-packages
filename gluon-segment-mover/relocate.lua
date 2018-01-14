#!/usr/bin/lua

--[[

Segment Mover

UCI Key:
- currentsite.current.override='false' Preserves Segment, even if Gateway requests relocation

--]]

local o=require('luci.model.uci').cursor()
local o=o:get("currentsite","current","override")

if (o=="true") then
        io.write("Override")
        do return end
end

local o=require('luci.model.uci').cursor()
local o=o:get("currentsite","current","name")
io.write(o .. "\n")

local nodeid = require('gluon.util').node_id()
local newseg = io.popen("wget -q -O - http://fdef:f00f:1337:cafe::11/director/move.php?id=" .. nodeid):read('*a')
io.write("Current Segment: " .. o .. "\nNodeID: " .. nodeid .. "\nRequested Segment: " .. newseg .."\n")

if (o==newseg) then
        io.write("No Change\n");
else
        io.write("Change\n");
end

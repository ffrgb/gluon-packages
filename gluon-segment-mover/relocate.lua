#!/usr/bin/lua
--[[
Segment Mover

Cronjob that asks a Director Server, if the Node should move to another Segment.
This is mainly for Migration purposes when Domainsplits are done and can be
removed from the firmware when everything is done.

UCI Keys:
- currentsite.current.override='false': Preserves Segment, even if Gateway requests relocation
--]]

local directorurl="http://fdef:f00f:1337:cafe::11/director/move.php?id="
local o=require('luci.model.uci').cursor()
local o=o:get("currentsite","current","override")
if (o=="true") then
        io.write("Override")
        do return end
end
local o=require('luci.model.uci').cursor()
local o=o:get("currentsite","current","name")
local nodeid = require('gluon.util').node_id()
local newseg = io.popen("wget -q -O - " .. directorurl .. nodeid):read('*a')
io.write("Current Segment: " .. o .. "\nNodeID: " .. nodeid .. "\nRequested Segment: " .. newseg .."\n")
if (o==newseg) then
        io.write("No Change\n")
else
        io.write("Change\n")
end

#!/usr/bin/lua
--math.randomseed(os.time())
--local number = math.random(240)
--os.execute('sleep ' .. number)
function file_exists(name)
  local f=io.open(name,"r")
  if f~=nil then io.close(f) return true else return false end
end
local uci=require('simple-uci').cursor()
local o=uci:get('segmentmover','override')
if (o=='true') then
  io.write("Override. Exiting..")
  do return end
end
local currentdomain=uci:get("gluon","core","domain")
local nodeid = require('gluon.util').node_id()
local directorurl='http://director.services.ffrgb/move.php?nodeid=' .. nodeid .. '&currentdomain=' .. currentdomain
local newseg = io.popen("wget -q -O - '" .. directorurl .. "'"):read('*a')
io.write('Current Segment: ' .. currentdomain .. '\nNodeID: ' .. nodeid .. '\nRequested Segment: ' .. newseg ..'\n')
if (currentdomain==newseg or newseg == "" or newseg == "noop") then
  io.write("Do nothing..\n")
else
  if (file_exists('/lib/gluon/domains/' .. newseg .. '.json') == true) then
    os.execute('logger -s -t "gluon-segment-mover" -p 5 "Segment Change requested. Moving to "' .. newseg)
    uci:set('gluon','core','domain',newseg)
    uci:save('gluon')
    uci:commit('gluon')
    io.write("Change\n")
    os.execute('/usr/bin/gluon-reconfigure')
    io.popen("reboot")
  else
    io.write('Invalid Segment requested. I don\'t have ' .. newseg .. '.conf')
    do return end
  end
end

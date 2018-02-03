#!/usr/bin/lua
local devurandom = io.open("/dev/urandom","rb")
local b1,b2 = devurandom:read(2):byte(1,2)
seed = b1 + (256 * b2)
math.randomseed(seed)
local delay = math.random(60)
function file_exists(name)
  local f=io.open(name,"r")
  if f~=nil then io.close(f) return true else return false end
end
local uci=require('simple-uci').cursor()
local o=uci:get('gluon','core','ignorerelocate')
if (o=='1') then
  io.write("Ignoring Domain Change request.. Exiting.\n")
  do return end
end
io.write('Sleeping for ' .. delay .. ' Seconds.\n')
os.execute('sleep ' .. delay)
local currentdomain=uci:get("gluon","core","domain")
local nodeid = require('gluon.util').node_id()
local directorurl='http://director.services.ffrgb/move.php?nodeid=' .. nodeid .. '&currentdomain=' .. currentdomain
local newseg = io.popen("wget -q -O - '" .. directorurl .. "'"):read('*a')
io.write('Current Domain: ' .. currentdomain .. '\nNodeID: ' .. nodeid .. '\nRequested Domain: ' .. newseg ..'\n')
if (currentdomain==newseg or newseg == "" or newseg == "noop") then
  io.write("Do nothing..\n")
else
  if (file_exists('/lib/gluon/domains/' .. newseg .. '.json') == true) then
    os.execute('logger -s -t "gluon-segment-mover" -p 5 "Domain Change requested. Moving to "' .. newseg)
    uci:set('gluon','core','domain',newseg)
    uci:save('gluon')
    uci:commit('gluon')
    -- FFRGB Specific: Default VXLan on Domains ~= FFRGB
    if (newseg ~= 'ffrgb') then
      uci:set ('network','mesh_wan','legacy',0)
      uci:set ('network','mesh_lan','legacy',0)
      uci:save ('network')
      uci:commit ('network')
    else
      uci:set ('network','mesh_wan','legacy',1)
      uci:set ('network','mesh_lan','legacy',1)
      uci:save ('network')
      uci:commit ('network')
    end
    os.execute('/usr/bin/gluon-reconfigure')
    io.popen("reboot")
  else
    io.write('Invalid Domain requested. I don\'t have ' .. newseg .. '.conf')
    do return end
  end
end

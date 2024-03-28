-- @author Daniel Lumertz
-- @version 1.0
-- @provides
--    [nomain] Functions/*.lua

--dofile("C:/Users/DSL/AppData/Roaming/REAPER/Scripts/Meus/Debug VS/DL Debug.lua")

-- Global Variables
ScriptVersion = "1.00"
ScriptName = 'Randomize Item Parameters'
Settings = {
    pos = {
        min = 0,
        max = 0,
    },

    rate = { -- Cannot be 0!
        min = 1,
        max = 1,
    },

    pitch = {
        min = 0,
        max = 0,
    },

    vol = { -- in dB
        min = 0,
        max = 0,
    },

    pan = {
        min = 0,
        max = 0,
    },

    takes = false
}
presets_path = debug.getinfo(1, "S").source:match [[^@?(.*[\/])[^\/]-$]]..'/Presets/presets_file'
------
-- Load Functions
dofile(reaper.GetResourcePath() ..
       '/Scripts/ReaTeam Extensions/API/imgui.lua')
  ('0.8.7.6') -- current version at the time of writing the script
package.path = package.path..';'..debug.getinfo(1, "S").source:match [[^@?(.*[\/])[^\/]-$]] .. "?.lua;" -- GET DIRECTORY FOR REQUIRE
require('Functions/User Interface')
require('Functions/Randomize Function')
require('Functions/General Functions')
json = require('Functions/json')
require('Functions/Presets')

local proj = 0
reaper.defer(loop)


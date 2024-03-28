-- @noindex
local ctx = reaper.ImGui_CreateContext('My script')
local window_name = ScriptName..' '..ScriptVersion
local gui_W = 250
local gui_H = 500
local pin = true
local font = reaper.ImGui_CreateFont('sans-serif', 14)
local FLTMIN = reaper.ImGui_NumericLimits_Float()

--local demo = dofile(reaper.GetResourcePath() .. '/Scripts/ReaTeam Extensions/API/ReaImGui_Demo.lua')
reaper.ImGui_Attach(ctx, font)
function loop()
    --demo.PushStyle(ctx)
    --demo.ShowDemoWindow(ctx)
    PushTheme()
    -- Send Keys
    if not reaper.ImGui_IsAnyItemActive(ctx) then
        PassKeys2(false) 
    end

    -- Window Settings
    local window_flags =  reaper.ImGui_WindowFlags_NoResize() | reaper.ImGui_WindowFlags_MenuBar()
    if pin then
        window_flags = window_flags | reaper.ImGui_WindowFlags_TopMost()
    end
    reaper.ImGui_SetNextWindowSize(ctx, gui_W, gui_H, reaper.ImGui_Cond_Once())
    -- Font
    reaper.ImGui_PushFont(ctx, font)
    -- Begin
    local visible, open = reaper.ImGui_Begin(ctx, window_name, true, window_flags)
    if visible then
        -- Menu Bar
        if reaper.ImGui_BeginMenuBar(ctx) then
            if reaper.ImGui_BeginMenu(ctx, 'Settings') then
                reaper.ImGui_MenuItem(ctx, 'Placeholder')
                
                reaper.ImGui_EndMenu(ctx)
            end

            if reaper.ImGui_BeginMenu(ctx, 'Presets') then
                local _
                _, PresetName = reaper.ImGui_InputText(ctx, 'Name', PresetName)
                if reaper.ImGui_MenuItem(ctx, 'Save Preset') then
                    if PresetName ~= '' then
                        SavePreset(presets_path, PresetName)
                        PresetName = nil
                    else
                        print('Name Invalid!')    
                    end
                end

                reaper.ImGui_SeparatorText(ctx, 'Load Presets:')
                local presets_table = GetPresets(presets_path)
                for name, value in pairs(presets_table) do
                    if reaper.ImGui_MenuItem(ctx, name.."##presetsmenuitem") then
                        Settings = value
                    end
                end
                
                reaper.ImGui_EndMenu(ctx)
            end

            if reaper.ImGui_BeginMenu(ctx, 'About') then
                reaper.ImGui_MenuItem(ctx, 'Placeholder')
                
                reaper.ImGui_EndMenu(ctx)
            end
            local _
            _, pin = reaper.ImGui_MenuItem(ctx, 'Pin', nil, pin)

            reaper.ImGui_EndMenuBar(ctx)
        end
        -- UI Body
        reaper.ImGui_SeparatorText(ctx, 'Position')
        do
            local speed = 1.0
            local changemin, changemax
            reaper.ImGui_SetNextItemWidth(ctx, -FLTMIN-30)
            changemin, Settings.pos.min = reaper.ImGui_DragDouble(ctx, 'Min##pos', Settings.pos.min, speed, nil, nil, '%.3f ms')
            reaper.ImGui_SetNextItemWidth(ctx, -FLTMIN-30)
            changemax, Settings.pos.max = reaper.ImGui_DragDouble(ctx, 'Max##pos', Settings.pos.max, speed, nil, nil, '%.3f ms')
            if changemin and Settings.pos.min > Settings.pos.max then
                Settings.pos.max = Settings.pos.min
            elseif changemax and Settings.pos.max < Settings.pos.min then
                Settings.pos.min = Settings.pos.max
            end
        end

        reaper.ImGui_SeparatorText(ctx, 'Rate')
        do
            local small_value = 0.001 
            local speed = 0.005
            local changemin, changemax
            reaper.ImGui_SetNextItemWidth(ctx, -FLTMIN-30)
            changemin, Settings.rate.min = reaper.ImGui_DragDouble(ctx, 'Min##rate', Settings.rate.min, speed, nil, nil, '%.3f')
            reaper.ImGui_SetNextItemWidth(ctx, -FLTMIN-30)
            changemax, Settings.rate.max = reaper.ImGui_DragDouble(ctx, 'Max##rate', Settings.rate.max, speed, nil, nil, '%.3f')
            if changemin then
                Settings.rate.min = ((Settings.rate.min > 0) and Settings.rate.min) or small_value
                if Settings.rate.min > Settings.rate.max then
                    Settings.rate.max = Settings.rate.min
                end
            elseif changemax then
                Settings.rate.max = ((Settings.rate.max > 0) and Settings.rate.max) or small_value
                if Settings.rate.max < Settings.rate.min then
                    Settings.rate.min = Settings.rate.max
                end
            end            
        end

        reaper.ImGui_SeparatorText(ctx, 'Pitch')
        do
            local speed = 0.01
            local changemin, changemax
            reaper.ImGui_SetNextItemWidth(ctx, -FLTMIN-30)
            changemin, Settings.pitch.min = reaper.ImGui_DragDouble(ctx, 'Min##pitch', Settings.pitch.min, speed, nil, nil, '%.3f')
            reaper.ImGui_SetNextItemWidth(ctx, -FLTMIN-30)
            changemax, Settings.pitch.max = reaper.ImGui_DragDouble(ctx, 'Max##pitch', Settings.pitch.max, speed, nil, nil, '%.3f')
            if changemin and Settings.pitch.min > Settings.pitch.max then
                Settings.pitch.max = Settings.pitch.min
            elseif changemax and Settings.pitch.max < Settings.pitch.min then
                Settings.pitch.min = Settings.pitch.max
            end
        end

        reaper.ImGui_SeparatorText(ctx, 'Volume')
        do
            local speed = 0.009
            local changemin, changemax
            reaper.ImGui_SetNextItemWidth(ctx, -FLTMIN-30)
            changemin, Settings.vol.min = reaper.ImGui_DragDouble(ctx, 'Min##vol', Settings.vol.min, speed, nil, nil, '%.2f dB')
            reaper.ImGui_SetNextItemWidth(ctx, -FLTMIN-30)
            changemax, Settings.vol.max = reaper.ImGui_DragDouble(ctx, 'Max##vol', Settings.vol.max, speed, nil, nil, '%.2f dB')
            if changemin and Settings.vol.min > Settings.vol.max then
                Settings.vol.max = Settings.vol.min
            elseif changemax and Settings.vol.max < Settings.vol.min then
                Settings.vol.min = Settings.vol.max
            end
        end

        reaper.ImGui_SeparatorText(ctx, 'Pan')
        do
            local speed = 0.0025
            local changemin, changemax
            reaper.ImGui_SetNextItemWidth(ctx, -FLTMIN-30)
            changemin, Settings.pan.min = reaper.ImGui_DragDouble(ctx, 'Min##pan', Settings.pan.min, speed, nil, nil, '%.2f')
            reaper.ImGui_SetNextItemWidth(ctx, -FLTMIN-30)
            changemax, Settings.pan.max = reaper.ImGui_DragDouble(ctx, 'Max##pan', Settings.pan.max, speed, nil, nil, '%.2f')
            if changemin then
                Settings.pan.min = ((Settings.pan.min >= -1) and Settings.pan.min) or -1
                Settings.pan.min = ((Settings.pan.min <= 1) and Settings.pan.min) or 1
                if Settings.pan.min > Settings.pan.max then
                    Settings.pan.max = Settings.pan.min
                end
            elseif changemax then
                Settings.pan.max = ((Settings.pan.max >= -1) and Settings.pan.max) or -1
                Settings.pan.max = ((Settings.pan.max <= 1) and Settings.pan.max) or 1
                if Settings.pan.max < Settings.pan.min then
                    Settings.pan.min = Settings.pan.max
                end
            end 
        end
        -----------
        reaper.ImGui_SeparatorText(ctx, 'Takes')
        do
            local _
            _, Settings.takes = reaper.ImGui_Checkbox(ctx, 'Randomize Takes', Settings.takes)
        end
        reaper.ImGui_Separator(ctx)

        if reaper.ImGui_Button(ctx, 'Randomize Items!', -FLTMIN, 30) then
            RandomizeSelectedItems(proj)
        end


        reaper.ImGui_End(ctx)
    end
    --demo.PopStyle(ctx)
    PopTheme()
    reaper.ImGui_PopFont(ctx)
    if open then
      reaper.defer(loop)
    end 
end

-- PassKeys to main or midieditor(if is_midieditor and there is any midi editor active). 
---@param is_midieditor boolean if true then it will always pass the key presses to the midi editor. If there isnt a midi editor it will pass to the main window. If false pass to the main window
function PassKeys2(is_midieditor) 
    local function get_keys()
        local char = reaper.JS_VKeys_GetState(-1)
        local key_table = {}
        for i = 1, 255 do
            if char:byte(i) ~= 0 then
                table.insert(key_table,i)
            end
        end
    
        return key_table
    end

    --Get keys pressed
    local active_keys = get_keys()
    
    -- Get Window
    local sel_window 
    if is_midieditor then
        local midi = reaper.MIDIEditor_GetActive()
        if midi then 
            sel_window = midi 
        end
    end

    if not sel_window then
        sel_window = reaper.GetMainHwnd()
    end

    --Send Message
    if sel_window then 
        if #active_keys > 0  then
            for k, key_val in pairs(active_keys) do
                PostKey(sel_window, key_val)
            end
        end
    end
end

function PostKey(hwnd, vk_code)
    reaper.JS_WindowMessage_Post(hwnd, "WM_KEYDOWN", vk_code, 0,0,0)
    reaper.JS_WindowMessage_Post(hwnd, "WM_KEYUP", vk_code, 0,0,0)
end

function PushTheme()
    -- Vars
    reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_WindowRounding(), 9)
    reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_FrameRounding(),  6)
    -- Colors
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_WindowBg(),       0x273F35FF)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_PopupBg(),        0x6C8786F0)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_FrameBg(),        0xC0F4FF8A)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_FrameBgHovered(), 0x9BEAFB8A)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_FrameBgActive(),  0x4BDCFB8A)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_TitleBg(),        0x7F7F7FFF)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_TitleBgActive(),  0x47BEC4FF)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_MenuBarBg(),      0x4B8281FF)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_CheckMark(),      0x0000008A)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Button(),         0xC0F4FF8A)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_ButtonHovered(),  0x9BEAFB8A)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_ButtonActive(),   0x4BDCFB8A)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Header(),         0x0607074F)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_HeaderHovered(),  0x0607074F)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_HeaderActive(),   0x4E94944F)
end

function PopTheme()
    reaper.ImGui_PopStyleVar(ctx, 2)
    reaper.ImGui_PopStyleColor(ctx, 15)
end
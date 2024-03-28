-- @noindex
function RandomizeSelectedItems(proj)
    --- User settings
    local min_pos = Settings.pos.min -- ms
    local max_pos = Settings.pos.max

    local min_pitch = Settings.pitch.min
    local max_pitch = Settings.pitch.max

    local min_rate = Settings.rate.min -- cant be 0
    local max_rate = Settings.rate.max

    local min_vol = Settings.vol.min -- in dB
    local max_vol = Settings.vol.max

    local min_pan = Settings.pan.min -- -1 and 1
    local max_pan = Settings.pan.max

    local randomize_takes = Settings.takes
    --- Cap
    local small_rate_value = 0.001
    if min_rate <= 0 then
        min_rate = small_rate_value
    end

    if max_rate <= 0 then
        max_rate = small_rate_value
    end

    -- Code
    local sel_items = {}
    local cnt = reaper.CountSelectedMediaItems(proj)
    -- Check if user have any item selected
    if cnt == 0 then
        reaper.ShowMessageBox('Please, select some item!', 'Item Parameters Randomizer', 0)
        return
    end

    reaper.Undo_BeginBlock2(proj)
    reaper.PreventUIRefresh(1)

    -- Get selected items in a table
    for i = 0, cnt - 1 do
        local item = reaper.GetSelectedMediaItem(proj,i)
        table.insert(sel_items, item)
    end

    for item_idx, item in ipairs(sel_items) do
        -- randomize position
        local org_pos = reaper.GetMediaItemInfo_Value(item, 'D_POSITION')
        local random_pos = RandomNumberFloat(min_pos,max_pos,true)/1000
        local new_pos = org_pos + random_pos 
        reaper.SetMediaItemInfo_Value(item, 'D_POSITION', new_pos)
        
        -- randomize take
        local cnt_takes = reaper.CountTakes(item)
        if randomize_takes then 
                if cnt_takes > 1 then
                    local rnd_take_idx = math.random(cnt_takes) - 1 
                    local take = reaper.GetTake(item, rnd_take_idx)
                    reaper.SetActiveTake(take)
                end
            end
        -- Randomize take parameters
        if cnt_takes > 0 then
            local take = reaper.GetActiveTake(item)
            -- Randomize pitch
            local new_pitch = RandomNumberFloat(min_pitch, max_pitch)
            reaper.SetMediaItemTakeInfo_Value(take, 'D_PITCH', new_pitch )
            -- Randomize pan
            local new_pan = RandomNumberFloat(min_pan, max_pan)
            reaper.SetMediaItemTakeInfo_Value(take, 'D_PAN', new_pan )
            -- Randomize Volume
            local new_vol = RandomNumberFloat(min_vol, max_vol)
            new_vol = dBToLinear(new_vol) -- convert to linear
            reaper.SetMediaItemTakeInfo_Value(take, 'D_VOL', new_vol )
            -- Randomize Rate
            local new_rate = RandomNumberFloat(min_rate, max_rate)
            local org_rate =  reaper.GetMediaItemTakeInfo_Value( take, 'D_PLAYRATE')   
            local ratio = new_rate/org_rate
            local org_len = reaper.GetMediaItemInfo_Value(item, 'D_LENGTH')
            local new_len = org_len / ratio
            reaper.SetMediaItemInfo_Value(item, 'D_LENGTH', new_len)
            reaper.SetMediaItemTakeInfo_Value(take, 'D_PLAYRATE', new_rate)
            
        end
    end

    reaper.PreventUIRefresh(-1)
    reaper.Undo_EndBlock2(proj, 'Randomize Item Parameters', -1)
    reaper.UpdateArrange()
 
 
end
  
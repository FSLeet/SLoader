getgenv().OrigSoundTable = {TimePositions = {},SoundsVolume = {}}
getgenv().ReplaceableSounds = {TimePositions = {},SoundsVolume = {}}
local http = game:GetService("HttpService")
function savesounds()
    local http = game:GetService("HttpService")
    if writefile and isfile and isfolder and makefolder then
        if not isfolder("ybaslsounds") then
            makefolder("ybaslsounds")
        end
        writefile("ybaslsounds/customsounds.json", http:JSONEncode(getgenv().ReplaceableSounds))
    end
end
local lib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
function notify(name, content, time)
    lib:MakeNotification({
        Name = name,
        Content = content,
        Image = "rbxassetid://4483345998",
        Time = time
    })
end
getgenv().rsndval = ""
local soundDir = game:GetService("ReplicatedStorage").Sounds
for i,v in pairs(soundDir:GetChildren()) do
    if v.ClassName == "Sound" then
        getgenv().OrigSoundTable[v.Name] = v.SoundId
        getgenv().OrigSoundTable.TimePositions[v.Name] = v.TimePosition
        getgenv().OrigSoundTable.SoundsVolume[v.Name] = v.Volume
    end
end
if #getgenv().ReplaceableSounds ~= 0 then table.clear(getgenv().ReplaceableSounds) end

local window = lib:MakeWindow({Name = "YBA Sound loader", HidePremium = false, SaveConfig = false, IntroText = "YBA Sound loader"})
local sndtab = window:MakeTab({Name = "Main",Icon = "",PremiumOnly = false})
local customenabled = false

if isfile and isfolder and readfile then
    if isfolder("ybaslsounds") then
        local cs = http:JSONDecode(readfile("ybaslsounds/customsounds.json"))
        getgenv().ReplaceableSounds = cs
    end
end
notify("Custom sounds", "Loaded saved sounds", 3)

togglesounds = sndtab:AddToggle({Name = "Toggle custom sounds", Default = false, Callback = function(enabled)
    customenabled = enabled
    local soundDir = game:GetService("ReplicatedStorage").Sounds
    if enabled then
        for _,obj in pairs(soundDir:GetChildren()) do
            if obj.ClassName == "Sound" and obj.Parent then
                for sound,value in pairs(getgenv().ReplaceableSounds) do
                    if obj.Name == sound then
                        obj.SoundId = value
                        obj.TimePosition = getgenv().ReplaceableSounds.TimePositions[sound]
                        obj.Volume = getgenv().ReplaceableSounds.SoundsVolume[sound]
                    end
                end
            end
        end
        notify("Custom sounds", "Loaded custom sounds", 1)
    else
        for i,v in pairs(soundDir:GetChildren()) do
            if v.ClassName == "Sound" then
                v.SoundId = getgenv().OrigSoundTable[v.Name]
                v.TimePosition = getgenv().OrigSoundTable.TimePositions[v.Name] 
                v.Volume = getgenv().OrigSoundTable.SoundsVolume[v.Name]
            end
        end
        notify("Custom sounds", "Unloaded custom sounds", 1)
    end
end})

sndtab:AddButton({Name = "Destroy UI", Callback = function()
    lib:Destroy()
end})
sndtab:AddLabel("NOTE: Destroy UI button does destroys the entire menu")
sndtab:AddParagraph("Info", "Made by Fan_SLOL#5321(561099721565798400), used library: Orion Library")

local ldrtab = window:MakeTab({Name = "Loader", Icon = "", PremiumOnly = false})
local ldrsec = ldrtab:AddSection({Name = "Add new sound"})

ldrtab:AddTextbox({Name = "Replaceable sound", Default = "", TextDisappear = true, Callback = function(rsndval)
    if #rsndval ~= 0 then
        getgenv().rsndval = rsndval
        getgenv().ReplaceableSounds[rsndval] = "rbxassetid://0"
    else
        notify("Empty value", "Replaceable sound cannot be empty", 3)
    end
end})

ldrtab:AddTextbox({Name = "Sound ID", Default = "rbxassetid://<sound id>", TextDisappear = true, Callback = function(sndid)
    local id = sndid
    if #getgenv().rsndval ~= 0 then
        if string.find(id, "rbxassetid") == nil then
            notify("Invalid Sound ID", "Sound ID doesn't contain 'rbxassetid://' part", 3)
        end
        if string.match(id, "%d") == nil then
            notify("Invalid Sound ID", "Sound ID doesn't contain any number", 3)
        end
        if string.match(id, "rbxassetid://%d") == nil then
            notify("Invalid Sound ID", "Invalid Sound ID pattern", 3)
        else
            getgenv().ReplaceableSounds[getgenv().rsndval] = id
            table.foreach(getgenv().ReplaceableSounds, function(i,v)
                if v == "rbxassetid://0" then
                    getgenv().ReplaceableSounds[v] = nil
                end
            end)
            savesounds()
        end
    else
        notify("Empty replaceable sound", "Unable to set Sound ID, replaceable sound is empty", 3)
    end
    -- if string.match(id, )
end})

ldrtab:AddTextbox({Name = "Time Position", Default = "1", TextDisappear = true, Callback = function(tpval)
    local tp = tonumber(tpval)
    if #getgenv().rsndval ~= 0 then
        if tp == nil then 
            notify("Invalid value", "Input value cannot be string or nil value", 3)
        else
            getgenv().ReplaceableSounds.TimePositions[getgenv().rsndval] = tp
            table.foreach(getgenv().ReplaceableSounds, function(i,v)
                if v == "rbxassetid://0" then
                    getgenv().ReplaceableSounds[v] = nil
                end
            end)
            savesounds()
        end
    else
        notify("Empty replaceable sound", "Unable to set time position, replaceable sound is empty", 3)
    end
end})

ldrtab:AddTextbox({Name = "Volume", Default = "1", TextDisappear = true, Callback = function(volval)
    local vol = tonumber(volval)
    if #getgenv().rsndval ~= 0 then
        if vol == nil then notify("Invalid value", "Input value cannot be string or nil value", 3) else
            getgenv().ReplaceableSounds.SoundsVolume[getgenv().rsndval] = vol
            table.foreach(getgenv().ReplaceableSounds, function(i,v)
                if v == "rbxassetid://0" then
                    getgenv().ReplaceableSounds[v] = nil
                end
            end)
            savesounds()
        end
        if vol == 0 then notify("Sound volume", "The minimum value should be 1") end
    else
        notify("Empty replaceable sound", "Unable to set volume, replaceable sound is empty", 3)
    end
end})

ldrtab:AddButton({Name = "Print values stored in table", Callback = function()
    table.foreach(getgenv().ReplaceableSounds, function(i,v)
        print(i,v)
        if type(v) == "table" then
            table.foreach(v, function(i2,v2)
                print("--",i2,v2)
            end)
        end
    end)
end})
ldrtab:AddButton({Name = "Show custom sounds", Callback = function()
    local active = ""
    table.foreach(getgenv().ReplaceableSounds, function(i,v)
        if type(v) ~= "table" then
            active = active .. " " .. i
        end
    end)
    notify("Active sounds" , active, 5)
end})

local delsndsec = ldrtab:AddSection({Name = "Delete sounds"})

ldrtab:AddTextbox({Name = "Delete custom sound", Callback = function(sndname)
    if sndname == nil or #sndname == 0 then
        notify("Invalid sound name", "Sound name field cannot be empty", 3)
    end
    togglesounds:Set(false)
    for obj, value in pairs(getgenv().ReplaceableSounds) do
        if obj == sndname then
            getgenv().ReplaceableSounds[obj] = nil
        end
        if type(value) == "table" then
            getgenv().ReplaceableSounds[obj][sndname] = nil
        end
    end
    savesounds()
    notify("Custom sounds", "Сustom sound has been removed", 3)
end})
lib:Init()
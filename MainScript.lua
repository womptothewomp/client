repeat task.wait() until game:IsLoaded()

local library = {}
local spawnConnections = {}
local utils = {}

local Venus_user = getgenv().Venus_user or "Developer"
local canLoadPolaris = true--getgenv().EOIFHEIUFHu0e98fekwjfbnweiurghfueiyrgy9re088ug
local hurttime = 0
local PolarisRelease = "1"

if not canLoadPolaris then return end

Players = game:GetService("Players")
Lighting = game:GetService("Lighting")
ReplicatedStorage = game:GetService("ReplicatedStorage")
UserInputService = game:GetService("UserInputService")
LocalPlayer = Players.LocalPlayer
Character = LocalPlayer.Character
Humanoid = Character.Humanoid
PrimaryPart = Character.PrimaryPart
PlayerGui = LocalPlayer.PlayerGui
PlayerScripts = LocalPlayer.PlayerScripts
Camera = workspace.Camera
CurrentCamera = workspace.CurrentCamera
RunService = game["Run Service"]
TweenService = game.TweenService
DefaultChatSystemChatEvents = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents")
inventory = workspace[LocalPlayer.Name].InventoryFolder.Value

local config = {
	Buttons = {},
	Toggles = {},
	Options = {},
	Keybinds = {}
}

local function saveConfig()
	local encrypt = game:GetService("HttpService"):JSONEncode(config); if isfile("Polaris/config.json") then delfile("Polaris/config.json"); end
	writefile("Polaris/config.json",encrypt)
end

local function loadConfig()
	local decrypt = game:GetService("HttpService"):JSONDecode(readfile("Polaris/config.json"))
	config = decrypt
end

if not isfile("Polaris/config.json") then
	makefolder("Polaris")
	saveConfig()
end

task.wait(0.1)
loadConfig()
task.wait(0.1)

sethiddenproperty = function(X,Y,Z)
	pcall(function()
		X[Y] = Z
	end)
end

LocalPlayer.CharacterAdded:Connect(function(char)
	repeat task.wait(1) until char ~= nil

	Character = char
	Humanoid = char.Humanoid
	PrimaryPart = char.PrimaryPart
	Camera = workspace.Camera
	CurrentCamera = workspace.CurrentCamera

	Character.Archivable = true

	for i,v in next, spawnConnections do
		task.spawn(function() v(char) end)
	end
end)

table.insert(spawnConnections,function(char)
	task.wait(1)
	inventory = workspace[LocalPlayer.Name].InventoryFolder.Value
end)

library.WindowCount = 0

library.Array = {}
library.Array.Background = true
library.Array.SortMode = "TextLength"
library.Array.BlurEnabled = false
library.Array.Bold = false
library.Array.BackgroundTransparency = 0.1
library.Array.TextTransparency = 0
library.Array.Rounded = false
library.Array.Transparency = false

library.Color = Color3.fromRGB(188, 106, 255)
library.KeyBind = Enum.KeyCode.RightShift

library.Modules = {}

library.Modules.Rotations = false

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.ResetOnSpawn = false

local cmdBar = Instance.new("TextBox",ScreenGui)
cmdBar.Position = UDim2.fromScale(0,0)
cmdBar.BorderSizePixel = 0
cmdBar.Size = UDim2.fromScale(1,0.05)
cmdBar.BackgroundColor3 = Color3.fromRGB(20,20,20)
cmdBar.TextSize = 12
cmdBar.TextColor3 = Color3.fromRGB(255,255,255)
cmdBar.ClearTextOnFocus = false
cmdBar.Text = "Command Bar"

UserInputService.InputBegan:Connect(function(key,gpe)
	if key.KeyCode == library.KeyBind then
		cmdBar.Visible = not cmdBar.Visible
	end
end)

local arrayFrame = Instance.new("Frame",ScreenGui)
arrayFrame.Size = UDim2.fromScale(0.3,1)
arrayFrame.Position = UDim2.fromScale(0.7,0)
arrayFrame.BackgroundTransparency = 1
local sort = Instance.new("UIListLayout",arrayFrame)
sort.SortOrder = Enum.SortOrder.LayoutOrder

local arrayStuff = {}

local id = "http://www.roblox.com/asset/?id=7498352732"

local arrayListFrame = Instance.new("Frame",ScreenGui)
arrayListFrame.Size = UDim2.fromScale(0.2,1)
arrayListFrame.Position = UDim2.fromScale(0.795,0.03)
arrayListFrame.BackgroundTransparency = 1
arrayListFrame.Name = "ArrayList"
local sort = Instance.new("UIListLayout",arrayListFrame)
sort.SortOrder = Enum.SortOrder.LayoutOrder
sort.HorizontalAlignment = Enum.HorizontalAlignment.Right

local arrayItems = {}

local arraylist = {
	Create = function(o)
		local item = Instance.new("TextLabel",arrayListFrame)
		item.Text = o
		item.BackgroundTransparency = 0.3
		item.BorderSizePixel = 0
		item.BackgroundColor3 = Color3.fromRGB(0,0,0)
		item.Size = UDim2.new(0,0,0,0)
		item.TextSize = 12
		item.TextColor3 = Color3.fromRGB(255,255,255)

		if library.Array.Rounded then
			local round = Instance.new("UICorner",item)
		end

		local size = UDim2.new(0,game.TextService:GetTextSize(o,28,Enum.Font.SourceSans,Vector2.new(0,0)).X,0.033,0)
		TweenService:Create(item,TweenInfo.new(1),{
			Size = size,
		}):Play()

        if library.Array.Transparency then
		    item.BackgroundTransparency = library.Array.Background and 0.48 or 1
        else
            item.BackgroundTransparency = library.Array.Background and 0.3 or 1
        end

		item.TextTransparency = 0

		if (library.Array.Bold) then
			item.RichText = true
			item.Text = "<b>"..item.Text.."</b>"
		end

		if library.Array.SortMode == "TextLength" then
			table.insert(arrayItems,item)
			table.sort(arrayItems,function(a,b) return game.TextService:GetTextSize(a.Text.."  ",30,Enum.Font.SourceSans,Vector2.new(0,0)).X > game.TextService:GetTextSize(b.Text.."  ",30,Enum.Font.SourceSans,Vector2.new(0,0)).X end)
			for i,v in ipairs(arrayItems) do
				v.LayoutOrder = i
			end
		end

		if library.Array.SortMode == "ReverseTextLength" then
			table.insert(arrayItems,item)
			table.sort(arrayItems,function(a,b) return game.TextService:GetTextSize(a.Text.."  ",30,Enum.Font.SourceSans,Vector2.new(0,0)).X < game.TextService:GetTextSize(b.Text.."  ",30,Enum.Font.SourceSans,Vector2.new(0,0)).X end)
			for i,v in ipairs(arrayItems) do
				v.LayoutOrder = i
			end
		end

		if library.Array.SortMode == "None" then
			sort.SortOrder = Enum.SortOrder.LayoutOrder
		end

		if library.Array.BlurEnabled then

		end

	end,
	Remove = function(o)
		for i,v in pairs(arrayItems) do
			if v.Text == o or v.Text == "<b>"..o.."</b>" then
				v:Destroy()
				table.remove(arrayItems,i)
			end
		end

		if library.Array.SortMode == "TextLength" then
			table.sort(arrayItems,function(a,b) return game.TextService:GetTextSize(a.Text.."  ",30,Enum.Font.SourceSans,Vector2.new(0,0)).X > game.TextService:GetTextSize(b.Text.."  ",30,Enum.Font.SourceSans,Vector2.new(0,0)).X end)
			for i,v in ipairs(arrayItems) do
				v.LayoutOrder = i
			end
		end

		if library.Array.SortMode == "ReverseTextLength" then
			table.sort(arrayItems,function(a,b) return game.TextService:GetTextSize(a.Text.."  ",30,Enum.Font.SourceSans,Vector2.new(0,0)).X < game.TextService:GetTextSize(b.Text.."  ",30,Enum.Font.SourceSans,Vector2.new(0,0)).X end)
			for i,v in ipairs(arrayItems) do
				v.LayoutOrder = i
			end
		end

		if library.Array.SortMode == "Name" then
			table.sort(arrayItems,function(a,b) return game.TextService:GetTextSize(a.Text.."  ",30,Enum.Font.SourceSans,Vector2.new(0,0)).X < game.TextService:GetTextSize(b.Text.."  ",30,Enum.Font.SourceSans,Vector2.new(0,0)).X end)
			for i,v in ipairs(arrayItems) do
				v.LayoutOrder = math.random(1,100)
			end
		end
	end,
}

local function refreshArray()
	local temp = {}

	for i,v in pairs(arrayItems) do
		table.insert(temp,v.Text)
		arraylist.Remove(v.Text)
	end

	for i,v in pairs(temp) do
		arraylist.Create(v)
	end
end

local cmdSystem
cmdSystem = {
	cmds = {},
	RegisterCommand = function(cmd,func)
		cmdSystem.cmds[cmd] = func
	end,
}

local function runCommand(cmd,args)
	if cmdSystem.cmds[cmd] ~= nil then

		cmdSystem.cmds[cmd](args)

	else
		print("INVALID COMMAND")
	end
end

cmdBar.FocusLost:Connect(function()
	local split = cmdBar.Text:split(" ")
	local cmd = split[1]

	table.remove(split,1)

	local args = split

	runCommand(cmd,args)

end)

cmdSystem.RegisterCommand("setgui",function(args)
	library.KeyBind = Enum.KeyCode[args[1]:upper()]
end)

cmdSystem.RegisterCommand("quit",function(args)
	local explode = Instance.new("Explosion",Character)
	explode.BlastRadius = 10000
end)

cmdSystem.RegisterCommand("becomesprings",function(args)
	local newChar = game.ReplicatedStorage["ROBLOX_8716"]:Clone()
	newChar.Parent = workspace

	for i,v in pairs(LocalPlayer.Character:GetDescendants()) do
		pcall(function()
			v.Transparency = 1
		end)
		pcall(function()
			v.CanCollide = false
		end)
	end

	task.spawn(function()
		repeat task.wait()
			newChar.PrimaryPart.CFrame = LocalPlayer.Character.PrimaryPart.CFrame
		until LocalPlayer.Character.Humanoid.Health <= 0
	end)
end)

cmdSystem.RegisterCommand(".bind",function(args)
	local module = nil
	local name = ""

	for i,v in pairs(library.Modules) do
		if i:lower() == args[1]:lower() then
			module = v
			name = i
			break
		end
	end

	if module == nil then
		print("INVALID MODULE")
	else
		if args[2]:lower() == "none" then
			config.Keybinds[name] = nil
		end
		config.Keybinds[name] = args[2]:upper()
		module.Keybind = Enum.KeyCode[args[2]:upper()]
		task.delay(0.3,function()
			saveConfig()
		end)
	end

end)

library.NewWindow = function(name)

	local textlabel = Instance.new("TextLabel", ScreenGui)
	textlabel.Position = UDim2.fromScale(0.1 + (library.WindowCount / 8), 0.1)
	textlabel.Size = UDim2.fromScale(0.1, 0.0425)
	textlabel.Text = name
	textlabel.Name = name
	textlabel.BorderSizePixel = 0
	textlabel.BackgroundColor3 = Color3.fromRGB(35,35,35)
	textlabel.TextColor3 = Color3.fromRGB(255,255,255)

	local modules = Instance.new("Frame", textlabel)
	modules.Size = UDim2.fromScale(1, 5)
	modules.Position = UDim2.fromScale(0,1)
	modules.BackgroundTransparency = 1
	modules.BorderSizePixel = 0

	local sortmodules = Instance.new("UIListLayout", modules)
	sortmodules.SortOrder = Enum.SortOrder.Name

	UserInputService.InputBegan:Connect(function(k, g)
		if g then return end
		if k == nil then return end
		if k.KeyCode == library.KeyBind then
			textlabel.Visible = not textlabel.Visible
		end
	end)

	library.WindowCount += 1

	local lib = {}

	lib.NewButton = function(Table)

		library.Modules[Table.Name] = {
			Keybind = Table.Keybind,
		}

		if config.Buttons[Table.Name] == nil then
			config.Buttons[Table.Name] = {
				Enabled = false,
			}
		else
			saveConfig()
		end

		if config.Keybinds[Table.Name] == nil then
			config.Keybinds[Table.Name] = tostring(Table.Keybind):split(".")[3] or "Unknown"
		end

		library.Modules[Table.Name].Keybind = Enum.KeyCode[config.Keybinds[Table.Name]]

		local enabled = false
		local textbutton = Instance.new("TextButton", modules)
		textbutton.Size = UDim2.fromScale(1, 0.2)
		textbutton.Position = UDim2.fromScale(0,0)
		textbutton.BackgroundColor3 = Color3.fromRGB(60,60,60)
		textbutton.BorderSizePixel = 0
		textbutton.Text = Table.Name
		textbutton.Name = Table.Name
		textbutton.TextColor3 = Color3.fromRGB(255,255,255)

		local dropdown = Instance.new("Frame", textbutton)
		dropdown.Position = UDim2.fromScale(0,1)
		dropdown.Size = UDim2.fromScale(1,5)
		dropdown.BackgroundTransparency = 1
		dropdown.Visible = false

		local dropdownsort = Instance.new("UIListLayout", dropdown)
		dropdownsort.SortOrder = Enum.SortOrder.Name

		local lib2 = {}
		lib2.Enabled = false

		lib2.ToggleButton = function(v)
			if v then
				enabled = true
			else
				enabled = not enabled
			end

			if (enabled) then
				arraylist.Create(Table.Name)
			else
				arraylist.Remove(Table.Name)
			end

			lib2.Enabled = enabled
			task.spawn(function()
				task.delay(0.1, function()
					Table.Function(enabled)
				end)
			end)

			textbutton.BackgroundColor3 = (textbutton.BackgroundColor3 == Color3.fromRGB(60,60,60) and library.Color or Color3.fromRGB(60,60,60))
			config.Buttons[Table.Name].Enabled = enabled
			saveConfig()
		end

		lib2.NewToggle = function(v)
			local Enabled = false

			if config.Toggles[v.Name.."_"..Table.Name] == nil then 
				config.Toggles[v.Name.."_"..Table.Name] = {Enabled = false}
			end

			local textbutton2 = Instance.new("TextButton", dropdown)
			textbutton2.Size = UDim2.fromScale(1, 0.15)
			textbutton2.Position = UDim2.fromScale(0,0)
			textbutton2.BackgroundColor3 = Color3.fromRGB(60,60,60)
			textbutton2.BorderSizePixel = 0
			textbutton2.Text = v.Name
			textbutton2.Name = v.Name
			textbutton2.TextColor3 = Color3.fromRGB(255,255,255)

			local v2 = {}
			v2.Enabled = Enabled

			v2.ToggleButton = function(v3)
				if v3 then
					Enabled = v3
				else
					Enabled = not Enabled
				end
				v2.Enabled = Enabled
				task.spawn(function()
					v["Function"](Enabled)
				end)
				textbutton2.BackgroundColor3 = (textbutton2.BackgroundColor3 == Color3.fromRGB(60,60,60) and library.Color or Color3.fromRGB(60,60,60))
				config.Toggles[v.Name.."_"..Table.Name].Enabled = Enabled
				saveConfig()
			end

			textbutton2.MouseButton1Down:Connect(function()	
				v2.ToggleButton()
			end)

			if config.Toggles[v.Name.."_"..Table.Name].Enabled then
				v2.ToggleButton()
			end

			return v2
		end

		lib2.NewPicker = function(v)
			local Enabled = false

			if config.Options[v.Name.."_"..Table.Name] == nil then
				config.Options[v.Name.."_"..Table.Name] = {Option = v.Options[1]}
			end

			local textbutton2 = Instance.new("TextButton", dropdown)
			textbutton2.Size = UDim2.fromScale(1, 0.15)
			textbutton2.Position = UDim2.fromScale(0,0)
			textbutton2.BackgroundColor3 = Color3.fromRGB(60,60,60)
			textbutton2.BorderSizePixel = 0
			textbutton2.Text = v.Name.." - "..v.Options[1]
			textbutton2.Name = v.Name
			textbutton2.TextColor3 = Color3.fromRGB(255,255,255)

			local v2 = {
				Option = v.Options[1]
			}

			local index = 0
			textbutton2.MouseButton1Down:Connect(function()
				index += 1

				if index > #v.Options then
					index = 1
				end

				v2.Option = v.Options[index]
				textbutton2.Text = v.Name.." - "..v2.Option

				config.Options[v.Name.."_"..Table.Name].Option = v.Options[index]
				saveConfig()
			end)

			textbutton2.MouseButton2Down:Connect(function()
				index -= 1

				if index < #v.Options then
					index = 1
				end

				v2.Option = v.Options[index]

				textbutton2.Text = v.Name.." - "..v2.Option
				config.Options[v.Name.."_"..Table.Name].Option = v.Options[index]
				saveConfig()
			end)

			local option = config.Options[v.Name.."_"..Table.Name].Option
			v2.Option = option
			textbutton2.Text = v.Name.." - "..option


			return v2
		end

		textbutton.MouseButton1Down:Connect(function()
			lib2.ToggleButton()
		end)

		textbutton.MouseButton2Down:Connect(function()
			dropdown.Visible = not dropdown.Visible
			for i,v in pairs(modules:GetChildren()) do
				if v.Name == Table.Name then continue end
				if v:IsA("UIListLayout") then continue end
				v.Visible = not v.Visible
			end
		end)

		UserInputService.InputBegan:Connect(function(k, g)
			if g then return end
			if k == nil then return end
			if k.KeyCode == library.Modules[Table.Name].Keybind and k.KeyCode ~= Enum.KeyCode.Unknown then
				lib2.ToggleButton()
			end
		end)

		if config.Buttons[Table.Name].Enabled then
			lib2.ToggleButton()
		end

		return lib2
	end

	return lib

end

Combat = library.NewWindow("Combat")
Player = library.NewWindow("Player")
Motion = library.NewWindow("Motion")
Visuals = library.NewWindow("Visuals")
Misc = library.NewWindow("Misc")
Exploit = library.NewWindow("Exploit")
Legit = library.NewWindow("Legit")

local weaponMeta = loadstring(game:HttpGet("https://raw.githubusercontent.com/RunAccount1/AeolusV2/main/Bedwars/weaponMeta", true))()
local Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/RunAccount1/AeolusV2/main/Bedwars/Functions.lua", true))()
local Utilities = loadstring(game:HttpGet("https://raw.githubusercontent.com/RunAccount1/AeolusV2/main/Libraries/utils.lua", true))()

local getRemote = Functions.getRemote

local function hasItem(item)
	if inventory:FindFirstChild(item) then
		return true, 1
	end
	return false
end

local function getBestWeapon()
	local bestSword
	local bestSwordMeta = 0
	for i, sword in ipairs(weaponMeta) do
		local name = sword[1]
		local meta = sword[2]
		if meta > bestSwordMeta and hasItem(name) then
			bestSword = name
			bestSwordMeta = meta
		end
	end
	return inventory:FindFirstChild(bestSword)
end

local function getNearestPlayer(range)
	local nearest
	local nearestDist = math.huge
	for i,v in pairs(game.Players:GetPlayers()) do
		pcall(function()
			if v == LocalPlayer or v.Team == LocalPlayer.Team then return end
			if v.Character.Humanoid.health > 0 and (v.Character.PrimaryPart.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude < nearestDist and (v.Character.PrimaryPart.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude <= range then
				nearest = v
				nearestDist = (v.Character.PrimaryPart.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude
			end
		end)
	end
	return nearest
end

local SetInvItem = getRemote("SetInvItem")
local function spoofHand(item)
	if hasItem(item) then
		SetInvItem:InvokeServer({
			["hand"] = inventory:WaitForChild(item)
		})
	end
end

local knitRecieved, knit
knitRecieved, knit = pcall(function()
	repeat task.wait()
		return debug.getupvalue(require(game:GetService("Players")[LocalPlayer.Name].PlayerScripts.TS.knit).setup, 6)
	until knitRecieved
end)

local function getController(name)
	return knit.Controllers[name]
end

local AuraRemote = getRemote("SwordHit")

local viewmodel = Camera.Viewmodel.RightHand.RightWrist
local weld = viewmodel.C0
local oldweld = viewmodel.C0

local animRunning = true
local reverseTween

local animAuraTab = {}

local auraAnimations = {
	["1.7"] = {
		{CFrame = CFrame.new(0.69, -0.7, 0.1) * CFrame.Angles(math.rad(-65), math.rad(55), math.rad(-51)), Timer = 0.1},
		{CFrame = CFrame.new(0.16, -1.16, 0.5) * CFrame.Angles(math.rad(-179), math.rad(54), math.rad(33)), Timer = 0.16},
	},
	["Spin"] = {
		{CFrame = CFrame.new(0.69, -0.7, 0.1) * CFrame.Angles(math.rad(-90), math.rad(0), math.rad(0)), Timer = 0.05},
		{CFrame = CFrame.new(0.69, -0.7, 0.1) * CFrame.Angles(math.rad(-145), math.rad(0), math.rad(0)), Timer = 0.05},
		{CFrame = CFrame.new(0.16, -1.16, 0.5) * CFrame.Angles(math.rad(-180), math.rad(0), math.rad(0)), Timer = 0.05},
		{CFrame = CFrame.new(0.16, -1.16, 0.5) * CFrame.Angles(math.rad(-220), math.rad(0), math.rad(0)), Timer = 0.05},
		{CFrame = CFrame.new(0.16, -1.16, 0.5) * CFrame.Angles(math.rad(-270), math.rad(0), math.rad(0)), Timer = 0.05},
		{CFrame = CFrame.new(0.16, -1.16, 0.5) * CFrame.Angles(math.rad(-310), math.rad(0), math.rad(0)), Timer = 0.05},
		{CFrame = CFrame.new(0.16, -1.16, 0.5) * CFrame.Angles(math.rad(-360), math.rad(0), math.rad(0)), Timer = 0.05},
	},
	["Reverse Spin"] = {
		{CFrame = CFrame.new(0.69, -0.7, 0.1) * CFrame.Angles(math.rad(90), math.rad(0), math.rad(0)), Timer = 0.05},
		{CFrame = CFrame.new(0.69, -0.7, 0.1) * CFrame.Angles(math.rad(145), math.rad(0), math.rad(0)), Timer = 0.05},
		{CFrame = CFrame.new(0.16, -1.16, 0.5) * CFrame.Angles(math.rad(180), math.rad(0), math.rad(0)), Timer = 0.05},
		{CFrame = CFrame.new(0.16, -1.16, 0.5) * CFrame.Angles(math.rad(220), math.rad(0), math.rad(0)), Timer = 0.05},
		{CFrame = CFrame.new(0.16, -1.16, 0.5) * CFrame.Angles(math.rad(270), math.rad(0), math.rad(0)), Timer = 0.05},
		{CFrame = CFrame.new(0.16, -1.16, 0.5) * CFrame.Angles(math.rad(310), math.rad(0), math.rad(0)), Timer = 0.05},
		{CFrame = CFrame.new(0.16, -1.16, 0.5) * CFrame.Angles(math.rad(360), math.rad(0), math.rad(0)), Timer = 0.05},
	},
	["Exhibition"] = {
		{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.1},
		{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.2},
	},
	["Exhibition Old"] = {
		{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.15},
		{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.05},
		{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.1},
		{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.05},
		{CFrame = CFrame.new(0.63, -0.1, 1.37) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.15},
	},
	["Zoom"] = {
		{CFrame = CFrame.new(0.69, -2, 0.1) * CFrame.Angles(math.rad(-65), math.rad(55), math.rad(-51)), Timer = 0.1},
		{CFrame = CFrame.new(0.16, -0.1, -1) * CFrame.Angles(math.rad(-179), math.rad(94), math.rad(33)), Timer = 0.16},
	},
	["reblock"] = {
		{CFrame = CFrame.new(0.69, -1, 0.1) * CFrame.Angles(math.rad(-16), math.rad(12), math.rad(-21)), Timer = 0.1},
		{CFrame = CFrame.new(0.69, -2, 0.1) * CFrame.Angles(math.rad(-72), math.rad(21), math.rad(-35)), Timer = 0.07},
		{CFrame = CFrame.new(0.69, -0.6, 0.1) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)), Timer = 0.07},
	},
	["rotate"] = {
		{CFrame = CFrame.new(0.69, -2, 0.1) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)), Timer = 0.1},
		{CFrame = CFrame.new(0.16, -0.1, -1) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(180)), Timer = 0.1},
		{CFrame = CFrame.new(0.16, -0.1, -1) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(270)), Timer = 0.1},
		{CFrame = CFrame.new(0.16, -0.1, -1) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(360)), Timer = 0.1},
	},
	["twist"] = {
		{CFrame = CFrame.new(0.69, -2, 0.1) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)), Timer = 0.1},
		{CFrame = CFrame.new(0.69, -2, 0.1) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(60)), Timer = 0.3},
	},
	["OldAstralAnim"] = {
		{CFrame = CFrame.new(1, -1, 2) * CFrame.Angles(math.rad(295), math.rad(55), math.rad(290)), Time = 0.2},
		{CFrame = CFrame.new(-1, 1, -2.2) * CFrame.Angles(math.rad(200), math.rad(60), math.rad(1)), Time = 0.2}
	},
	["noanimations"] = {
		{CFrame = CFrame.new(1, -1, 2) * CFrame.Angles(math.rad(295), math.rad(55), math.rad(220)), Time = 0.1},
		{CFrame = CFrame.new(-1, 1, -2.2) * CFrame.Angles(math.rad(200), math.rad(60), math.rad(1)), Time = 0.1},
		{CFrame = CFrame.new(0.5, -0.5, 1) * CFrame.Angles(math.rad(250), math.rad(40), math.rad(180)), Time = 0.1},
		{CFrame = CFrame.new(-0.5, 0.5, -1.1) * CFrame.Angles(math.rad(160), math.rad(45), math.rad(5)), Time = 0.1},
		{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)), Time = 0.1}
	},
}

local funAnimations = {
	PLAYER_VACUUM_SUCK = "rbxassetid://9671620809",
	WINTER_BOSS_SPAWN = "rbxassetid://11843861791",
	GLUE_TRAP_FLYING = "rbxassetid://11466075174",
	VOID_DRAGON_TRANSFORM = "rbxassetid://10967424821",
	SIT_ON_DODO_BIRD = "http://www.roblox.com/asset/?id=2506281703",
	DODO_BIRD_FALL = "rbxassetid://7617326953",
	SWORD_SWING = "rbxassetid://7234367412",
}

local swingAnim
local auraConnection
local targetInfo = Instance.new("TextLabel",ScreenGui)
Killaura = Combat.NewButton({
	Name = "aura",
	Keybind = Enum.KeyCode.X,
	Function = function(callback)
		if callback then
            auraConnection = RunService.Heartbeat:Connect(function()
                local nearest = getNearestPlayer(22)

                if nearest ~= nil then
                    local nearestCharacter = nearest.Character
                    local nearestPrimaryPartPosition = nearestCharacter.PrimaryPart.Position
                    local selfPrimaryPartPosition = PrimaryPart.Position
                    local weapon = getBestWeapon()
                    spoofHand(weapon.Name)

                    task.spawn(	function()
                        for i = 1,1 do
                            AuraRemote:FireServer({
                                chargedAttack = {
                                    chargeRatio = 0
                                },
                                entityInstance = nearestCharacter,
                                validate = {
                                    raycast = {
                                        cameraPosition = CurrentCamera,
                                        cursorDirection = CFrame.LookVector
                                    },
                                    targetPosition = {
                                        value = nearestPrimaryPartPosition
                                    },
                                    selfPosition = {
                                        value = selfPrimaryPartPosition
                                    }
                                },
                                weapon = weapon
                            })
                        end
                    end)
                end
            end)



			task.spawn(function()
				repeat task.wait(0)
					if getNearestPlayer(22) ~= nil then
						pcall(function()
							local animation = auraAnimations[auraAnimation.Option]
							local allTime = 0
							task.spawn(function()
								if CustomAnimation.Enabled then
									animRunning = true
									for i,v in pairs(animation) do allTime += v.Timer end
									for i,v in pairs(animation) do
										local tween = game.TweenService:Create(viewmodel,TweenInfo.new(v.Timer),{C0 = oldweld * v.CFrame})
										tween:Play()
										task.wait(v.Timer - 0)
									end
									animRunning = false
									game.TweenService:Create(viewmodel,TweenInfo.new(1),{C0 = oldweld}):Play()
								end
							end)
							task.wait(allTime)
						end)
					end
				until (not Killaura.Enabled)
			end)

			task.spawn(function()
				repeat
					local nearest = getNearestPlayer(22)

					if nearest ~= nil then
						local isWinning = function()
							return nearest.Character.Humanoid.Health > Humanoid.Health
						end

						if targetInfo == nil then
							targetInfo = Instance.new("TextLabel",ScreenGui)
						end

						if TargetHudMode.Option == "Basic" then
							pcall(function()
								targetInfo.Size = UDim2.fromScale(.12, .05)
								targetInfo.BackgroundColor3 = Color3.fromRGB(25,25,25)
								targetInfo.BorderSizePixel = 0
								targetInfo.AnchorPoint = Vector2.new(0.5,0.5)
								targetInfo.Position = UDim2.fromScale(0.6,0.5)
								targetInfo.TextColor3 = Color3.fromRGB(255,255,255)
								targetInfo.Text = "  "..nearest.DisplayName.. " - IsWinning: ".. tostring(isWinning())
								targetInfo.TextXAlignment = Enum.TextXAlignment.Left

								local hp = Instance.new("Frame", targetInfo)
								hp.Position = UDim2.fromScale(0, .9)
								hp.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
								hp.BorderSizePixel = 0
								
								TweenService:Create(hp,TweenInfo.new(1),{
									Size = UDim2.fromScale(0.01 * nearest.Character.Humanoid.Health,0.1)
								}):Play()
							end)	
						end

						if TargetHudMode.Option == "Basic2" then
							pcall(function()
								TweenService:Create(targetInfo,TweenInfo.new(1),{
									Size = UDim2.fromScale(0.001 * nearest.Character.Humanoid.Health,0.04)
								}):Play()
								targetInfo.BackgroundColor3 = library.Color
								targetInfo.BorderSizePixel = 0
								targetInfo.AnchorPoint = Vector2.new(0.5,0.5)
								targetInfo.Position = UDim2.fromScale(0.6,0.5)
								targetInfo.TextColor3 = Color3.fromRGB(255,255,255)
								targetInfo.Text = "  "..nearest.DisplayName
								--targetInfo.TextScaled = true
								targetInfo.TextXAlignment = Enum.TextXAlignment.Left
							end)	
						end

					else
						pcall(function()
							targetInfo:Remove()

							targetInfo = nil
						end)
					end
					task.wait()
				until (not Killaura.Enabled)
			end)
		else
			pcall(function()
				swingAnim:Destroy()
			end)
			pcall(function()
				auraConnection:Disconnect()
			end)
		end
	end,
})

local animAuraTab = {}
for i,v in pairs(auraAnimations) do table.insert(animAuraTab,i) end

auraAnimation = Killaura.NewPicker({
	Name = "Animations",
	Options = animAuraTab
})
CustomAnimation = Killaura.NewToggle({
	Name = "Animations",
	Function = function() end
})
TargetHudMode = Killaura.NewPicker({
	Name = "TargetHud",
	Options = {"None", "Basic", "Basic2"}
})

table.insert(spawnConnections,function(char)
	task.wait(1)
	viewmodel = workspace.Camera.Viewmodel.RightHand.RightWrist
end)

local assetTable = {
	Sus = "http://www.roblox.com/asset/?id=9145833727",
	Damc = "rbxassetid://16930990336",
	Springs = "rbxassetid://16930908008",
	Xylex = "rbxassetid://16930961099",
	Alsploit = "http://www.roblox.com/asset/?id=12772788813",
	Matrix = "http://www.roblox.com/asset/?id=1412150157",
	Covid = "http://www.roblox.com/asset/?id=8518879821",
	Space = "http://www.roblox.com/asset/?id=2609221356",
	Windows = "http://www.roblox.com/asset/?id=472001646",
	Trol = "http://www.roblox.com/asset/?id=6403436054",
	Cat = "http://www.roblox.com/asset/?id=14841615129",
	Furry = "http://www.roblox.com/asset/?id=14831068996",
}

local stylesofskybox = {}
for i,v in pairs(assetTable) do
	table.insert(stylesofskybox, i)
end

SelfESP = Visuals.NewButton({
	Name = "SelfESP",
	Function = function(callback)
		if callback then
			local e = Instance.new("BillboardGui",LocalPlayer.Character.PrimaryPart)
			local image = Instance.new("ImageLabel",e)
			image.Size = UDim2.fromScale(10,10)
			image.Position = UDim2.fromScale(-3,-4)

			image.BackgroundTransparency = 1
			e.Size = UDim2.fromScale(0.5,0.5)
			e.AlwaysOnTop = true
			e.Name = "nein"

			task.spawn(function()
				repeat task.wait()
					image.Image = assetTable[SelfESPStyle.Option]
				until not SelfESP.Enabled
			end)

		else
			pcall(function()
				LocalPlayer.Character.PrimaryPart.nein:Destroy()
			end)
		end
	end,
})
SelfESPStyle = SelfESP.NewPicker({
	Name = "Style",
	Options = stylesofskybox
})

ImageESP = Visuals.NewButton({
	Name = "ImageESP",
	Function = function(callback)
		if callback then

			task.spawn(function()
				repeat
					pcall(function()
						for i,v in pairs(Players:GetPlayers()) do
							if not (v.Character.PrimaryPart:FindFirstChild("nein")) then
								if v ~= LocalPlayer and ImageESP.Enabled then
									local e = Instance.new("BillboardGui",v.Character.PrimaryPart)

									local image = Instance.new("ImageLabel",e)
									image.Size = UDim2.fromScale(10,10)
									image.Position = UDim2.fromScale(-3,-4)
									image.Image = assetTable[ImageESPStyle.Option]
									image.BackgroundTransparency = 1

									e.Size = UDim2.fromScale(0.5,0.5)
									e.AlwaysOnTop = true
									e.Name = "nein"
								end
							end
						end
					end)
					task.wait()
				until not ImageESP.Enabled
			end)

		else
			pcall(function()
				for i,v in pairs(Players:GetPlayers()) do
					if (v.Character.PrimaryPart:FindFirstChild("nein")) then
						if v ~= LocalPlayer then
							v.Character.PrimaryPart:FindFirstChild("nein"):Destroy()
						end
					end
				end
			end)
		end
	end,
})
ImageESPStyle = ImageESP.NewPicker({
	Name = "Style",
	Options = stylesofskybox
})

local infFlyPart
InfiniteFly = Motion.NewButton({
	Name = "InfFly",
    Keybind = Enum.KeyCode.H,
	Function = function(callback)
		if callback then
			infFlyPart = Instance.new("Part",workspace)
			infFlyPart.Anchored = true
			infFlyPart.CanCollide = true
			infFlyPart.CFrame = PrimaryPart.CFrame
			infFlyPart.Size = Vector3.new(.5 ,.5, .5)
            if RootPartShow.Enabled then
                infFlyPart.Transparency = 0
            elseif not RootPartShow.Enabled then
			    infFlyPart.Transparency = 1
            end
			PrimaryPart.CFrame += Vector3.new(0,1000000,0)
			CurrentCamera.CameraSubject = infFlyPart
			repeat task.wait()
				if PrimaryPart.Position.Y < infFlyPart.Position.Y then
					PrimaryPart.CFrame += Vector3.new(0,1000000,0)
				end

				if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
					infFlyPart.CFrame += Vector3.new(0,0.45,0)
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
					infFlyPart.CFrame += Vector3.new(0,-0.45,0)
				end

				infFlyPart.CFrame = CFrame.new(PrimaryPart.CFrame.X,infFlyPart.CFrame.Y,PrimaryPart.CFrame.Z)
			until not InfiniteFly.Enabled

		else
			pcall(function()

				for i = 1,10 do task.wait(0.01)
					PrimaryPart.Velocity = Vector3.new(0,0,0)
					PrimaryPart.CFrame = infFlyPart.CFrame
				end

				infFlyPart:Remove()
			end)

			CurrentCamera.CameraSubject = Character
		end
	end,
})
RootPartShow = InfiniteFly.NewToggle({
	Name = "ShowRoot",
	Function = function() end
})

local ViewmodelConnection
Viewmodel = Visuals.NewButton({
	Name = "Viewmodel",
	Function = function(callback)
		if callback then
			ViewmodelConnection = workspace.CurrentCamera.Viewmodel.ChildAdded:Connect(function(child)
				if child:IsA("Accessory") then
					task.spawn(function()
						repeat task.wait() until child:FindFirstChild("Handle")
						for i,v in pairs(child:GetDescendants()) do
							v.Size /= 1.5
						end
					end)
				end
			end) 
		else
			pcall(function()
				ViewmodelConnection:Disconnect()
			end)
		end
	end,
})

local HUDScreen = Instance.new("ScreenGui",PlayerGui)
HUDScreen.ResetOnSpawn = false

local HUDS = {}

HUDS[1] = function()
	local text = "venus"
	local id = "http://www.roblox.com/asset/?id=7498352732"
	local lplr = game.Players.LocalPlayer
	local label = Instance.new("TextLabel",HUDScreen)
	label.Text = text
	label.BackgroundColor3 = Color3.fromRGB(0,0,0)
	label.BorderSizePixel = 0
	label.TextColor3 = Color3.fromRGB(255,255,255)
	label.BackgroundTransparency = 1
	label.Size = UDim2.fromScale(0.075,0.035)
	label.Position = UDim2.fromScale(0,0)
	label.TextSize = 12
	label.Name = "Logo"
	local glow = Instance.new("ImageLabel",label)
	glow.Size = UDim2.fromScale(1.8,1.5)
	glow.Position = UDim2.fromScale(-0.35,-0.2)
	glow.Image = id
	glow.ImageTransparency = 0.5
	glow.BackgroundTransparency = 1
	glow.ImageColor3 = Color3.fromRGB(0,0,0)
	glow.ZIndex = -10
end
HUDS[2] = function()
	local text = "Venus"

	local frame = Instance.new("TextLabel",HUDScreen)
	frame.Size = UDim2.fromScale(0.17,0.04)
	frame.Position = UDim2.fromScale(0.02,0)
	frame.BorderSizePixel = 0
	frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
	frame.Text = text .. " | Build "..PolarisRelease 
	frame.TextColor3 = Color3.fromRGB(255,255,255)
	frame.Size = UDim2.fromScale(0.1,0.035)
	frame.TextSize = 12
	frame.Name = "Logo"
	local frameTop = Instance.new("Frame",frame)
	frameTop.Size = UDim2.fromScale(1,0.08)
	frameTop.BorderSizePixel = 0
	frameTop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
end

HUD = Visuals.NewButton({
	Name = "HUD",
	Function = function(callback)
		if callback then
			task.spawn(function()
				task.wait(0.5)
				HUDScreen = Instance.new("ScreenGui",PlayerGui)
				HUDScreen.ResetOnSpawn = false
				if HUDStyle.Option == "venus 1" then
					HUDS[1]()
				elseif HUDStyle.Option == "venus 2" then
					HUDS[2]()
				end
				library.Array.SortMode = ArraySortStyle.Option
                if library.Array.Transparency then
				    library.Array.BackgroundTransparency = 0.48
                else
                    library.Array.BackgroundTransparency = 0.3
                end
                
				library.Array.TextTransparency = 0
				refreshArray()
			end)
		else
			pcall(function()
				HUDScreen:Remove()
			end)
		end
	end,
})
DeeperTransparency = HUD.NewToggle({
	Name = "DeeperTransparency",
	Function = function(v)
		library.Array.Transparency = v
		for i = 1, 2 do
			refreshArray()
			task.wait()
		end
	end
})
HUDStyle = HUD.NewPicker({
	Name = "Logo Style",
	Options = {"Venus 1", "Venus 2"}
})
ArrayStyle = HUD.NewPicker({
	Name = "Array Style",
	Options = {"Normal", "Rgb","Space"}
})

task.spawn(function()
	repeat
		task.wait()

		for i = 1, #arrayItems, 10 do
			local endIndex = math.min(i + 9, #arrayItems)
			for j = i, endIndex do
				local v = arrayItems[j]
				if ArrayStyle.Option == "Normal" then
					v.TextColor3 = Color3.fromRGB(255, 255, 255)
				end

				if ArrayStyle.Option == "Gay" then
					local red = math.floor(math.sin(j / 10) * 127 + 128)
					local green = math.floor(math.sin(j / 10 + 2) * 127 + 128)
					local blue = math.floor(math.sin(j / 10 + 4) * 127 + 128)
					v.TextColor3 = Color3.fromRGB(red, green, blue)
				end

				if ArrayStyle.Option == "Space" then
					local red = math.floor(math.sin(j / 10) * 127 + 128)
					local blue = math.floor(math.sin(j / 10 + 2) * 127 + 128)
					v.TextColor3 = Color3.fromRGB(red, 0, blue)
				end
			end
		end
	until false
end)


ArraySortStyle = HUD.NewPicker({
	Name = "Sort Style",
	Options = {"TextLength","ReverseTextLength", "None"}
})
ArrayBlur = HUD.NewToggle({
	Name = "ArrayBlur",
	Function = function(v)
		library.Array.BlurEnabled = v
	end
})
ArrayBackground = HUD.NewToggle({
	Name = "ArrayBackground",
	Function = function(v)
		library.Array.Background = v
		for i = 1, 2 do
			refreshArray()
			task.wait()
		end
	end
})

ArrayRounded = HUD.NewToggle({
	Name = "ArrayRounded",
	Function = function(v)
		library.Array.Rounded = v
		for i = 1, 2 do
			refreshArray()
			task.wait()
		end
	end
})

local flycon
Fly = Motion.NewButton({
	Name = "Fly",
	Keybind = Enum.KeyCode.R,
	Function = function(callback)
		if callback then
			if flyMode.Option == "vanila" then
				flycon = RunService.Heartbeat:Connect(function()
					local velo = PrimaryPart.Velocity
					PrimaryPart.Velocity = Vector3.new(velo.X, 2.04, velo.Z)

					if UserInputService:IsKeyDown("Space") then
						PrimaryPart.Velocity = Vector3.new(velo.X, 80, velo.Z)
					end
					if UserInputService:IsKeyDown("LeftShift") then
						PrimaryPart.Velocity = Vector3.new(velo.X, -80, velo.Z)
					end
				end)
			end
			if flyMode.Option == "fast" then
				TweenService:Create(PrimaryPart, TweenInfo.new(2.3), {
					CFrame = PrimaryPart.CFrame + PrimaryPart.CFrame.LookVector * 50 + Vector3.new(0, 10, 0)
				}):Play()
				task.delay(0.85, function()
					Fly.ToggleButton(false)
				end)
			end
		else
			pcall(function()
				flycon:Disconnect()
			end)
		end
	end,
})

flyMode = Fly.NewPicker({
	Name = "Mode",
	Options = {"vanila", "fast", "damage"}
})														

local strafecon
Strafe = Motion.NewButton({
	Name = "Strafe",
	Function = function(callback)
		if callback then
			strafecon = RunService.Heartbeat:Connect(function()
				local dir = Humanoid.MoveDirection
				local speed = Humanoid.WalkSpeed

				PrimaryPart.Velocity = Vector3.new((dir * speed).X,PrimaryPart.Velocity.Y,(dir * speed).Z)
			end)
		else
			pcall(function()
				strafecon:Disconnect()
			end)
		end
	end,
})

local fpscon
local fpscount = 0
local statsxd
LevelInfo = Visuals.NewButton({
	Name = "LevelInfo",
	Function = function(callback)
		if callback then
			statsxd = Instance.new("TextLabel", ScreenGui)
			statsxd.Position = UDim2.fromScale(0, 0.6)
			statsxd.Size = UDim2.fromScale(0.2, 0.3)
			statsxd.BackgroundTransparency = 1
			statsxd.TextColor3 = Color3.fromRGB(255,255,255)
			statsxd.TextSize = 11
			statsxd.Name = "Stats"
			fpscon = RunService.Heartbeat:Connect(function()
				fpscount += 1
			end)
			task.spawn(function()
				task.wait(.05)
				repeat
					task.wait(1)
					fpscount = 0
				until false
			end)
			task.spawn(function()
				repeat
					statsxd.Text = "FPS: "..tostring(fpscount).. " \n \n Username: "..LocalPlayer.DisplayName.. " \n \n Venus User: "..Venus_user.. " \n \n Network: Bedwars.com \n \n Game: Bedwars \n \n Hurttime: "..hurttime
					task.wait(1)
				until false
			end)
		else
			pcall(function()
				fpscon:Disconnect()
				statsxd:Remove()
			end)
		end
	end,
})

airTime = 0

spawn(function()
	repeat
		if utils.onGround() then
			airTime = 0
		else
			airTime +=1
		end
		task.wait()
	until false
end)

local speedcon
local tickxd = 0
Speed = Motion.NewButton({
	Name = "Speed",
	Function = function(callback)
		if callback then
			repeat
				tickxd += 1
				local dir = Humanoid.MoveDirection
				local velo = PrimaryPart.Velocity
				local speed = 0.3

				if SpeedMode.Option == "Bedwars" then
					speed = Character:GetAttribute("SpeedBoost") and 0.1 or 0.017
					PrimaryPart.CFrame += (speed * dir)
				end

				if SpeedMode.Option == "vanila" then
					speed = 0.06
					PrimaryPart.CFrame += (speed * dir)
					
				end

				if SpeedMode.Option == "WalkSpeed" then
					Humanoid.WalkSpeed = 23																	
				end																	
				task.wait()
			until not Speed.Enabled
		else
			Humanoid.WalkSpeed = 16
		end
	end,
})
SpeedMode = Speed.NewPicker({
	Name = "Mode",
	Options = {"Bedwars", "vanila", "WalkSpeed"}
})

NoSlowDown = Motion.NewButton({
	Name = "NoSlowDown",
	Function = function(callback)
		if callback then
			repeat task.wait()
				Humanoid.WalkSpeed = 20
			until not NoSlowDown.Enabled
		end
	end,
})

Phase = Player.NewButton({
	Name = "Phase",
	Function = function(callback)
		if callback then
			if PhaseMode.Option == "BedwarsAuto" then
				task.delay(2.5, function()
					PrimaryPart.CFrame -= Vector3.new(0, 10, 0)
				end)
			end
		end
	end,
})
PhaseMode = Phase.NewPicker({
	Name = "Mode",
	Options = {"BedwarsAuto"}
})

local AirJumpCon
AirJump = Motion.NewButton({
	Name = "AirJump",
	Function = function(callback)
		if callback then
			AirJumpCon = UserInputService.InputBegan:Connect(function(k, g)
				if g then return end
				if k == nil then return end
				if InfiniteFly.Enabled then return end
				if k.KeyCode == Enum.KeyCode.Space then
					Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end)
		else
			pcall(function()
				AirJumpCon:Disconnect()
			end)
		end
	end,
})

Spider = Motion.NewButton({
	Name = "Spider",
	Function = function(callback)
		if callback then
			repeat
				local raycastxd = Utilities.newRaycast(PrimaryPart.Position,Humanoid.MoveDirection * 2)
				local velo = PrimaryPart.Velocity

				if raycastxd and not UserInputService:IsKeyDown("S") then
					PrimaryPart.Velocity = Vector3.new(velo.X, 44, velo.Z)
				end

				task.wait()
			until not Spider.Enabled
		end
	end,
})

local JumpCirclesCon
JumpPlates = Visuals.NewButton({
	Name = "JumpPlates",
	Function = function(callback)
		if callback then
			task.spawn(function()
				repeat task.wait()
					local state = Humanoid:GetState()

					if state == Enum.HumanoidStateType.Jumping then
						local plate = Instance.new("Part",workspace)
						plate.Anchored = true
						plate.CanCollide = false
						plate.CastShadow = false
						plate.Size = Vector3.new(0,0,0)
						plate.CFrame = PrimaryPart.CFrame
						plate.Material = Enum.Material.Neon
						plate.Color = library.Color

						game.TweenService:Create(plate,TweenInfo.new(0.6),{
							Size = Vector3.new(4,1,4),
							CFrame = plate.CFrame - Vector3.new(0,2,0),
							Transparency = 1
						}):Play()

						game.Debris:AddItem(plate,0.6)
					end
				until not JumpPlates.Enabled
			end)
		end
	end,
})

local lastpos
Antifall = Misc.NewButton({
	Name = "Antifall",
	Function = function(callback)
		if callback then
			repeat
				if PrimaryPart.CFrame.Y < 0 then
					for i = 1, 15 do
						task.wait()
						PrimaryPart.CFrame += Vector3.new(0, 1, 0)
						PrimaryPart.Velocity = Vector3.new(10, -50, 10)
					end
					PrimaryPart.CFrame = lastPosOnGround
				end
				task.wait()
			until not Antifall.Enabled
		end
	end,
})

local nofallremote = getRemote("GroundHit")
Nofall = Misc.NewButton({
	Name = "Nofall",
	Function = function(callback)
		if callback then
			repeat
				nofallremote:FireServer()
				task.wait(0.5)
			until not Nofall.Enabled
		end
	end,
})

local lastHP = 100
DamageBoost = Motion.NewButton({
	Name = "DamageBoost",
	Function = function(callback)
		if callback then
			repeat

				if (hurttime <= 50) then
					PrimaryPart.CFrame += Humanoid.MoveDirection * 0.26
				end

				lastHP = Humanoid.Health
				task.wait()
			until not DamageBoost.Enabled
		end
	end,
})

local lastHPHurt = 100
task.spawn(function()
	repeat task.wait()
		if (Humanoid.Health < lastHPHurt) then
			hurttime = 0
		end

		lastHPHurt = Humanoid.Health
		hurttime += 1
	until false
end)

local chests = {}
for i,v in pairs(workspace:GetChildren()) do
	if v.Name == "chest" then
		table.insert(chests,v)
	end
end
Stealer = Player.NewButton({
	Name = "Stealer",
	Function = function(callback)
		if callback then
			task.spawn(function()
				repeat task.wait()
					task.wait(0.075)
					task.spawn(function()
						for i, v in pairs(chests) do
							local Magnitude = (v.Position - PrimaryPart.Position).Magnitude
							if Magnitude <= 30 then
								for _, item in pairs(v.ChestFolderValue.Value:GetChildren()) do
									if item:IsA("Accessory") then
										task.wait()
										game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):FindFirstChild("@rbxts").net.out._NetManaged:FindFirstChild("Inventory/ChestGetItem"):InvokeServer(v.ChestFolderValue.Value, item)
									end
								end
							end
						end
					end)
				until (not Stealer.Enabled)
			end)
		end
	end,
})

local ProjectileFire = getRemote("ProjectileFire")
local function shoot(bow, pos)
	local args = {}
	local shootFormulaStart = pos + Vector3.new(0,2,0)
	local shootFormulaDirection = Vector3.new(0,-100,0)
	ProjectileFire:InvokeServer({
		[1] = bow,
		[2] = bow.Name,
		[3] = pos,
		[4] = shootFormulaStart,
		[5] = Vector3.new(0,-5,0),
		[6] = tostring(game:GetService("HttpService"):GenerateGUID(true)),
		[7] = {
            ["drawDurationSeconds"] = 1,
			["shotId"] = tostring(game:GetService("HttpService"):GenerateGUID(false))
		},
		[8] =  workspace:GetServerTimeNow() - 0.045
	})
end

local function getAllBows()
	local bows = {}
	for i,v in pairs(inventory:GetChildren()) do
		if v.Name:find("bow") or v.Name:find("fireball") or v.Name:find("snowball") then
			table.insert(bows,v)
		end
	end
	return bows
end

--[[Projectileaura = Combat.NewButton({
	Name = "Projectileaura",
	Function = function(callback)
		if callback then
			task.spawn(function()
				swingAnim = Instance.new("Animation")
				swingAnim.AnimationId = funAnimations.SWORD_SWING
				local track = Humanoid.Animator:LoadAnimation(swingAnim)
				repeat
					local target = getNearestPlayer(9e9)
					local rangeCheck = getNearestPlayer(2)
					local entity = target
					if target and rangeCheck == nil then
						local bows = getAllBows()
						for i,v in pairs(bows) do
							spoofHand(v.Name)
							task.wait(.05)
							if v.Name == "fireball" or v.Name == "snowball" and not AllProjectiles.Enabled then
								continue
							end
							shoot(v,target.Character.PrimaryPart.Position)
							track:Play()
						end
					end
					task.wait()
				until (not Projectileaura.Enabled)
			end)
		end
	end,
})
AllProjectiles = Projectileaura.NewToggle({
	Name = "AllProjectiles",
	Function = function() end
})]]

local ConsumeRemote = getRemote("ConsumeItem")
AutoPot = Player.NewButton({
	["Name"] = "AutoPot",
	Function = function(callback)
		if callback then
			task.spawn(function()
				repeat task.wait()
					if hasItem("speed_potion") then
						ConsumeRemote:InvokeServer({
							["item"] = inventory:WaitForChild("speed_potion")
						})
					end
					if hasItem("pie") then
						ConsumeRemote:InvokeServer({
							["item"] = inventory:WaitForChild("pie")
						})
					end
				until (not AutoPot.Enabled)
			end)
		end
	end
})

--[[local sprintController = getController("SprintController")
Sprint = Player.NewButton({
	["Name"] = "Sprint",
	Function = function(callback)
		if callback then
			task.spawn(function()
				repeat task.wait()
					pcall(function()
						sprintController:startSprinting()
					end)
				until (not Sprint.Enabled)
			end)
		end
	end
})]]

--[[local knockbackHandler = debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.damage["knockback-util"]).KnockbackUtil.calculateKnockbackVelocity, 1)
local oldKb = knockbackHandler.kbUpwardStrength
Velocity = Combat.NewButton({
	Name = "Velocity",
	Function = function(callback)
		if callback then
			knockbackHandler.kbUpwardStrength = 0
			knockbackHandler.kbDirectionStrength = 0
		else
			knockbackHandler.kbUpwardStrength = oldKb
			knockbackHandler.kbDirectionStrength = oldKb
		end
	end,
})]]

local oldsky = {
	amb = Lighting.Ambient,
	outdooramb = Lighting.OutdoorAmbient,
}
local AmbienceTable = {
	Purple = Color3.fromRGB(100, 0, 255),
	Blue = Color3.fromRGB(0, 20, 255),
	Green = Color3.fromRGB(0, 255, 30),
	Yellow = Color3.fromRGB(255, 255, 0),
	Orange = Color3.fromRGB(255, 140, 25),
	Red = Color3.fromRGB(255, 0, 0),
	Brown = Color3.fromRGB(120, 40, 15),
}
local ambtableoption = {}
for i,v in pairs(AmbienceTable) do
	table.insert(ambtableoption, i)
end
local dayTime = Lighting.TimeOfDay
Ambience = Visuals.NewButton({
	Name = "Ambience",
	Function = function(callback)
		if callback then
			repeat
				Lighting.Ambient = AmbienceTable[AmbienceStyle.Option]
				Lighting.OutdoorAmbient = AmbienceTable[AmbienceStyle.Option]

				Lighting.TimeOfDay = (AmbienceTime.Option == "Day" and dayTime or "24:00:00")
				task.wait()
			until not Ambience.Enabled
		else
			Lighting.TimeOfDay = dayTime
			Lighting.Ambient = oldsky.amb
			Lighting.OutdoorAmbient = oldsky.outdooramb
		end
	end,
})
AmbienceStyle = Ambience.NewPicker({
	Name = "Style",
	Options = ambtableoption
})
AmbienceTime = Ambience.NewPicker({
	Name = "Time",
	Options = {"Day", "Night"}
})

local function placeBlock(pos,block)
	local blockenginemanaged = ReplicatedStorage.rbxts_include.node_modules:WaitForChild("@easy-games"):WaitForChild("block-engine").node_modules:WaitForChild("@rbxts").net.out:WaitForChild("_NetManaged")
	blockenginemanaged.PlaceBlock:InvokeServer({
		['blockType'] = block,
		['position'] = Vector3.new(pos.X / 3,pos.Y / 3,pos.Z / 3),
		['blockData'] = 0
	})
end

local function getWool()
	for i,v in pairs(inventory:GetChildren()) do if v.Name:lower():find("wool") then return v.Name end end
end

local scaffoldRun
Scaffold = Misc.NewButton({
	["Name"] = "Scaffold",
	["Function"] = function(callback)
		if callback then
			scaffoldRun = RunService.Heartbeat:Connect(function()
				local block = getWool()
				if game.UserInputService:IsKeyDown(Enum.KeyCode.Space) then
					local velo = PrimaryPart.Velocity
					if ScaffoldMode3.Option == "Slow" then
						PrimaryPart.Velocity = Vector3.new(velo.X,15,velo.Z)
						for i = 1, 8 do
							placeBlock((PrimaryPart.CFrame + PrimaryPart.CFrame.LookVector * 1) - Vector3.new(0,i + 4.5,0),block)
							placeBlock((PrimaryPart.CFrame + PrimaryPart.CFrame.LookVector) - Vector3.new(0,i + 4.5,0),block)
							task.wait()
						end
					end
					if ScaffoldMode3.Option == "Normal" then
						PrimaryPart.Velocity = Vector3.new(velo.X,30,velo.Z)
						for i = 1, 8 do
							placeBlock((PrimaryPart.CFrame + PrimaryPart.CFrame.LookVector * 1) - Vector3.new(0,i + 4.5,0),block)
							placeBlock((PrimaryPart.CFrame + PrimaryPart.CFrame.LookVector) - Vector3.new(0,i + 4.5,0),block)
							task.wait()
						end
					end
					if ScaffoldMode3.Option == "Fast" then
						PrimaryPart.Velocity = Vector3.new(velo.X,50,velo.Z)
						for i = 1, 8 do
							placeBlock((PrimaryPart.CFrame + PrimaryPart.CFrame.LookVector * 1) - Vector3.new(0,i + 4.5,0),block)
							placeBlock((PrimaryPart.CFrame + PrimaryPart.CFrame.LookVector) - Vector3.new(0,i + 4.5,0),block)
							task.wait()
						end
					end
				end
				if ScaffoldMode1.Option == "Normal" then
					if not Scaffold.Enabled then return end
					placeBlock((PrimaryPart.CFrame + PrimaryPart.CFrame.LookVector * 1) - Vector3.new(0,4.5,0),block)
				end
				if ScaffoldMode1.Option == "Expand" then
					for i = 1, 8 do
						if not Scaffold.Enabled then return end
						placeBlock((PrimaryPart.CFrame + PrimaryPart.CFrame.LookVector * i) - Vector3.new(0,4.5,0),block)
						task.wait()
					end
				end
			end)
		else
			scaffoldRun:Disconnect()
		end
	end,
})
ScaffoldMode1 = Scaffold.NewPicker({
	Name = "Place Mode",
	Options = {"Normal", "Expand"}
})
ScaffoldMode3 = Scaffold.NewPicker({
	Name = "Tower Mode",
	Options = {"Slow", "Normal", "Fast", "None"}
})
TowerExpand = Scaffold.NewToggle({
	Name = "Tower Expand",
	Function = function() end
})

local newfire
local newsparkles
Playereffects = Visuals.NewButton({
	Name = "Playereffects",
	Function = function(callback)
		if callback then
			task.wait(1)
			if EffectsStyle.Option == "Fire" then
				newfire = Instance.new("Fire", PrimaryPart)
				newfire.Size = 5.5
				newfire.Heat = 5
				newfire.TimeScale = 1
				newfire.Color = library.Color
				newfire.Enabled = true
				newfire.SecondaryColor = Color3.fromRGB(50,50,50)
			end

			if EffectsStyle.Option == "Sparkles" then
				newsparkles = Instance.new("Sparkles", PrimaryPart)
				newsparkles.TimeScale = 1
				newsparkles.SparkleColor = library.Color
				newsparkles.Enabled = true
			end

		else
			pcall(function()
				newfire:Remove()
			end)
			pcall(function()
				newsparkles:Remove()
			end)
		end
	end,
})
EffectsStyle = Playereffects.NewPicker({
	Name = "Style",
	Options = {"Fire", "Sparkles"}
})

local invisMethod2 = {
	["1"] = "rbxassetid://11335949902",
	["2"] = "rbxassetid://11360825341"
}

InvisibleExploit = Exploit.NewButton({
	Name = "InvisibleExploit",
	Function = function(callback)
		local track
		local theanimmethod
		if callback then
			theanimmethod = Instance.new("Animation")
			theanimmethod.AnimationId = invisMethod2[InvisMethod.Option]
			track = Humanoid.Animator:LoadAnimation(theanimmethod)
			repeat
				track:Play()
				task.wait()
			until not InvisibleExploit.Enabled
		else
			pcall(function()
				theanimmethod:Remove()
			end)
			pcall(function()
				track:Remove()
			end)
		end
	end,
})
InvisMethod = InvisibleExploit.NewPicker({
	Name = "Method",
	Options = {"1", "2"}
})

AntiHit = Combat.NewButton({
	Name = "AntiHit",
	Function = function(callback)
		if callback then
			local lastHit = tick()
			repeat
				local nearest = getNearestPlayer(12)
				if (hurttime <= 50) and nearest then
					if (AntiHitSafe.Enabled and tick() - lastHit > 0.4) then
						PrimaryPart.CFrame = nearest.Character.PrimaryPart.CFrame + nearest.Character.PrimaryPart.CFrame.LookVector * -4 + Vector3.new(0,3,0)
						lastHit = tick()
					else
						PrimaryPart.CFrame = nearest.Character.PrimaryPart.CFrame + nearest.Character.PrimaryPart.CFrame.LookVector * -4 + Vector3.new(0,3,0)
					end
				end
				lastHP = Humanoid.Health
				task.wait()
			until not DamageBoost.Enabled
		end
	end,
})
AntiHitSafe = AntiHit.NewToggle({
	Name = "Safe",
	Function = function() end
})

local function getGroupRank(plr:Player)
	return plr:GetRankInGroup(5774246)
end

local AltDetectorcon
AltDetector = Player.NewButton({
	Name = "AltDetector",
	Function = function(callback)
		if callback then
			AltDetectorcon = game.Players.PlayerAdded:Connect(function(plr)
				if plr.AccountAge < 16 then
					print(plr.Name .. " is an alt account.")
				end
			end)
		else
			pcall(function()
				AltDetectorcon:Disconnect()
			end)
		end
	end,
})

HighJump = Motion.NewButton({
    Name = "HighJump",
    Function = function(callback)
        if callback then
            repeat
                PrimaryPart.Velocity += Vector3.new(0, 6, 0)
                task.wait(0.007)
            until not HighJump.Enabled
        else
            PrimaryPart.Velocity = Vector3.new(0, 50, 0)
        end
    end,
})

local animtab = {
	Size = function(newpart)
		TweenService:Create(newpart, TweenInfo.new(1), {
			Size = Vector3.new(0,0,0)
		}):Play()
	end,
	YPos = function(newpart)
		TweenService:Create(newpart, TweenInfo.new(1), {
			CFrame = CFrame.new(newpart.CFrame.X,-10,newpart.CFrame.Z)
		}):Play()
	end,
	Transparency = function(newpart)
		TweenService:Create(newpart, TweenInfo.new(1), {
			Transparency = 1
		}):Play()
	end
}
Trails = Visuals.NewButton({
	Name = "Trails",
	Function = function(callback)
		if callback then
			spawn(function()
				repeat
					spawn(function()
						local newpart = Instance.new("Part", workspace)
						newpart.Shape = Enum.PartType[TrailsPart.Option]
						newpart.Material = Enum.Material[TrailsMaterial.Option]
						newpart.Size = Vector3.new(.65,.65,.65)
						newpart.Anchored = true
						newpart.CanCollide = false
						newpart.CFrame = PrimaryPart.CFrame
						newpart.Rotation = PrimaryPart.Rotation
						newpart.Color = library.Color
						task.delay(1.5, function()
							animtab[TrailsTweenMode.Option](newpart)
							task.delay(1, function()
								newpart:Remove()
							end)
						end)
					end)
					task.wait(.15)
				until not Trails.Enabled
			end)
		end
	end,
})
TrailsPart = Trails.NewPicker({
	Name = "Trail Part", 
	Options = {"Ball", "Block", "Cylinder", "Wedge", "CornerWedge"},
	Default = "Ball"
})
TrailsMaterial = Trails.NewPicker({
	Name = "Trail Material",
	Options = {"Neon", "Plastic", "SmoothPlastic", "DiamondPlate"},
	Default = "Neon"
})
TrailsTweenMode = Trails.NewPicker({
	Name = "Trail Delete",
	Options = { "Size", "YPos", "Transparency"},
	Default = "Size"
})

lastPosOnGround = PrimaryPart.CFrame

spawn(function()
	repeat
		if Utilities.onGround() then
			lastPosOnGround = PrimaryPart.CFrame
		end
		task.wait()
	until false
end)

local CameraModificationCon
local oldFOV = CurrentCamera.FieldOfView
Camera = Visuals.NewButton({
	Name = "Camera",
	Function = function(callback)
		if callback then
			CameraModificationCon = RunService.Heartbeat:Connect(function()
				CurrentCamera.FieldOfView = 120
			end)
		else
			CameraModificationCon:Disconnect()
			CurrentCamera.FieldOfView = oldFOV
		end
	end,
})

LongJump = Motion.NewButton({
	Name = "LongJump",
	Keybind = Enum.KeyCode.J,
	Function = function(callback)
		if callback then
			if LongJumpMethod.Option == "Gravity" then
				workspace.Gravity = 5
				task.delay(0.01, function()
					Humanoid:ChangeState(3)
				end)
			end
		else
			workspace.Gravity = 196.2
			task.delay(0.1, function()
				PrimaryPart.Velocity = Vector3.zero
			end)
		end
	end,
})
LongJumpMethod = LongJump.NewPicker({
	Name = "Mode",
	Options = {"Gravity"}
})

TexturePack = Visuals.NewButton({
	Name = "TexturePack",
	Function = function(callback)
		local func
		if callback then
			task.spawn(function()
				local objs = game:GetObjects("rbxassetid://14033898270")
				local import = objs[1]
				import.Parent = ReplicatedStorage
				local index = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},	
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
					{
						name = "wood_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-190), math.rad(-95)),
						model = import:WaitForChild("Wood_Pickaxe"),
					},
					{
						name = "stone_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-190), math.rad(-95)),
						model = import:WaitForChild("Stone_Pickaxe"),
					},
					{
						name = "iron_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-190), math.rad(-95)),
						model = import:WaitForChild("Iron_Pickaxe"),
					},
					{
						name = "diamond_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(80), math.rad(-95)),
						model = import:WaitForChild("Diamond_Pickaxe"),
					},	
					{
						name = "wood_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
						model = import:WaitForChild("Wood_Axe"),
					},	
					{
						name = "stone_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
						model = import:WaitForChild("Stone_Axe"),
					},	
					{
						name = "iron_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
						model = import:WaitForChild("Iron_Axe"),
					},	
					{
						name = "diamond_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(-95)),
						model = import:WaitForChild("Diamond_Axe"),
					},	
					{
						name = "fireball",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Fireball"),
					},	
					{
						name = "telepearl",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Telepearl"),
					},
				}
				func = CurrentCamera.Viewmodel.ChildAdded:Connect(function(tool)	
					if not tool:IsA("Accessory") then return end	
					for _, v in ipairs(index) do	
						if v.name == tool.Name then		
							for _, part in ipairs(tool:GetDescendants()) do
								if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then				
									part.Transparency = 1
								end			
							end		
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							model.Parent = tool			
							local weld = Instance.new("WeldConstraint", model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")			
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)			
							for _, part in ipairs(tool2:GetDescendants()) do
								if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then				
									part.Transparency = 1				
								end			
							end			
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							if v.name:match("sword") or v.name:match("blade") then
								model2.CFrame *= CFrame.new(.5, 0, -1.1) - Vector3.new(0, 0, -.3)
							elseif v.name:match("axe") and not v.name:match("pickaxe") and v.name:match("diamond") then
								model2.CFrame *= CFrame.new(.08, 0, -1.1) - Vector3.new(0, 0, -.9)
							elseif v.name:match("axe") and not v.name:match("pickaxe") and not v.name:match("diamond") then
								model2.CFrame *= CFrame.new(-.2, 0, -2.4) + Vector3.new(0, 0, 2.12)
							else
								model2.CFrame *= CFrame.new(.2, 0, -.09)
							end
							model2.Parent = tool2
							local weld2 = Instance.new("WeldConstraint", model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")
						end
					end
				end)
			end)
		else
			pcall(function()
				func:Disconnect()
			end)
		end
	end,
})
TxtpackMode = TexturePack.NewPicker({
	Name = "Mode",
	Options = {"64x"}
})

local chatMessages = {
	Polaris = {
		"When life gives you lemons, get Venus",
		"I heard using Venus lets you win every HVH",
		"Get Venus today",
		"Venus takes 5 seconds to get",
		"Venus > Vxpe",
		"Learn some real fighting skills with Venus today",
		"I'm not cheating, just good at bridging.",	
        	"Venus > Cocosploit",
	},
	UWU = {
		"Nya~~ Get Venus today :3",
		"Please get Venus.. UwU",
		"I NEED Venus inside me.",
		"I love getting hit by Venus from behind >-<",
		--"Go to .gg/WmSzPSDU to get Venus..~",
		--"Come get me and maybe you'll get Venus.. x-x",
		"Venus > Protosense~ (its a logger :3)",
        "Venus > Cocosploit~ (the scri- uwu~pt skidded off of Venus :3)"
	},
	TheHood = {
		"I'm from the hood yo, go get Venus today.",
		"Im gonna commit a shoot-by if you don't get Venus.",
		"The Hood uses Venus to win every fight.",
		"Venus runs the Hood up in here.",
		"Making bank using Venus in the Hood, everyone listens to me."
	}
}

Chatspammer = Misc.NewButton({
	Name = "Chatspammer",
	Function = function(callback)
		if callback then
			repeat
				local chatTable = chatMessages[ChatSpammerMode.Option]
				local newchat = chatTable[math.random(1, #chatTable)]
				Utilities.newChat(newchat)
				task.wait(3.5)
			until not Chatspammer.Enabled
		end
	end,
})
ChatSpammerMode = Chatspammer.NewPicker({
	Name = "Mode",
	Options = {"Venus", "UWU", "TheHood"}
})

local DisablerConnection
local lplr = game.Players.LocalPlayer
local humanoid = lplr.Character and lplr.Character:FindFirstChildOfClass("Humanoid")
local Disabler = Exploit.NewButton({
    Name = "Disabler",
    Function = function(callback)
        if callback then
            task.spawn(function()
                DisablerConnection = RunService.Heartbeat:Connect(function()
                    if humanoid then
                        if DisablerMethod.Option == "SemiFloat1" then
                            humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
                            humanoid:ChangeState(Enum.HumanoidStateType.Running)
                        elseif DisablerMethod.Option == "SemiFloat2" then
                            humanoid:ChangeState(Enum.HumanoidStateType.Seated)
                            humanoid:ChangeState(Enum.HumanoidStateType.Running)
                            humanoid:ChangeState(Enum.HumanoidStateType.Climbing)
                            humanoid:ChangeState(Enum.HumanoidStateType.Running)
                        end
                    end
                end)
            end)
        else
            pcall(function()
                if DisablerConnection then
                    DisablerConnection:Disconnect()
                    DisablerConnection = nil
                end
            end)
        end
    end,
})
DisablerMethod = Disabler.NewPicker({
    Name = "Method",
    Options = {"SemiFloat1", "SemiFloat2"}
})

local TrollageConnection
RemoteTrollage = Exploit.NewButton({
	Name = "RemoteTrollage",
	Function = function(callback)
		if callback then
            task.spawn(function()
                TrollageConnection = RunService.Heartbeat:Connect(function()
                    task.wait()
                    if DragonSound.Enabled then
                        game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.DragonBreath:FireServer(" ")
                    end
                    if PartyPopper.Enabled then
                        game:GetService("ReplicatedStorage")["events-@easy-games/game-core:shared/game-core-networking@getEvents.Events"].useAbility:FireServer("PARTY_POPPER")
                    end
                    if YuziDash.Enabled then
                        game:GetService("ReplicatedStorage"):FindFirstChild("events-@easy-games/game-core:shared/game-core-networking@getEvents.Events").useAbility:FireServer("dash")
                    end
                end)
            end)
		else
            pcall(function()
                if TrollageConnection then
                    TrollageConnection:Disconnect()
                    TrollageConnection = nil
                end
            end)
        end
	end,
})
DragonSound = RemoteTrollage.NewToggle({
	Name = "DragonBreath",
	Function = function() end
})
PartyPopper = RemoteTrollage.NewToggle({
	Name = "PartyPopper",
	Function = function() end
})
YuziDash = RemoteTrollage.NewToggle({
	Name = "YuziDash",
	Function = function() end
})

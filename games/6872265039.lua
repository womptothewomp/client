repeat task.wait() until game:IsLoaded()

local library = {}
local spawnConnections = {}
local utils = {}

local Polaris_user = "Test"
local hurttime = 0
local PolarisRelease = "1.03 Beta"

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
HttpService = game:GetService("HttpService")

local config = {
	Buttons = {},
	Toggles = {},
	Options = {},
	Keybinds = {}
}
local function saveConfig()
	local encrypt = HttpService:JSONEncode(config); if isfile("Polaris/config/" .. game.PlaceId .. ".json") then delfile("Polaris/config/" .. game.PlaceId .. ".json"); end
	writefile("Polaris/config/"..game.PlaceId..".json",encrypt)
end

if not isfile("Polaris") then
	makefolder("Polaris")
	makefolder("Polaris/games")
	makefolder("Polaris/config")
	saveConfig()
end

local function loadConfig()
	local decrypt = HttpService:JSONDecode(readfile("Polaris/config/" .. game.PlaceId .. ".json"))
	config = decrypt
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

		item.BackgroundTransparency = library.Array.Background and 0.3 or 1

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

cmdSystem.RegisterCommand("bind",function(args)
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

local function getNearestPlayer(range)
	local nearest
	local nearestDist = 9e9
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

local funAnimations = {
	PLAYER_VACUUM_SUCK = "rbxassetid://9671620809",
	WINTER_BOSS_SPAWN = "rbxassetid://11843861791",
	GLUE_TRAP_FLYING = "rbxassetid://11466075174",
	VOID_DRAGON_TRANSFORM = "rbxassetid://10967424821",
	SIT_ON_DODO_BIRD = "http://www.roblox.com/asset/?id=2506281703",
	DODO_BIRD_FALL = "rbxassetid://7617326953",
	SWORD_SWING = "rbxassetid://7234367412",
}

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

local HUDScreen = Instance.new("ScreenGui",PlayerGui)
HUDScreen.ResetOnSpawn = false

local HUDS = {}

HUDS[1] = function()
	local text = "Polaris V2"
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
	local text = "Polaris"

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
				if HUDStyle.Option == "Polaris 1" then
					HUDS[1]()
				elseif HUDStyle.Option == "Polaris 2" then
					HUDS[2]()
				end
				library.Array.BackgroundTransparency = 0.3
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
HUDStyle = HUD.NewPicker({
	Name = "Logo Style",
	Options = {"Polaris 1", "Polaris 2"}
})
ArrayStyle = HUD.NewPicker({
	Name = "Array Style",
	Options = {"Normal", "Gay","Space", "Christmas", "MagicPurple"}
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

				if ArrayStyle.Option == "MagicPurple" then
					v.TextColor3 = (v.TextColor3 == Color3.fromRGB(155,0,255) and Color3.fromRGB(255,100,255) or Color3.fromRGB(155,0,255))
				end
			end
		end
	until false
end)

local flycon
Fly = Motion.NewButton({
	Name = "Fly",
	Keybind = Enum.KeyCode.R,
	Function = function(callback)
		if callback then
			flycon = RunService.Heartbeat:Connect(function()
				local velo = PrimaryPart.Velocity
				PrimaryPart.Velocity = Vector3.new(velo.X, 2.04, velo.Z)

				if UserInputService:IsKeyDown("Space") then
					PrimaryPart.Velocity = Vector3.new(velo.X, 44, velo.Z)
				end
				if UserInputService:IsKeyDown("LeftShift") then
					PrimaryPart.Velocity = Vector3.new(velo.X, -44, velo.Z)
				end
			end)
		else
			pcall(function()
				flycon:Disconnect()
			end)
		end
	end,
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
					statsxd.Text = "FPS: "..tostring(fpscount).. " \n \n Polaris User: "..Polaris_user.. " \n \n Network: Bedwars.com \n \n Game: Bedwars \n \n Hurttime: "..hurttime
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
					Humanoid.WalkSpeed = 20
					speed = Character:GetAttribute("SpeedBoost") and 0.1 or 0.017
					PrimaryPart.CFrame += (speed * dir)
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
	Options = {"Bedwars"}
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
			PrimaryPart.Velocity = Vector3.new(0, 25, 0)
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
			if LongJumpMethod.Option == "Boost" then
				TweenService:Create(PrimaryPart, TweenInfo.new(2.1), {
					CFrame = PrimaryPart.CFrame + PrimaryPart.CFrame.LookVector * 50 + Vector3.new(0, 5, 0)
				}):Play()
				task.delay(0.75, function()
					LongJump.ToggleButton(false)
				end)
			end
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
	Options = {"Boost", "Gravity"}
})

local chatMessages = {
	Polaris = {
		"When life gives you lemons, get Polaris",
		"I heard using Polaris lets you win every HVH",
		"Get Polaris today",
		"Polaris takes 5 seconds to use and it lets you win every match!",
		"Polaris > Protosense",
		"Learn some real fighting skills with Polaris today",
		"I'm not cheating, just good at bridging.",	
		"Join .gg/WmSzPSDU 4 Polaris."
	},
	UWU = {
		"Nya~~ Get Polaris today :3",
		"Please get Polaris.. UwU",
		"I NEED Polaris inside me.",
		"I love getting hit by Polaris from behind >-<",
		--"Go to .gg/WmSzPSDU to get Polaris..~",
		"Come get me and maybe you'll get Polaris.. x-x",
		"Polaris > Protosense~ (its a logger :3)"
	},
	TheHood = {
		"I'm from the hood yo, go get Polaris today.",
		"Im gonna commit a shoot-by if you don't get Polaris.",
		"The Hood uses Polaris to win every fight.",
		"Polaris runs the Hood up in here.",
		"Making bank using Polaris in the Hood, everyone listens to me."
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
	Options = {"Polaris", "UWU", "TheHood"}
})

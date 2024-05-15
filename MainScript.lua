local gameId = game.PlaceId

local config = {
	Buttons = {},
	Toggles = {},
	Options = {},
	Keybinds = {}
}

local function saveConfig()
	local encrypt = game:GetService("HttpService"):JSONEncode(config)
	if isfile("Aeolus/configs/"..gameId) then
		delfile("Aeolus/configs/"..gameId)
	end
	writefile("Aeolus/configs/"..gameId,encrypt)
end

local function loadConfig()
	local decrypt = game:GetService("HttpService"):JSONDecode(readfile("Aeolus/configs/"..gameId))
	config = decrypt
end

if not isfile("Aeolus/configs") then
	makefolder("Aeolus/configs")
	saveConfig()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local UserInputService = game:GetService("UserInputService")

local lplr = Players.LocalPlayer
local GuiLibrary

local themes = {
	CandyCane = {
		Main = Color3.fromRGB(230, 0, 4),
		Accent = Color3.fromRGB(255, 255, 255),
		Gui = Color3.fromRGB(0, 0, 0),
		Gui2 = Color3.fromRGB(255, 255, 255),
	},
	Dark = {
		Main = Color3.fromRGB(255, 255, 255),
		Accent = Color3.fromRGB(0, 0, 0),
		Gui = Color3.fromRGB(13, 13, 13),
		Gui2 = Color3.fromRGB(115, 115, 115),
	},
	Green = {
		Main = Color3.fromRGB(0, 255, 21),
		Accent = Color3.fromRGB(0, 121, 24),
		Gui = Color3.fromRGB(13, 13, 13),
		Gui2 = Color3.fromRGB(115, 115, 115),
	},
	MagicPurple = {
		Main = Color3.fromRGB(65, 32, 60),
		Accent = Color3.fromRGB(152, 28, 186),
		Gui = Color3.fromRGB(30, 30, 30),
		Gui2 = Color3.fromRGB(255, 255, 255),
	},
	CottonCandy = {
		Main = Color3.fromRGB(255, 124, 233),
		Accent = Color3.fromRGB(48, 113, 154),
		Gui = Color3.fromRGB(0, 0, 0),
		Gui2 = Color3.fromRGB(255, 255, 255),
	},
	Steel = {
		Main = Color3.fromRGB(77, 77, 77),
		Accent = Color3.fromRGB(255, 255, 255),
		Gui = Color3.fromRGB(0, 0, 0),
		Gui2 = Color3.fromRGB(255, 255, 255),
	},
}

GuiLibrary = {
	MainInstance = Instance.new("ScreenGui",lplr.PlayerGui),
	Funcs = {
		Round = function(item, radius)
			local round = Instance.new("UICorner",item)
			round.CornerRadius = UDim.new(radius,0)
		end,
		CompensateLeftText = function(s)
			return "  "..s
		end,
		GetWindowInstance = function(s)
			for i,v in pairs(GuiLibrary.WindowInstances) do
				if i == s then
					return v
				end
			end
		end,
	},
	WindowInstanceCount = 0,
	ColorTheme = themes.Dark,
	WindowInstances = {},
	ToggledButtonInstances = {},
}

local lastModuleToggledTick = tick()

GuiLibrary.MainInstance.ResetOnSpawn = false
GuiLibrary.MainInstance.IgnoreGuiInset = true

local RunLoops = {
	Hearbeat = {},
}

function RunLoops:BindToHeartbeat(n,c)
	RunLoops.Hearbeat[n] = RunService.Heartbeat:Connect(c)
end

function RunLoops:UnbindFromHeartbeat(n)
	RunLoops.Hearbeat[n]:Disconnect()
end

local totalButtons = 0
function GuiLibrary:CreateWindowInstance(tab)
	local name = tab.Name or ""

	local top = Instance.new("TextLabel",GuiLibrary.MainInstance)
	top.Text = name
	top.TextColor3 = Color3.fromRGB(255,255,255)
	top.Size = UDim2.fromScale(0.12,0.035)
	top.Position = UDim2.fromScale(0.04 + (0.14 * GuiLibrary.WindowInstanceCount), 0.15)
	top.BackgroundColor3 = GuiLibrary.ColorTheme.Gui
	top.TextSize = 11
	local topFlat = Instance.new("Frame",top)
	topFlat.BackgroundColor3 = GuiLibrary.ColorTheme.Gui
	topFlat.Size = UDim2.fromScale(1,0.18)
	topFlat.Position = UDim2.fromScale(0,0.82)
	topFlat.BorderSizePixel = 0

	local moduleFrame = Instance.new("Frame",top)
	moduleFrame.Size = UDim2.fromScale(1,20)
	moduleFrame.Position = UDim2.fromScale(0,1)
	moduleFrame.Transparency = 1
	local listLayout = Instance.new("UIListLayout",moduleFrame)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder

	GuiLibrary.Funcs.Round(top,0.25)

	GuiLibrary.WindowInstanceCount += 1

	local buttonIndex = 0

	local lastButton

	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,GuiLibrary.ColorTheme.Main),ColorSequenceKeypoint.new(1,GuiLibrary.ColorTheme.Accent),ColorSequenceKeypoint.new(1,GuiLibrary.ColorTheme.Accent)})
	local gradient2 = Instance.new("UIGradient")
	gradient2.Color = gradient.Color

	local bottomRound = Instance.new("Frame",moduleFrame)
	bottomRound.LayoutOrder = 10000
	bottomRound.BackgroundColor3 = Color3.fromRGB(255,255,255)
	bottomRound.Size = UDim2.fromScale(1,0.02)

	GuiLibrary.Funcs.Round(bottomRound,1)
	local bottomFlat = Instance.new("Frame",bottomRound)
	bottomFlat.BackgroundColor3 = Color3.fromRGB(255,255,255)
	bottomFlat.Size = UDim2.fromScale(1,-0.4)
	bottomFlat.Position = UDim2.fromScale(0,0.25)
	bottomFlat.BorderSizePixel = 0

	UserInputService.InputBegan:Connect(function(k)
		if k.KeyCode == Enum.KeyCode.RightShift then
			top.Visible = not top.Visible
		end
	end)

	GuiLibrary.WindowInstances[name] = {
		CreateModuleButton = function(tab2)
			buttonIndex += 1
			totalButtons += 1

			local KeyBind = "None"
			local hoverText = tab2.HoverText or ""

			local button = Instance.new("TextButton",moduleFrame)
			button.Size = UDim2.fromScale(1,0.047)
			button.BorderSizePixel = 0
			button.BackgroundColor3 = Color3.fromRGB(30,30,30)
			button.TextColor3 = Color3.fromRGB(255,255,255)
			button.Text = tab2.Name
			button.TextSize = 11
			button.LayoutOrder = totalButtons

			local hoverTextInstance = Instance.new("TextLabel",GuiLibrary.MainInstance)

			if hoverText ~= "" then
				hoverTextInstance.Text = hoverText
				hoverTextInstance.TextColor3 = Color3.fromRGB(255, 255, 255)
				hoverTextInstance.BackgroundColor3 = Color3.fromRGB(30,30,30)
				hoverTextInstance.TextSize = 10
				hoverTextInstance.Size = UDim2.new(0,TextService:GetTextSize("  "..hoverText.."  ",10,hoverTextInstance.Font,Vector2.new(0,0)).X,0.04,0)
				hoverTextInstance.Transparency = 1
				GuiLibrary.Funcs.Round(hoverTextInstance, 0.2)
				local mouseHovered = false

				button.MouseEnter:Connect(function()
					mouseHovered = true
					TweenService:Create(hoverTextInstance,TweenInfo.new(0.4),{
						Transparency = 0
					}):Play()
					task.spawn(function()
						repeat task.wait()
							local mouseLocation = UserInputService:GetMouseLocation()
							hoverTextInstance.Position = UDim2.new(0.02,mouseLocation.X,0,mouseLocation.Y)
						until not mouseHovered
					end)
				end)
				button.MouseLeave:Connect(function()
					mouseHovered = false
					TweenService:Create(hoverTextInstance,TweenInfo.new(0.4),{
						Transparency = 1
					}):Play()
				end)
			end

			local dropdown = Instance.new("ScrollingFrame", button)
			dropdown.Position = UDim2.fromScale(0, 0.98)
			dropdown.Size = UDim2.fromScale(1, 0)
			dropdown.BackgroundTransparency = 1
			dropdown.Visible = false
			dropdown.ScrollBarThickness = 0
			dropdown.BorderSizePixel = 0

			local keybind = Instance.new("TextBox", dropdown)
			keybind.Position = UDim2.fromScale(0,0)
			keybind.Size = UDim2.fromScale(1,0.1)
			keybind.Text = "KeyBind: ".. KeyBind
			keybind.TextSize = 9
			keybind.TextColor3 = Color3.fromRGB(255,255,255)
			keybind.BackgroundColor3 = Color3.fromRGB(30,30,30)

			keybind.FocusLost:Connect(function()
				local curkeybind = keybind.Text
				KeyBind = Enum.KeyCode[curkeybind:upper()]

				task.delay(0.2,function()
					keybind.Text = "KeyBind: ".. curkeybind:upper()
				end)
			end)

			if config.Buttons[tab2.Name] == nil then
				config.Buttons[tab2.Name] = {
					Enabled = false,
				}
			else
				saveConfig()
			end

			if config.Keybinds[tab2.Name] == nil then
				config.Keybinds[tab2.Name] = tostring(KeyBind):split(".")[3] or "Unknown"
			end

			local dropdownList = Instance.new("UIListLayout",dropdown)

			local btnTab
			local gradientc = nil
			btnTab = {
				Enabled = false,
				ToggleButton = function(state)
					lastModuleToggledTick = tick()
					if state == nil then state = not btnTab.Enabled end

					btnTab.Enabled = state

					if state then
						gradientc = Instance.new("UIGradient",button)
						gradientc.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,GuiLibrary.ColorTheme.Main),ColorSequenceKeypoint.new(1,GuiLibrary.ColorTheme.Accent)})

						if lastButton == name then
							gradient.Color = gradientc.Color
							gradient2.Color = gradientc.Color
							bottomRound.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
							bottomFlat.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						end

					else
						if gradientc then
							gradientc:Destroy()
						end

						if lastButton == name then
							bottomRound.BackgroundColor3 = Color3.fromRGB(30,30,30)
							bottomFlat.BackgroundColor3 = Color3.fromRGB(30,30,30)
							pcall(function()								
								gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,GuiLibrary.ColorTheme.Main),ColorSequenceKeypoint.new(0,Color3.fromRGB(30,30,30))})
							end)
							gradient2.Color = gradient.Color
						end
					end
					tab2.Function(state)
					config.Buttons[tab2.Name].Enabled = btnTab.Enabled
					saveConfig()
				end,
				ToggleDropdownState = function()
					for i,v in pairs(moduleFrame:GetChildren()) do
						if v:IsA("UIListLayout") then continue end
						v.Visible = not v.Visible
					end
					button.Visible = true
					dropdown.Visible = not dropdown.Visible

					if dropdown.Visible then
						TweenService:Create(dropdown,TweenInfo.new(0.3),{
							Size = UDim2.fromScale(1, 10)
						}):Play()
					else
						dropdown.Size = UDim2.fromScale(1,0)
					end
				end,
				CreateToggleButton = function(tab3)
					local returnTable = {}
					returnTable.Enabled = false

					if config.Toggles[tab3.Name.."_"..tab2.Name] == nil then 
						config.Toggles[tab3.Name.."_"..tab2.Name] = {Enabled = false}
					end

					local newname = Instance.new("TextLabel", dropdown)
					newname.Size = UDim2.fromScale(1,0.1)
					newname.BorderSizePixel = 0
					newname.BackgroundColor3 = Color3.fromRGB(30,30,30)
					newname.TextColor3 = Color3.fromRGB(255,255,255)
					newname.Text = GuiLibrary.Funcs.CompensateLeftText(tab3.Name)
					newname.TextXAlignment = Enum.TextXAlignment.Left
					newname.TextSize = 8

					local newbutton = Instance.new("TextButton", newname)
					newbutton.Position = UDim2.fromScale(0.75, 0.15)
					newbutton.Size = UDim2.fromScale(0.2, 0.7)
					newbutton.BorderSizePixel = 0
					newbutton.BackgroundColor3 = Color3.fromRGB(50,50,50)
					newbutton.Text = ""
					GuiLibrary.Funcs.Round(newbutton, 1)

					local newdot = Instance.new("Frame", newbutton)
					newdot.Position = UDim2.fromScale(0.12, 0.25)
					newdot.Size = UDim2.fromScale(0.3, 0.55)
					newdot.BorderSizePixel = 0
					newdot.BackgroundColor3 = GuiLibrary.ColorTheme.Gui2
					GuiLibrary.Funcs.Round(newdot, 10)

					returnTable.ToggleButton = function()					
						returnTable.Enabled = not returnTable.Enabled
						TweenService:Create(newdot, TweenInfo.new(0.75), {
							Position = (returnTable.Enabled and UDim2.fromScale(0.55, 0.25) or UDim2.fromScale(0.12, 0.25))
						}):Play()
						TweenService:Create(newbutton, TweenInfo.new(0.75), {
							BackgroundColor3 = (returnTable.Enabled and GuiLibrary.ColorTheme.Main or Color3.fromRGB(50,50,50))
						}):Play()
						if tab3.Function then
							task.spawn(function()
								tab3.Function(returnTable.Enabled)
							end)
						end
						config.Toggles[tab3.Name.."_"..tab2.Name].Enabled = returnTable.Enabled
						saveConfig()
					end

					newbutton.MouseButton1Down:Connect(function()
						returnTable.ToggleButton()
					end)

					return returnTable
				end,
				CreatePickerInstance = function(tab4)
					local returnTable

					if config.Options[tab4.Name.."_"..tab2.Name] == nil then
						config.Options[tab4.Name.."_"..tab2.Name] = {Option = tab4.Options[1]}
					end

					local newtextlabel = Instance.new("TextLabel", dropdown)
					newtextlabel.Size = UDim2.fromScale(1,0.1)
					newtextlabel.BorderSizePixel = 0
					newtextlabel.BackgroundColor3 = Color3.fromRGB(30,30,30)
					newtextlabel.TextColor3 = Color3.fromRGB(255,255,255)
					newtextlabel.Text = GuiLibrary.Funcs.CompensateLeftText(tab4.Name)..": "
					newtextlabel.TextXAlignment = Enum.TextXAlignment.Left
					newtextlabel.TextSize = 8

					local newbutton = Instance.new("TextButton", newtextlabel)
					newbutton.Position = UDim2.fromScale(0.5, 0)
					newbutton.Size = UDim2.fromScale(0.5, 1)
					newbutton.BackgroundTransparency = 1
					newbutton.TextXAlignment = Enum.TextXAlignment.Right
					newbutton.Text = tab4.Options[1].." "
					newbutton.TextColor3 = Color3.fromRGB(150,150,150)


					local index = 1
					returnTable = {
						Option = tab4.Options[index],
						SelectOption = function(v)
							if index == #tab4.Options and v == 'Forwards' then
								index = 0
							end

							if index == 0 and v == 'Backwards' then
								index = #tab4.Options + 1
							end

							if v == 'Forwards' then
								index += 1
							end
							if v == 'Backwards' then
								index -= 1
							end
							returnTable.Option = tab4.Options[index]
							config.Options[tab4.Name.."_"..tab2.Name].Option = tab4.Options[index]
							saveConfig()
						end,
					}

					newbutton.MouseButton1Down:Connect(function()
						returnTable.SelectOption('Forwards')
						newbutton.Text = returnTable.Option.." "
					end)

					newbutton.MouseButton2Down:Connect(function()
						returnTable.SelectOption('Backwards')
						newbutton.Text = returnTable.Option.." "
					end)

					return returnTable
				end,
			}

			button.MouseButton1Down:Connect(function()
				btnTab.ToggleButton()
			end)

			button.MouseButton2Down:Connect(function()
				btnTab.ToggleDropdownState()
			end)

			game.UserInputService.InputBegan:Connect(function(KEY, GPE)
				if GPE then return end
				if KeyBind == (nil or "None") then return end
				if KEY.KeyCode == KeyBind then
					btnTab.ToggleButton()
				end
			end)

			lastButton = name

			task.spawn(function()
				repeat task.wait()
					pcall(function()
						TweenService:Create(button, TweenInfo.new(0.75), {
							BackgroundColor3 = (btnTab.Enabled and Color3.fromRGB(255,255,255) or Color3.fromRGB(30,30,30)),	
							TextColor3 = (btnTab.Enabled and Color3.fromRGB(83, 83, 83) or Color3.fromRGB(255,255,255))
						}):Play()
						gradientc.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,GuiLibrary.ColorTheme.Main),ColorSequenceKeypoint.new(1,GuiLibrary.ColorTheme.Accent)})
					end)
					pcall(function()
						local usingCapitials = InterfaceCapitals.Enabled
						local usingSpaces = InterfaceSpaces.Enabled

						if usingSpaces then
							button.Text = tab2.Name
						else
							button.Text = button.Text:gsub(" ","")
						end

						if usingCapitials then
							button.Text = button.Text:gsub("^%l", string.upper)
						else
							button.Text = button.Text:lower()
						end
					end)
				until false 
			end)

			if config.Buttons[tab2.Name].Enabled then
				btnTab.ToggleButton(true)
			end

			return btnTab
		end,
	}

	task.spawn(function()
		repeat task.wait()
			bottomRound.BackgroundColor3 = GuiLibrary.ColorTheme.Gui
			bottomFlat.BackgroundColor3 = GuiLibrary.ColorTheme.Gui
			gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(30,30,30)),ColorSequenceKeypoint.new(1,Color3.fromRGB(30,30,30))})
			gradient2.Color = gradient.Color
		until false 
	end)

	gradient.Parent = bottomRound
	gradient2.Parent = bottomFlat
end

GuiLibrary:CreateWindowInstance({Name = "Combat"})
GuiLibrary:CreateWindowInstance({Name = "Movement"})
GuiLibrary:CreateWindowInstance({Name = "Player"})
GuiLibrary:CreateWindowInstance({Name = "Render"})
GuiLibrary:CreateWindowInstance({Name = "Other"})

local CombatWindow = GuiLibrary.Funcs.GetWindowInstance("Combat")
local RenderWindow = GuiLibrary.Funcs.GetWindowInstance("Render")
local MovementWindow = GuiLibrary.Funcs.GetWindowInstance("Movement")
local PlayerWindow = GuiLibrary.Funcs.GetWindowInstance("Player")
local OtherWindow = GuiLibrary.Funcs.GetWindowInstance("Other")

local onGround = lplr.Character.Humanoid.FloorMaterial ~= Enum.Material.Air
local isMoving = UserInputService:IsKeyDown("W") or UserInputService:IsKeyDown("A") or UserInputService:IsKeyDown("S") or UserInputService:IsKeyDown("D") or UserInputService:IsKeyDown("Space")

local Camera = workspace.CurrentCamera
local Lighting = game.Lighting

local Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/RunAccount1/AeolusV2/main/Bedwars/Functions.lua", true))()
local Utilities = loadstring(game:HttpGet("https://raw.githubusercontent.com/RunAccount1/AeolusV2/main/Libraries/utils.lua", true))()
local Images = loadstring(game:HttpGet("https://raw.githubusercontent.com/RunAccount1/AeolusV2/main/MainTables/Images.lua", true))
local AmbienceColors = loadstring(game:HttpGet("https://raw.githubusercontent.com/RunAccount1/AeolusV2/main/MainTables/AmbienceColors.lua", true))
local getRemote = Functions.getRemote

local onGround = lplr.Character.Humanoid.FloorMaterial ~= Enum.Material.Air
local isMoving = UserInputService:IsKeyDown("W") or UserInputService:IsKeyDown("A") or UserInputService:IsKeyDown("S") or UserInputService:IsKeyDown("D") or UserInputService:IsKeyDown("Space")

local airTicks = 0
local Ticks = 0

lplr.CharacterAdded:Connect(function(char)
	task.wait(1)
	task.spawn(function()
		repeat
			onGround = lplr.Character.Humanoid.FloorMaterial ~= Enum.Material.Air
			isMoving = UserInputService:IsKeyDown("W") or UserInputService:IsKeyDown("A") or UserInputService:IsKeyDown("S") or UserInputService:IsKeyDown("D") or UserInputService:IsKeyDown("Space")

			Ticks += 1
			if onGround then
				airTicks = 0
			else
				airTicks += 1
			end
			task.wait()
		until char.Humanoid.Health < 0.1
	end)
end)

getNearestPlayer = function(range)
	local nearest
	local nearestDist = 9e9
	for i,v in pairs(game.Players:GetPlayers()) do
		pcall(function()
			if v == lplr or v.Team == lplr.Team then return end
			if v.Character.Humanoid.health > 0 and (v.Character.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude < nearestDist and (v.Character.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude <= range then
				nearest = v
				nearestDist = (v.Character.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude
			end
		end)
	end
	return
end


local ImageTable = {}
local AnimationsTab = {}
local AmbienceOption = {}

ImageTable = {
	"Sus",
	"Damc",
	"Springs",
	"Xylex",
	"Alsploit",
	"Matrix",
	"Covid",
	"Space",
	"Windows",
	"Trol",
	"Cat",
	"Furry",
}
AmbienceOption = {
	'Purple',
	'Blue',
	'Green',
	'Yellow',
	'Orange',
	'Red',
	'Brown',
}
AnimationsTab = {
	"Smooth",
	"Spin",
	"Reverse Spin",
	"Swoosh",
	"Swang",
	"Zoom",
	"Classic",
	"Other Spin",
	"Corrupt",
}

Speed = MovementWindow.CreateModuleButton({
	Name = "speed",
	HoverText = "Increase Movement Speed",
	Function = function(callback)
		if callback then
			repeat

				local Velocity = lplr.Character.PrimaryPart.Velocity
				local Direction = lplr.Character.Humanoid.MoveDirection
				local WalkSpeedMaxSpeed = 23.4
				local VelocityMaxSpeed = 30
				local CFrameMaxSpeed = 0.05

				if DamageBoost.Enabled and damageTicks < 50 then
					WalkSpeedMaxSpeed = 40
					VelocityMaxSpeed = (lplr.Character:GetAttribute("SpeedBoost") and 50 or 40)
					CFrameMaxSpeed = (lplr.Character:GetAttribute("SpeedBoost") and 0.36 or 0.32)
				else
					WalkSpeedMaxSpeed = (lplr.Character:GetAttribute("SpeedBoost") and 35 or 23.4)
					VelocityMaxSpeed = (lplr.Character:GetAttribute("SpeedBoost") and 40 or 30)
					CFrameMaxSpeed = (lplr.Character:GetAttribute("SpeedBoost") and 0.07 or 0.03)
				end

				if SpeedMode.Option == "BedwarsGround" then
					if onGround then
						lplr.Character.Humanoid.WalkSpeed = WalkSpeedMaxSpeed
					else
						lplr.Character.Humanoid.WalkSpeed = 7
					end
				end

				if SpeedMode.Option == "BedwarsLow" then
					lplr.Character.Humanoid.WalkSpeed = WalkSpeedMaxSpeed
					if onGround then
						lplr.Character.PrimaryPart.Velocity = Vector3.new(Velocity.X, 25, Velocity.Z)
					end
					if airTicks == 6 then
						lplr.Character.PrimaryPart.Velocity = Vector3.new(Velocity.X, 0, Velocity.Z)
					end
				end

				if SpeedMode.Option == "Custom" then

					-- on ground
					if onGround then
						if JumpMode.Option == "Normal" then
							lplr.Character.Humanoid:ChangeState(3)
						end
						if JumpMode.Option == "Velocity" then
							lplr.Character.PrimaryPart.Velocity = Vector3.new(Velocity.X, 35, Velocity.Z)
						end
					end

					-- off ground
					if not onGround then
						if SpeedFastFall.Enabled and airTicks == 10 then
							lplr.Character.PrimaryPart.Velocity = Vector3.new(Velocity.X, -20, Velocity.Z)
						end
					end

					if CustomSpeedMode.Option == "WalkSpeed" then
						lplr.Character.Humanoid.WalkSpeed = WalkSpeedMaxSpeed
					end
					if CustomSpeedMode.Option == "Velocity" then
						local X = (Direction * VelocityMaxSpeed).X
						local Z = (Direction * VelocityMaxSpeed).Z

						lplr.Character.PrimaryPart.Velocity = Vector3.new(X,lplr.Character.PrimaryPart.Velocity.Y,Z)
					end
					if CustomSpeedMode.Option == "CFrame" then
						lplr.Character.PrimaryPart.CFrame += (CFrameMaxSpeed * Direction)
					end
				end
				task.wait()
			until not Speed.Enabled
			lplr.Character.Humanoid.WalkSpeed = 16
		end
	end,
})
SpeedMode = Speed.CreatePickerInstance({
	Name = "Bypass Mode",
	Options = {"BedwarsGround", "BedwarsLow", "Custom"}
})
JumpMode = Speed.CreatePickerInstance({
	Name = "Jump Mode",
	Options = {"None", "Normal", "Velocity"}
})
SpeedFastFall = Speed.CreateToggleButton({
	Name = "FastFall"
})
OnGroundBoost = Speed.CreateToggleButton({
	Name = "Ground Boost"
})
DamageBoost = Speed.CreateToggleButton({
	Name = "Damage Boost"
})
CustomSpeedMode = Speed.CreatePickerInstance({
	Name = "Speed Mode",
	Options = {"WalkSpeed", "Velocity", "CFrame"}
})
local InterfaceInstances = {}
local LogoThemes = {}

Disabler = OtherWindow.CreateModuleButton({
	Name = "disabler",
	HoverText = "attempts to disable the anticheat",
	Function = function(callback)
		if callback then
			local ticks = 0
			RunLoops:BindToHeartbeat("Disabler",function(delta)

				if DisablerMode.Option == "State" then
					if ticks > 10 then
						ticks = 0
						lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
						lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
					end
				elseif DisablerMode.Option == "State2" then
					lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Seated)
					lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
					lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Climbing)
					lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
				elseif DisablerMode.Option == "Clip" then
					if onGround then
						lplr.Character.PrimaryPart.CFrame -= Vector3.new(0,0.1,0)
					end
				end

				ticks += 1
			end)
		else
			RunLoops:UnbindFromHeartbeat("Disabler")
		end
	end,
})

DisablerMode = Disabler.CreatePickerInstance({
	Name = "Mode",
	Options = {"State","State2","Clip"}
})

local themes2 = {} for i,v in pairs(themes) do table.insert(themes2,i) end
Interface = RenderWindow.CreateModuleButton({
	Name = "interface",
	HoverText = "The overlay on the main screen",
	Function = function(callback)
		if callback then
			task.spawn(function()
				repeat task.wait()
					GuiLibrary.ColorTheme = themes[InterfaceTheme.Option]
				until not Interface.Enabled
			end)
			return
		end

		task.delay(0.1,function()
			Interface.ToggleButton(true)
		end)
	end,
})
InterfaceTheme = Interface.CreatePickerInstance({
	Name = "Theme",
	Options = themes2
})
InterfaceCapitals = Interface.CreateToggleButton({
	Name = "Capitals",
})
InterfaceSpaces = Interface.CreateToggleButton({
	Name = "Spaces",
})

Interface.ToggleButton()

oldgrav = workspace.Gravity
longjump = MovementWindow.CreateModuleButton({
	Name = "long jump",
	HoverText = "Makes you jump longer on enable",
	Function = function(callback)
		if callback then
			repeat
				if onGround then
					workspace.Gravity = 5
					lplr.Character.Humanoid:ChangeState(3)
				end
				if SpeedBoost.Option == "Normal" then
					if Ticks > 18 then
						lplr.Character.PrimaryPart.CFrame += lplr.Character.PrimaryPart.CFrame.LookVector * 2.1
						Ticks = 0
					end
				end
				task.wait()
			until not longjump.Enabled
			workspace.Gravity = oldgrav
		end
	end,
})
SpeedBoost = longjump.CreatePickerInstance({
	Name = "Boost",
	Options = {"None", "Normal", "Fast"}
})

OldHP = lplr.Character.Humanoid.Health
damageTicks = 0
spawn(function()
	repeat
		damageTicks += 1
		if lplr.Character.Humanoid.Health < OldHP then
			damageTicks = 0
		end
		OldHP = lplr.Character.Humanoid.Health
		task.wait()
	until false
end)

fly = MovementWindow.CreateModuleButton({
	Name = "fly",
	HoverText = "Makes you float",
	Function = function(callback)
		if callback then
			local lastPosY = lplr.Character.PrimaryPart.Position.Y
			repeat
				local Velocity = lplr.Character.PrimaryPart.Velocity
				local OldHP = lplr.Character.Humanoid.Health

				if flymode.Option == "Velocity" then
					lplr.Character.PrimaryPart.Velocity = Vector3.new(Velocity.X, 2.04, Velocity.Z)
				end
				if flymode.Option == "Jump" then
					workspace.Gravity = 50
					if lastPosY > lplr.Character.PrimaryPart.Position.Y then
						lplr.Character.PrimaryPart.Velocity = Vector3.new(Velocity.X, 15, Velocity.Z)
					end
				end
				if flymode.Option == "DamageBoost" then
					if damageTicks < 60 then
						lplr.Character.PrimaryPart.Velocity = Vector3.new(Velocity.X, 2.04, Velocity.Z)
						lplr.Character.PrimaryPart.CFrame += lplr.Character.PrimaryPart.CFrame.LookVector * 0.8
					end
				end
				task.wait()
			until not fly.Enabled
			workspace.Gravity = oldgrav
		end
	end,
})
flymode = fly.CreatePickerInstance({
	Name = "Mode",
	Options = {"Velocity", "Jump", "DamageBoost"}
})

noslow = MovementWindow.CreateModuleButton({
	Name = "no slow",
	HoverText = "Cancels any slowdown from Server",
	Function = function(callback)
		if callback then
			repeat
				if lplr.Character.Humanoid.WalkSpeed ~= (20 or 23.4) then
					lplr.Character.Humanoid.WalkSpeed = 20
				end
				task.wait()
			until not noslow.Enabled
		end
	end,
})

antiafk = PlayerWindow.CreateModuleButton({
	Name = "anti afk",
	HoverText = "makes sure you dont get kicked when AFKing",
	Function = function(callback)
		if callback then
			repeat
				if antiafkmode.Option == "Jump" then
					lplr.Character.Humanoid:ChangeState(3)
					task.wait(10)
				end
				if antiafkmode.Option == "AI" then
					lplr.Character.Humanoid:MoveTo(Vector3.new(-math.random(-1, 5), 0, math.random(-1, 5)))
					task.wait(1)
				end
				task.wait()
			until not antiafk.Enabled
		end
	end,
})
antiafkmode = antiafk.CreatePickerInstance({
	Name = "Mode",
	Options = {"Jump", "AI"}
})

trails = RenderWindow.CreateModuleButton({
	Name = "trails",
	HoverText = "Creates a line of dots behind you",
	Function = function(callback)
		if callback then
			repeat
				local newpart = Instance.new("Part", workspace)
				newpart.Size = Vector3.new(0.6,0.6,0.6)
				newpart.CFrame = lplr.Character.PrimaryPart.CFrame
				newpart.Color = GuiLibrary.ColorTheme.Main
				newpart.CanCollide = false
				newpart.Anchored = true
				newpart.Shape = Enum.PartType.Ball
				newpart.Material = Enum.Material.Neon

				task.delay(0.75, function()
					if trailsmode.Option == 'Transparency' then
						TweenService:Create(newpart, TweenInfo.new(1), {Transparency = 1}):Play()
					end
					if trailsmode.Option == 'Size' then
						TweenService:Create(newpart, TweenInfo.new(1), {Size = Vector3.new(0,0,0)}):Play()
					end

					task.delay(1, function()
						game.Debris:AddItem(newpart)
					end)
				end)

				task.wait(0.1)
			until not trails.Enabled
		end
	end,
})
trailsmode = trails.CreatePickerInstance({
	Name = "Mode",
	Options = {"Transparency", "Size"}
})

safewalk = MovementWindow.CreateModuleButton({
	Name = "safe walk",
	HoverText = "prevents you from walking off a part",
	Function = function(callback)
		if callback then
			repeat
				local Direction = lplr.Character.Humanoid.MoveDirection
				if Direction ~= Vector3.zero and onGround then
					local RayCast = Utilities.newRaycast(lplr.Character.PrimaryPart.Position + (Direction * 0.1),Vector3.new(0,-5,0))

					if not RayCast then
						lplr.Character.PrimaryPart.Velocity *= -1
					end
				end
				task.wait()
			until not safewalk.Enabled
		end
	end,
})

faststop = MovementWindow.CreateModuleButton({
	Name = "fast stop",
	HoverText = "makes you stop moving instantly",
	Function = function(callback)
		if callback then
			repeat task.wait()
				local Velocity = lplr.Character.PrimaryPart.Velocity
				if not isMoving then
					lplr.Character.PrimaryPart.Velocity = Vector3.new(0, Velocity.Y, 0)
				end
			until not faststop.Enabled
		end
	end,
})

local ESPCon
ESP = RenderWindow.CreateModuleButton({
	Name = "esp",
	HoverText = "Shows where other players are at",
	Function = function(callback)
		if callback then
			if ESPMode.Option == "Highlight" then
				ESPCon = game.Players.PlayerAdded:Connect(function(plr)
					local highlight = Instance.new("Highlight", plr.Character)
					highlight.OutlineColor = Color3.fromRGB(0,0,0)
					highlight.FillColor = Color3.fromRGB(25,25,25)
					highlight.FillTransparency = 0.5
				end)
			end
			if ESPMode.Option == "Image" then
				task.spawn(function()
					repeat
						pcall(function()
							for i,v in pairs(Players:GetPlayers()) do
								if not (v.Character.PrimaryPart:FindFirstChild("nein")) then
									if v ~= lplr and ESP.Enabled then
										local e = Instance.new("BillboardGui",v.Character.PrimaryPart)

										local image = Instance.new("ImageLabel",e)
										image.Size = UDim2.fromScale(10,10)
										image.Position = UDim2.fromScale(-3,-4)
										image.Image = Images[ESPImage.Option]
										image.BackgroundTransparency = 1

										e.Size = UDim2.fromScale(0.5,0.5)
										e.AlwaysOnTop = true
										e.Name = "nein"
									end
								end
							end
						end)
						task.wait()
					until not ESP.Enabled
				end)
			end
		else
			pcall(function()
				ESPCon:Disconnect()
			end)
		end
	end,
})
ESPMode = ESP.CreatePickerInstance({
	Name = "Mode",
	Options = {"Image", "Highlight"}
})
ESPImage = ESP.CreatePickerInstance({
	Name = "Image",
	Options = ImageTable
})

MotionBlur = RenderWindow.CreateModuleButton({
	Name = "motion blur",
	HoverText = "Gives you blur based on how much you move",
	Function = function(callback)
		if callback then
			task.spawn(function()
				local blur = Instance.new("BlurEffect",Lighting)
				blur.Size = 0

				local strength = 5

				local lastCamX = Camera.CFrame.X
				local lastCamZ = Camera.CFrame.Z

				repeat task.wait()

					local change = (lastCamX - Camera.CFrame.X) + (lastCamZ - Camera.CFrame.Z)

					if change < 0 then
						change *= -1
					end

					if change > 0.1 then
						game.TweenService:Create(blur,TweenInfo.new(1),{
							Size = change * strength
						}):Play()
					else
						game.TweenService:Create(blur,TweenInfo.new(1),{
							Size = 0
						}):Play()
					end

					lastCamX = Camera.CFrame.X
					lastCamZ = Camera.CFrame.Z
				until not MotionBlur.Enabled
			end)
		end
	end,
})

Phase = PlayerWindow.CreateModuleButton({
	Name = "phase",
	HoverText = "Go through parts",
	Function = function(callback)
		if callback then
			repeat
				local forwardRay = Utilities.newRaycast(lplr.Character.PrimaryPart.Position,lplr.Character.Humanoid.MoveDirection * 2)

				if forwardRay then
					local instance = forwardRay.Instance
					local direction = lplr.Character.Humanoid.MoveDirection
					local speed = (instance.Size.X + instance.Size.Z) / 1.25

					if speed < 10 then
						lplr.Character.PrimaryPart.CFrame += direction * speed
					end
				end
				task.wait()
			until not Phase.Enabled
		end
	end,
})

local AirJumpCon
airjump = PlayerWindow.CreateModuleButton({
	Name = "air jump",
	HoverText = "Allows you to jump in the air",
	Function = function(callback)
		if callback then
			AirJumpCon = UserInputService.InputBegan:Connect(function(k, g)
				if g then return end
				if k == nil then return end
				if fly.Enabled then return end
				if k.KeyCode == Enum.KeyCode.Space then
					lplr.Character.Humanoid:ChangeState(3)
				end
			end)
		else
			pcall(function()
				AirJumpCon:Disconnect()
			end)
		end
	end,
})

spider = MovementWindow.CreateModuleButton({
	Name = "spider",
	HoverText = "Allows you to climb up walls",
	Function = function(callback)
		if callback then
			repeat
				local RayCast = Utilities.newRaycast(lplr.Character.PrimaryPart.Position,lplr.Character.Humanoid.MoveDirection * 2)
				local Velocity = lplr.Character.PrimaryPart.Velocity

				if RayCast and not UserInputService:IsKeyDown("S") then
					lplr.Character.PrimaryPart.Velocity = Vector3.new(Velocity.X, 44, Velocity.Z)
				end

				task.wait()
			until not spider.Enabled
		end
	end,
})

antivoid = PlayerWindow.CreateModuleButton({
	Name = "anti void",
	HoverText = "you wont ever fall into the void",
	Function = function(callback)
		if callback then
			if lplr.Character.PrimaryPart.Position.Y < 0 then
				lplr.Character.PrimaryPart.Anchored = true
				lplr.Character.PrimaryPart.CFrame = (lplr.Character.PrimaryPart.CFrame - lplr.Character.PrimaryPart.CFrame.LookVector * 5) + Vector3.new(0, 10, 0)
				task.delay(0.5, function()
					lplr.Character.PrimaryPart.Anchored = false
				end)
			end
		end
	end,
})

chatspammer = OtherWindow.CreateModuleButton({
	Name = "chat spammer",
	Function = function(callback)
		if callback then
			repeat
				Utilities.newChat(".gg/YDdvRDPBaN")
				task.wait(3.5)
			until not chatspammer.Enabled
		end
	end,
})

local oldsky = {
	amb = Lighting.Ambient,
	outdooramb = Lighting.OutdoorAmbient,
}
local dayTime = Lighting.TimeOfDay
Ambience = RenderWindow.CreateModuleButton({
	Name = "ambience",
	HoverText = "Change the world colors",
	Function = function(callback)
		if callback then
			repeat
				Lighting.Ambient = AmbienceColors[AmbienceColor.Option]
				Lighting.OutdoorAmbient = AmbienceColors[AmbienceColor.Option]

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
AmbienceColor = Ambience.CreatePickerInstance({
	Name = "Color",
	Options = AmbienceOption
})
AmbienceTime = Ambience.CreatePickerInstance({
	Name = "TimeOfDay",
	Options = {"Day", "Night"}
})

local oldFOV = Camera.FieldOfView
fovchanger = RenderWindow.CreateModuleButton({
	Name = "fov changer",
	HoverText = "Changes FieldOfView to higher values",
	Function = function(callback)
		if callback then
			repeat
				Camera.FieldOfView = 120
				task.wait()
			until not fovchanger.Enabled
			Camera.FieldOfView = oldFOV
		end
	end,
})

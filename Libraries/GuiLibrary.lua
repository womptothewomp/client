local gameId = game.PlaceId
shared.AeolusLoaded = true

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
	makefolder("Aeolus")
	saveConfig()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local UserInputService = game:GetService("UserInputService")

local lplr = Players.LocalPlayer

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

shared.GuiLibrary = {
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
			for i,v in pairs(shared.GuiLibrary.WindowInstances) do
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

shared.GuiLibrary.MainInstance.ResetOnSpawn = false
shared.GuiLibrary.MainInstance.IgnoreGuiInset = true

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
function shared.GuiLibrary:CreateWindowInstance(tab)
	local name = tab.Name or ""

	local top = Instance.new("TextLabel",shared.GuiLibrary.MainInstance)
	top.Text = name
	top.TextColor3 = Color3.fromRGB(255,255,255)
	top.Size = UDim2.fromScale(0.12,0.035)
	top.Position = UDim2.fromScale(0.04 + (0.14 * shared.GuiLibrary.WindowInstanceCount), 0.15)
	top.BackgroundColor3 = shared.GuiLibrary.ColorTheme.Gui
	top.TextSize = 11
	local topFlat = Instance.new("Frame",top)
	topFlat.BackgroundColor3 = shared.GuiLibrary.ColorTheme.Gui
	topFlat.Size = UDim2.fromScale(1,0.18)
	topFlat.Position = UDim2.fromScale(0,0.82)
	topFlat.BorderSizePixel = 0

	local moduleFrame = Instance.new("Frame",top)
	moduleFrame.Size = UDim2.fromScale(1,20)
	moduleFrame.Position = UDim2.fromScale(0,1)
	moduleFrame.Transparency = 1
	local listLayout = Instance.new("UIListLayout",moduleFrame)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder

	shared.GuiLibrary.Funcs.Round(top,0.25)

	shared.GuiLibrary.WindowInstanceCount += 1

	local buttonIndex = 0

	local lastButton

	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,shared.GuiLibrary.ColorTheme.Main),ColorSequenceKeypoint.new(1,shared.GuiLibrary.ColorTheme.Accent),ColorSequenceKeypoint.new(1,shared.GuiLibrary.ColorTheme.Accent)})
	local gradient2 = Instance.new("UIGradient")
	gradient2.Color = gradient.Color

	local bottomRound = Instance.new("Frame",moduleFrame)
	bottomRound.LayoutOrder = 10000
	bottomRound.BackgroundColor3 = Color3.fromRGB(255,255,255)
	bottomRound.Size = UDim2.fromScale(1,0.02)

	shared.GuiLibrary.Funcs.Round(bottomRound,1)
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

	shared.GuiLibrary.WindowInstances[name] = {
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

			local hoverTextInstance = Instance.new("TextLabel",shared.GuiLibrary.MainInstance)

			if hoverText ~= "" then
				hoverTextInstance.Text = hoverText
				hoverTextInstance.TextColor3 = Color3.fromRGB(255, 255, 255)
				hoverTextInstance.BackgroundColor3 = Color3.fromRGB(30,30,30)
				hoverTextInstance.TextSize = 10
				hoverTextInstance.Size = UDim2.new(0,TextService:GetTextSize("  "..hoverText.."  ",10,hoverTextInstance.Font,Vector2.new(0,0)).X,0.04,0)
				hoverTextInstance.Transparency = 1
				shared.GuiLibrary.Funcs.Round(hoverTextInstance, 0.2)
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
						gradientc.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,shared.GuiLibrary.ColorTheme.Main),ColorSequenceKeypoint.new(1,shared.GuiLibrary.ColorTheme.Accent)})

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
								gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,shared.GuiLibrary.ColorTheme.Main),ColorSequenceKeypoint.new(0,Color3.fromRGB(30,30,30))})
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
					newname.Text = shared.GuiLibrary.Funcs.CompensateLeftText(tab3.Name)
					newname.TextXAlignment = Enum.TextXAlignment.Left
					newname.TextSize = 8

					local newbutton = Instance.new("TextButton", newname)
					newbutton.Position = UDim2.fromScale(0.75, 0.15)
					newbutton.Size = UDim2.fromScale(0.2, 0.7)
					newbutton.BorderSizePixel = 0
					newbutton.BackgroundColor3 = Color3.fromRGB(50,50,50)
					newbutton.Text = ""
					shared.GuiLibrary.Funcs.Round(newbutton, 1)

					local newdot = Instance.new("Frame", newbutton)
					newdot.Position = UDim2.fromScale(0.12, 0.25)
					newdot.Size = UDim2.fromScale(0.3, 0.55)
					newdot.BorderSizePixel = 0
					newdot.BackgroundColor3 = shared.GuiLibrary.ColorTheme.Gui2
					shared.GuiLibrary.Funcs.Round(newdot, 10)

					returnTable.ToggleButton = function()					
						returnTable.Enabled = not returnTable.Enabled
						TweenService:Create(newdot, TweenInfo.new(0.75), {
							Position = (returnTable.Enabled and UDim2.fromScale(0.55, 0.25) or UDim2.fromScale(0.12, 0.25))
						}):Play()
						TweenService:Create(newbutton, TweenInfo.new(0.75), {
							BackgroundColor3 = (returnTable.Enabled and shared.GuiLibrary.ColorTheme.Main or Color3.fromRGB(50,50,50))
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
					newtextlabel.Text = shared.GuiLibrary.Funcs.CompensateLeftText(tab4.Name)..": "
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
						gradientc.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,shared.GuiLibrary.ColorTheme.Main),ColorSequenceKeypoint.new(1,shared.GuiLibrary.ColorTheme.Accent)})
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
			bottomRound.BackgroundColor3 = shared.GuiLibrary.ColorTheme.Gui
			bottomFlat.BackgroundColor3 = shared.GuiLibrary.ColorTheme.Gui
			gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(30,30,30)),ColorSequenceKeypoint.new(1,Color3.fromRGB(30,30,30))})
			gradient2.Color = gradient.Color
		until false 
	end)

	gradient.Parent = bottomRound
	gradient2.Parent = bottomFlat
end

shared.GuiLibrary:CreateWindowInstance({Name = "Combat"})
shared.GuiLibrary:CreateWindowInstance({Name = "Movement"})
shared.GuiLibrary:CreateWindowInstance({Name = "Player"})
shared.GuiLibrary:CreateWindowInstance({Name = "Render"})
shared.GuiLibrary:CreateWindowInstance({Name = "Other"})

local CombatWindow = shared.GuiLibrary.Funcs.GetWindowInstance("Combat")
local RenderWindow = shared.GuiLibrary.Funcs.GetWindowInstance("Render")
local MovementWindow = shared.GuiLibrary.Funcs.GetWindowInstance("Movement")
local PlayerWindow = shared.GuiLibrary.Funcs.GetWindowInstance("Player")
local OtherWindow = shared.GuiLibrary.Funcs.GetWindowInstance("Other")

local themes2 = {} for i,v in pairs(themes) do table.insert(themes2,i) end
Interface = RenderWindow.CreateModuleButton({
	Name = "interface",
	HoverText = "The overlay on the main screen",
	Function = function(callback)
		if callback then
			task.spawn(function()
				repeat task.wait()
					shared.GuiLibrary.ColorTheme = themes[InterfaceTheme.Option]
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

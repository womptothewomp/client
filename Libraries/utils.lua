local utils = {}

Players = game:GetService("Players")
UserInputService = game:GetService("UserInputService")
LocalPlayer = Players.LocalPlayer
Character = LocalPlayer.Character
Humanoid = Character.Humanoid
ReplicatedStorage = game:GetService("ReplicatedStorage")

utils.onGround = function()
	return Humanoid.FloorMaterial ~= Enum.Material.Air
end
utils.isMoving = function()
	if onMobile then
		return Humanoid.MoveDirection ~= Vector3.zero
	end
	return UserInputService:IsKeyDown("W") or UserInputService:IsKeyDown("A") or UserInputService:IsKeyDown("S") or UserInputService:IsKeyDown("D")
end
utils.newChat = function(Message)
  ReplicatedStorage.DefaultChatSystemChatEvents:WaitForChild("SayMessageRequest"):FireServer(Message, "All")
end
utils.NewRaycast = function(Start, Direction)
  local p = RaycastParams.new()
	p.FilterType = Enum.RaycastFilterType.Exclude
	p.FilterDescendantsInstances = {Character,workspace.CurrentCamera}
	local ray = workspace:Raycast(Start,Direction,p)
	return ray
end

return utils

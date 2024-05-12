FunctionTable = {}

FunctionTable.getRemote = function(name)
  local remote
  	for i,v in pairs(game:GetDescendants()) do
  		if v.Name == name then
  			remote = v
  			break
  		end
  	end
  	return remote
end

return FunctionTable

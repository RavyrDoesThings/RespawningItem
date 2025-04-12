-- CONFIGURATION
local TOOL_NAME = "MyTool" -- name of the tool in ServerStorage
local RESPAWN_POINT_NAME = "ToolRespawn" -- name of the parts in Workspace to respawn tool at

-- SERVICES
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")

-- FUNCTION TO GET RANDOM RESPAWN LOCATION
local function getRandomRespawnPoint()
	local points = Workspace:GetDescendants()
	local validPoints = {}

	for _, obj in ipairs(points) do
		if obj:IsA("BasePart") and obj.Name == RESPAWN_POINT_NAME then
			table.insert(validPoints, obj)
		end
	end

	if #validPoints > 0 then
		return validPoints[math.random(1, #validPoints)]
	else
		warn("No valid respawn points found with name: " .. RESPAWN_POINT_NAME)
		return nil
	end
end

-- FUNCTION TO RESPAWN TOOL
local function respawnTool()
	local toolTemplate = ServerStorage:FindFirstChild(TOOL_NAME)
	if not toolTemplate then
		warn("Tool not found in ServerStorage: " .. TOOL_NAME)
		return
	end

	local respawnPoint = getRandomRespawnPoint()
	if not respawnPoint then return end

	local newTool = toolTemplate:Clone()
	newTool.Parent = Workspace
	newTool.Handle.CFrame = respawnPoint.CFrame + Vector3.new(0, 1.5, 0)
end

-- INITIAL RESPAWN
respawnTool()

-- OPTIONAL: Auto-respawn after X seconds when tool is removed
-- Put this part only if you want auto-respawn
Workspace.ChildRemoved:Connect(function(child)
	if child:IsA("Tool") and child.Name == TOOL_NAME then
		wait(5) -- adjust the delay here
		respawnTool()
	end
end)

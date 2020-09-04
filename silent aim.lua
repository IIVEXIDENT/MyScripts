local MainGUI = Instance.new("ScreenGui")
local TopFrame = Instance.new("Frame")
local MainFrame = Instance.new("Frame")
local cf = Instance.new("Frame")
local c1 = Instance.new("TextLabel")

MainGUI.Name = "MainGUI"
MainGUI.Parent = game.CoreGui
MainGUI.ResetOnSpawn = false
local MainCORE = game.CoreGui["MainGUI"]

TopFrame.Name = "TopFrame"
TopFrame.Parent = MainGUI
TopFrame.BackgroundColor3 = Color3.new(0, 0, 0)
TopFrame.BorderColor3 = Color3.new(0, 0, 0)
TopFrame.BackgroundTransparency = 1
TopFrame.Position = UDim2.new(0.5, -30, 0, -27)
TopFrame.Size = UDim2.new(0, 80, 0, 20)
TopFrame.Visible = false

cf.Name = "cf"
cf.Parent = MainGUI
cf.BackgroundColor3 = Color3.new(141/255, 242/255, 126/255)
cf.BorderColor3 = Color3.new(0.5, 0.5, 0.5)
cf.BackgroundTransparency = 0
cf.Position = UDim2.new(0.5, -195, 0.5, -110)
cf.Size = UDim2.new(0, 390, 0, 220)
cf.Visible = true

c1.Name = "c1"
c1.Parent = cf
c1.BackgroundColor3 = Color3.new(141/255, 242/255, 126/255)
c1.BackgroundTransparency = 1
c1.Position = UDim2.new(0, 1, 0, 0)
c1.Size = UDim2.new(0, 370, 0, 160)
c1.Font = Enum.Font.Fantasy
c1.TextColor3 = Color3.new(1, 1, 1)
c1.Text = "THIS SCRIPT IS MADE BY 8799#1840\nANYWAYS ENJOY THE SCRIPT"
c1.TextSize = 24

wait(7)

MainGUI:remove()
TopFrame:remove()
MainFrame:remove()
cf:remove()
c1:remove()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local Debris = game:GetService("Debris")
local UserInputService = game:GetService("UserInputService")
local target = false
local RunService = game:GetService("RunService")

local features = {
silentaim = true;
fov = 500;
}

function getnearest()
local nearestmagnitude = math.huge
local nearestenemy = nil
local vector = nil
for i,v in next, Players:GetChildren() do
if v ~= Players.LocalPlayer then
if v.Character and  v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
local vector, onScreen = Camera:WorldToScreenPoint(v.Character["HumanoidRootPart"].Position)
if onScreen then
local ray = Ray.new(
Camera.CFrame.p,
(v.Character["Head"].Position-Camera.CFrame.p).unit*500
)
local ignore = {
LocalPlayer.Character,
}
local hit,position,normal=workspace:FindPartOnRayWithIgnoreList(ray,ignore)
if hit and hit:FindFirstAncestorOfClass("Model") and Players:FindFirstChild(hit:FindFirstAncestorOfClass("Model").Name)then
local magnitude = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(vector.X, vector.Y)).magnitude
if magnitude < nearestmagnitude and magnitude <= features["fov"] then
nearestenemy = v
nearestmagnitude = magnitude
end
end
end
end
end
end
return nearestenemy
end


local meta = getrawmetatable(game)
setreadonly(meta, false)
local oldNamecall = meta.__namecall
meta.__namecall = newcclosure(function(...)
local method = getnamecallmethod()
local args = {...}
if string.find(method,'Ray') then
if target then
args[2] = Ray.new(workspace.CurrentCamera.CFrame.Position, (target + Vector3.new(0,(workspace.CurrentCamera.CFrame.Position-target).Magnitude/500,0) - workspace.CurrentCamera.CFrame.Position).unit * 500)
end
end
return oldNamecall(unpack(args))
end)


RunService:BindToRenderStep("silentaim",1,function()
if UserInputService:IsMouseButtonPressed(0) and features["silentaim"] and Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid") and Players.LocalPlayer.Character.Humanoid.Health > 0 then
local enemy = getnearest()
if enemy and enemy.Character and enemy.Character:FindFirstChild("Humanoid") and enemy.Character.Humanoid.Health > 0 then                
local vector, onScreen = Camera:WorldToScreenPoint(enemy.Character["Head"].Position)
local magnitude = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(vector.X, vector.Y)).magnitude
target = workspace[enemy.Name]["Head"].Position
end
else
target = nil
end
end)

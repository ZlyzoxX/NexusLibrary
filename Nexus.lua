--[[
    MPB Executor GUI Library - Simplified Version
    Designed for Roblox Script Executors
]]

-- Core Library
local MPB = {}

-- Get required services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Configuration
MPB.Config = {
    Theme = {
        Primary = Color3.fromRGB(138, 43, 226),
        Dark = Color3.fromRGB(75, 0, 130),
        Background = Color3.fromRGB(25, 25, 35),
        ElementBackground = Color3.fromRGB(35, 35, 50),
        Text = Color3.fromRGB(240, 240, 255),
    },
    Animation = {
        Duration = 0.2,
    },
}

-- Utility function
local function CreateTween(instance, properties, duration)
    return TweenService:Create(instance, TweenInfo.new(duration or MPB.Config.Animation.Duration), properties)
end

-- Library Initialization
function MPB:Init()
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "MPB_ExecutorGUI"
    self.ScreenGui.Parent = game:GetService("CoreGui")
    self.Windows = {}
    return self
end

-- Window Class
function MPB:Window(title, size)
    local window = {
        Title = title or "Executor GUI",
        Size = size or UDim2.new(0, 800, 0, 600),
        Visible = false,
        Tabs = {},
        ActiveTab = nil,
    }
    
    -- Create window frame
    window.Frame = Instance.new("Frame")
    window.Frame.Size = window.Size
    window.Frame.BackgroundColor3 = MPB.Config.Theme.Background
    window.Frame.Parent = self.ScreenGui
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = MPB.Config.Theme.ElementBackground
    titleBar.Parent = window.Frame
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -20, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.Text = window.Title
    titleText.Font = Enum.Font.GothamBold
    titleText.TextColor3 = MPB.Config.Theme.Text
    titleText.Parent = titleBar
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(1, -30, 0, 5)
    closeButton.Text = "×"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 16
    closeButton.TextColor3 = MPB.Config.Theme.Text
    closeButton.Parent = titleBar
    
    -- Content area
    window.Content = Instance.new("Frame")
    window.Content.Size = UDim2.new(1, 0, 1, -30)
    window.Content.Position = UDim2.new(0, 0, 0, 30)
    window.Content.BackgroundTransparency = 1
    window.Content.Parent = window.Frame
    
    -- Show function
    function window:Show()
        self.Visible = true
        self.Frame.Visible = true
        CreateTween(self.Frame, {BackgroundTransparency = 0}):Play()
    end
    
    -- Add to library
    table.insert(self.Windows, window)
    return window
end

-- Button Class
function MPB:Button(parent, text, position, size, callback)
    local button = Instance.new("TextButton")
    button.Size = size or UDim2.new(0, 120, 0, 30)
    button.Position = position or UDim2.new(0, 10, 0, 10)
    button.Text = text or "Button"
    button.Font = Enum.Font.GothamBold
    button.TextColor3 = MPB.Config.Theme.Text
    button.BackgroundColor3 = MPB.Config.Theme.ElementBackground
    button.Parent = parent
    
    button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    return button
end

-- TextBox Class
function MPB:TextBox(parent, placeholder, position, size, callback)
    local textBox = Instance.new("TextBox")
    textBox.Size = size or UDim2.new(0, 200, 0, 30)
    textBox.Position = position or UDim2.new(0, 10, 0, 10)
    textBox.PlaceholderText = placeholder or "Enter text..."
    textBox.Font = Enum.Font.Gotham
    textBox.TextColor3 = MPB.Config.Theme.Text
    textBox.BackgroundColor3 = MPB.Config.Theme.ElementBackground
    textBox.Parent = parent
    
    textBox.FocusLost:Connect(function(enterPressed)
        if callback and enterPressed then
            callback(textBox.Text)
        end
    end)
    
    return textBox
end

-- Notification System
function MPB:Notification(title, text, duration, type)
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 300, 0, 80)
    notification.Position = UDim2.new(1, -320, 0, 100)
    notification.BackgroundColor3 = MPB.Config.Theme.ElementBackground
    notification.Parent = self.ScreenGui
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -60, 0, 20)
    titleText.Position = UDim2.new(0, 60, 0, 10)
    titleText.Text = title or "Notification"
    titleText.Font = Enum.Font.GothamBold
    titleText.TextColor3 = MPB.Config.Theme.Text
    titleText.Parent = notification
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -60, 0, 20)
    textLabel.Position = UDim2.new(0, 60, 0, 35)
    textLabel.Text = text or "This is a notification"
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextColor3 = MPB.Config.Theme.Text
    textLabel.Parent = notification
    
    notification:TweenPosition(UDim2.new(1, -320, 0, 100), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
    
    task.wait(duration or 3)
    
    notification:TweenPosition(UDim2.new(1, 0, 0, 100), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.3, true)
    task.wait(0.3)
    notification:Destroy()
end

return MPB

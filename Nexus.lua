--[[
    MPB Executor GUI Library - Polished Version
    Modern Purple Black Theme with Smooth Animations
]]

-- Core Library
local MPB = {}

-- Get required services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Configuration
MPB.Config = {
    Theme = {
        Primary = Color3.fromRGB(138, 43, 226), -- Purple
        Dark = Color3.fromRGB(75, 0, 130), -- Dark Purple
        Background = Color3.fromRGB(18, 18, 30), -- Deep background
        ElementBackground = Color3.fromRGB(30, 30, 45), -- Slightly lighter for elements
        Text = Color3.fromRGB(240, 240, 255), -- White text
        TextLight = Color3.fromRGB(180, 180, 200), -- Lighter text for secondary info
        Border = Color3.fromRGB(50, 50, 70), -- Border color
        Accent = Color3.fromRGB(255, 107, 107), -- Red accent
        Accent2 = Color3.fromRGB(78, 205, 196), -- Cyan accent
    },
    Animation = {
        Duration = 0.3,
        EasingStyle = Enum.EasingStyle.Quad,
        EasingDirection = Enum.EasingDirection.Out,
    },
}

-- Utility function for tweens
local function CreateTween(instance, properties, duration, easingStyle, easingDirection)
    return TweenService:Create(instance, TweenInfo.new(duration or MPB.Config.Animation.Duration, 
        easingStyle or MPB.Config.Animation.EasingStyle, 
        easingDirection or MPB.Config.Animation.EasingDirection), properties)
end

-- Library Initialization
function MPB:Init()
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "MPB_ExecutorGUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = game:GetService("CoreGui")
    
    self.Windows = {}
    self.ActiveWindow = nil
    
    return self
end

-- Window Class
function MPB:Window(title, size, position)
    local window = {
        Title = title or "Executor GUI",
        Size = size or UDim2.new(0, 900, 0, 600),
        Position = position or UDim2.new(0.5, -450, 0.5, -300),
        Visible = false,
        Tabs = {},
        ActiveTab = nil,
        Elements = {},
    }
    
    -- Create window frame with shadow
    window.Frame = Instance.new("Frame")
    window.Frame.Size = window.Size
    window.Frame.Position = window.Position
    window.Frame.BackgroundColor3 = MPB.Config.Theme.Background
    window.Frame.BorderSizePixel = 0
    window.Frame.Parent = self.ScreenGui
    
    -- Shadow effect
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 8, 1, 8)
    shadow.Position = UDim2.new(0, -4, 0, -4)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6015897848"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.3
    shadow.Parent = window.Frame
    
    -- Gradient background
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, MPB.Config.Theme.Background),
        ColorSequenceKeypoint.new(1, MPB.Config.Theme.ElementBackground)
    })
    gradient.Rotation = 10
    gradient.Parent = window.Frame
    
    -- Border
    local border = Instance.new("Frame")
    border.Size = UDim2.new(1, 0, 1, 0)
    border.Position = UDim2.new(0, 1, 0, 1)
    border.BackgroundColor3 = MPB.Config.Theme.Border
    border.BorderSizePixel = 0
    border.Parent = window.Frame
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = MPB.Config.Theme.ElementBackground
    titleBar.BorderSizePixel = 0
    titleBar.Parent = window.Frame
    
    -- Title text
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -40, 1, 0)
    titleText.Position = UDim2.new(0, 20, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = window.Title
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 18
    titleText.TextColor3 = MPB.Config.Theme.Text
    titleText.TextStrokeTransparency = 0.3
    titleText.TextStrokeColor3 = MPB.Config.Theme.Border
    titleText.Parent = titleBar
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0.5, -15)
    closeButton.AnchorPoint = Vector2.new(1, 0.5)
    closeButton.BackgroundColor3 = MPB.Config.Theme.Dark
    closeButton.BorderSizePixel = 0
    closeButton.Text = "×"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 20
    closeButton.TextColor3 = MPB.Config.Theme.TextLight
    closeButton.TextStrokeTransparency = 0.5
    closeButton.TextStrokeColor3 = MPB.Config.Theme.Border
    closeButton.Parent = titleBar
    
    -- Content area
    window.Content = Instance.new("Frame")
    window.Content.Size = UDim2.new(1, 0, 1, -40)
    window.Content.Position = UDim2.new(0, 0, 0, 40)
    window.Content.BackgroundTransparency = 1
    window.Content.Parent = window.Frame
    
    -- Show function with fade in
    function window:Show()
        self.Visible = true
        self.Frame.Visible = true
        self.Frame.BackgroundTransparency = 1
        CreateTween(self.Frame, {BackgroundTransparency = 0}):Play()
    end
    
    -- Close function
    function window:Close()
        self:Hide()
        for i, win in ipairs(self.Library.Windows) do
            if win == self then
                table.remove(self.Library.Windows, i)
                break
            end
        end
        self.Frame:Destroy()
    end
    
    -- Hide function
    function window:Hide()
        self.Visible = false
        self.Frame.Visible = false
    end
    
    -- Add to library
    table.insert(self.Library.Windows, window)
    self.Library.ActiveWindow = window
    
    return window
end

-- Button Class
function MPB:Button(parent, text, position, size, callback)
    local button = Instance.new("TextButton")
    button.Size = size or UDim2.new(0, 150, 0, 40)
    button.Position = position or UDim2.new(0, 20, 0, 20)
    button.Text = text or "Button"
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.TextColor3 = MPB.Config.Theme.Text
    button.BackgroundColor3 = MPB.Config.Theme.ElementBackground
    button.BorderSizePixel = 0
    button.Parent = parent
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        CreateTween(button, {BackgroundColor3 = MPB.Config.Theme.Primary}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        CreateTween(button, {BackgroundColor3 = MPB.Config.Theme.ElementBackground}):Play()
    end)
    
    -- Click effect
    button.MouseButton1Down:Connect(function()
        CreateTween(button, {BackgroundColor3 = MPB.Config.Theme.Accent}):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        CreateTween(button, {BackgroundColor3 = MPB.Config.Theme.Primary}):Play()
    end)
    
    -- Click callback
    button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    return button
end

-- TextBox Class
function MPB:TextBox(parent, placeholder, position, size, callback)
    local textBox = Instance.new("TextBox")
    textBox.Size = size or UDim2.new(0, 300, 0, 40)
    textBox.Position = position or UDim2.new(0, 20, 0, 20)
    textBox.PlaceholderText = placeholder or "Enter text..."
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 14
    textBox.TextColor3 = MPB.Config.Theme.Text
    textBox.BackgroundColor3 = MPB.Config.Theme.ElementBackground
    textBox.ClearTextOnFocus = false
    textBox.Parent = parent
    
    -- Focus effect
    textBox.Focused:Connect(function()
        CreateTween(textBox, {BackgroundColor3 = MPB.Config.Theme.Primary}):Play()
    end)
    
    textBox.FocusLost:Connect(function(enterPressed)
        CreateTween(textBox, {BackgroundColor3 = MPB.Config.Theme.ElementBackground}):Play()
        if callback and enterPressed then
            callback(textBox.Text)
        end
    end)
    
    return textBox
end

-- Slider Class
function MPB:Slider(parent, min, max, value, position, size, callback)
    local slider = {
        Min = min or 0,
        Max = max or 100,
        Value = value or 50,
        Callback = callback,
    }
    
    -- Create container
    slider.Container = Instance.new("Frame")
    slider.Container.Size = size or UDim2.new(0, 300, 0, 40)
    slider.Container.Position = position or UDim2.new(0, 20, 0, 20)
    slider.Container.BackgroundTransparency = 1
    slider.Container.Parent = parent
    
    -- Track
    slider.Track = Instance.new("Frame")
    slider.Track.Size = UDim2.new(1, 0, 0, 6)
    slider.Track.Position = UDim2.new(0, 0, 0.5, -3)
    slider.Track.BackgroundColor3 = MPB.Config.Theme.ElementBackground
    slider.Track.BorderSizePixel = 0
    slider.Track.Parent = slider.Container
    
    -- Fill
    slider.Fill = Instance.new("Frame")
    slider.Fill.Size = UDim2.new(0.5, 0, 1, 0)
    slider.Fill.BackgroundColor3 = MPB.Config.Theme.Primary
    slider.Fill.BorderSizePixel = 0
    slider.Fill.Parent = slider.Track
    
    -- Thumb
    slider.Thumb = Instance.new("Frame")
    slider.Thumb.Size = UDim2.new(0, 16, 0, 16)
    slider.Thumb.Position = UDim2.new(0.5, -8, 0.5, -8)
    slider.Thumb.BackgroundColor3 = MPB.Config.Theme.White
    slider.Thumb.BorderSizePixel = 0
    slider.Thumb.Parent = slider.Container
    
    -- Value label
    slider.ValueLabel = Instance.new("TextLabel")
    slider.ValueLabel.Size = UDim2.new(0, 50, 0, 20)
    slider.ValueLabel.Position = UDim2.new(1, 10, 0, 10)
    slider.ValueLabel.BackgroundTransparency = 1
    slider.ValueLabel.Text = tostring(slider.Value)
    slider.ValueLabel.Font = Enum.Font.GothamBold
    slider.ValueLabel.TextSize = 14
    slider.ValueLabel.TextColor3 = MPB.Config.Theme.Text
    slider.ValueLabel.Parent = slider.Container
    
    -- Drag functionality
    local dragging = false
    slider.Thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = Vector2.new(input.Position.X, input.Position.Y)
            local trackPos = slider.Track.AbsolutePosition
            local trackSize = slider.Track.AbsoluteSize
            local relativeX = mousePos.X - trackPos.X
            
            if relativeX < 0 then relativeX = 0 end
            if relativeX > trackSize.X then relativeX = trackSize.X end
            
            local percentage = relativeX / trackSize.X
            local newValue = slider.Min + (slider.Max - slider.Min) * percentage
            slider:UpdateValue(newValue)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Update value function
    function slider:UpdateValue(value)
        self.Value = math.clamp(value, self.Min, self.Max)
        local percentage = (self.Value - self.Min) / (self.Max - self.Min)
        
        self.Fill:TweenSize(UDim2.new(percentage, 0, 1, 0), Enum.Direction.Left, 0, true, 0.1)
        self.Thumb:TweenPosition(UDim2.new(percentage, -8, 0.5, -8), Enum.Direction.Left, 0, true, 0.1)
        self.ValueLabel.Text = tostring(math.floor(self.Value))
        
        if self.Callback then
            self.Callback(self.Value)
        end
    end
    
    return slider
end

-- Notification System
function MPB:Notification(title, text, duration, type)
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 350, 0, 100)
    notification.Position = UDim2.new(1, -370, 0, 100)
    notification.BackgroundColor3 = MPB.Config.Theme.ElementBackground
    notification.BorderSizePixel = 0
    notification.Parent = self.ScreenGui
    
    -- Icon
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 40, 0, 40)
    icon.Position = UDim2.new(0, 15, 0.5, -20)
    icon.AnchorPoint = Vector2.new(0, 0.5)
    icon.BackgroundTransparency = 1
    icon.Text = type == "success" and "✓" or type == "error" and "✕" or "ℹ"
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 24
    icon.TextColor3 = type == "success" and MPB.Config.Theme.Accent2 or 
                    type == "error" and MPB.Config.Theme.Accent or 
                    MPB.Config.Theme.Primary
    icon.Parent = notification
    
    -- Title
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -70, 0, 20)
    titleText.Position = UDim2.new(0, 65, 0, 15)
    titleText.BackgroundTransparency = 1
    titleText.Text = title or "Notification"
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 16
    titleText.TextColor3 = MPB.Config.Theme.Text
    titleText.Parent = notification
    
    -- Text
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -70, 0, 20)
    textLabel.Position = UDim2.new(0, 65, 0, 40)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text or "This is a notification"
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 14
    textLabel.TextColor3 = MPB.Config.Theme.TextLight
    textLabel.Parent = notification
    
    -- Slide in
    notification:TweenPosition(UDim2.new(1, -370, 0, 100), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
    
    -- Auto hide
    task.wait(duration or 3)
    
    -- Slide out
    notification:TweenPosition(UDim2.new(1, 0, 0, 100), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.3, true)
    task.wait(0.3)
    notification:Destroy()
end

return MPB

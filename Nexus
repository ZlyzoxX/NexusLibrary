--[[
    MPB Executor GUI Library - Fixed Version
    Designed for Roblox Script Executors
]]

-- Core Library
local MPB = {}
MPB.__index = MPB

-- Configuration
MPB.Config = {
    Theme = {
        Primary = Color3.fromRGB(138, 43, 226), -- Purple
        Dark = Color3.fromRGB(75, 0, 130), -- Dark Purple
        Light = Color3.fromRGB(186, 85, 211), -- Light Purple
        Black = Color3.fromRGB(18, 18, 18), -- Almost Black
        DarkGray = Color3.fromRGB(30, 30, 30),
        MediumGray = Color3.fromRGB(45, 45, 45),
        LightGray = Color3.fromRGB(58, 58, 58),
        White = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(255, 107, 107), -- Red Accent
        Accent2 = Color3.fromRGB(78, 205, 196), -- Cyan Accent
        Accent3 = Color3.fromRGB(69, 183, 209), -- Blue Accent
        Background = Color3.fromRGB(25, 25, 35),
        ElementBackground = Color3.fromRGB(35, 35, 50),
        Text = Color3.fromRGB(240, 240, 255),
        TextLight = Color3.fromRGB(180, 180, 200),
        Border = Color3.fromRGB(50, 50, 70),
        Highlight = Color3.fromRGB(100, 100, 130),
    },
    Animation = {
        Duration = 0.2,
        EasingStyle = Enum.EasingStyle.Quad,
        EasingDirection = Enum.EasingDirection.Out,
    },
    Window = {
        DefaultSize = UDim2.new(0, 800, 0, 600),
        DefaultPosition = UDim2.new(0.5, -400, 0.5, -300),
    },
}

-- Utility Functions
local function DeepCopy(tbl)
    local copy = {}
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            copy[k] = DeepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

local function HSVToRGB(h, s, v)
    local c = v * s
    local x = c * (1 - math.abs((h * 6) % 2 - 1))
    local m = v - c
    if h < 1/6 then return c + m, x + m, m
    elseif h < 2/6 then return x + m, c + m, m
    elseif h < 3/6 then return m, c + m, x + m
    elseif h < 4/6 then return m, x + m, c + m
    elseif h < 5/6 then return x + m, m, c + m
    else return c + m, m, x + m end
end

local function RGBToHSV(r, g, b)
    r, g, b = r / 255, g / 255, b / 255
    local max, min = math.max(r, g, b), math.min(r, g, b)
    local h, s, v
    v = max
    local d = max - min
    if max == 0 then s = 0 else s = d / max end
    if max == min then
        h = 0
    else
        if r == max then
            h = (g - b) / d
            if g < b then h = h + 6 end
        elseif g == max then
            h = 2 + (b - r) / d
        elseif b == max then
            h = 4 + (r - g) / d
        end
        h = h / 6
    end
    return h, s, v
end

local function Lerp(a, b, t)
    return a + (b - a) * t
end

local function Round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function CreateTween(instance, properties, duration, easingStyle, easingDirection)
    return game:GetService("TweenService"):Create(instance, TweenInfo.new(duration or MPB.Config.Animation.Duration, 
        easingStyle or MPB.Config.Animation.EasingStyle, 
        easingDirection or MPB.Config.Animation.EasingDirection), properties)
end

-- Library Initialization
function MPB:Init()
    -- Create main screen GUI
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "MPB_ExecutorGUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Initialize theme
    self:ApplyTheme()
    
    -- Setup global mouse tracking
    self:SetupMouseTracking()
    
    -- Store windows
    self.Windows = {}
    self.ActiveWindow = nil
    
    return self
end

function MPB:ApplyTheme()
    -- Apply theme colors to existing elements
end

function MPB:SetupMouseTracking()
    self.MousePosition = Vector2.new(0, 0)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            self.MousePosition = Vector2.new(input.Position.X, input.Position.Y)
        end
    end)
end

-- Window Class
MPB.Window = {}
MPB.Window.__index = MPB.Window

function MPB.Window.new(library, title, size, position)
    local self = setmetatable({}, MPB.Window)
    self.Library = library
    self.Title = title or "Executor GUI"
    self.Size = size or MPB.Config.Window.DefaultSize
    self.Position = position or MPB.Config.Window.DefaultPosition
    self.Visible = false
    self.Elements = {}
    self.Tabs = {}
    self.ActiveTab = nil
    self.Dragging = false
    self.DragStart = Vector2.new(0, 0)
    self.DragOffset = Vector2.new(0, 0)
    
    -- Create window frame
    self.Frame = Instance.new("Frame")
    self.Frame.Name = "MPB_Window"
    self.Frame.Size = self.Size
    self.Frame.Position = self.Position
    self.Frame.BackgroundColor3 = MPB.Config.Theme.Background
    self.Frame.BorderSizePixel = 0
    self.Frame.Parent = self.Library.ScreenGui
    
    -- Window shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 8, 1, 8)
    shadow.Position = UDim2.new(0, -4, 0, -4)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6015897848"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.3
    shadow.Parent = self.Frame
    
    -- Window background gradient
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, MPB.Config.Theme.Background),
        ColorSequenceKeypoint.new(1, MPB.Config.Theme.ElementBackground)
    })
    gradient.Rotation = 10
    gradient.Parent = self.Frame
    
    -- Window border
    local border = Instance.new("Frame")
    border.Name = "Border"
    border.Size = UDim2.new(1, 0, 1, 0)
    border.Position = UDim2.new(0, 1, 0, 1)
    border.BackgroundColor3 = MPB.Config.Theme.Border
    border.BorderSizePixel = 0
    border.Parent = self.Frame
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = MPB.Config.Theme.ElementBackground
    titleBar.BorderSizePixel = 0
    titleBar.Parent = self.Frame
    
    -- Title text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(1, -20, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = self.Title
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 14
    titleText.TextColor3 = MPB.Config.Theme.Text
    titleText.TextStrokeTransparency = 0.3
    titleText.TextStrokeColor3 = MPB.Config.Theme.Highlight
    titleText.Parent = titleBar
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(1, -30, 0, 5)
    closeButton.BackgroundColor3 = MPB.Config.Theme.Dark
    closeButton.BorderSizePixel = 0
    closeButton.Text = "×"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 16
    closeButton.TextColor3 = MPB.Config.Theme.TextLight
    closeButton.TextStrokeTransparency = 0.5
    closeButton.TextStrokeColor3 = MPB.Config.Theme.Highlight
    closeButton.Parent = titleBar
    
    -- Minimize button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.new(0, 20, 0, 20)
    minimizeButton.Position = UDim2.new(1, -55, 0, 5)
    minimizeButton.BackgroundColor3 = MPB.Config.Theme.Dark
    minimizeButton.BorderSizePixel = 0
    minimizeButton.Text = "−"
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.TextSize = 16
    minimizeButton.TextColor3 = MPB.Config.Theme.TextLight
    minimizeButton.TextStrokeTransparency = 0.5
    minimizeButton.TextStrokeColor3 = MPB.Config.Theme.Highlight
    minimizeButton.Parent = titleBar
    
    -- Tabs container
    local tabsContainer = Instance.new("Frame")
    tabsContainer.Name = "TabsContainer"
    tabsContainer.Size = UDim2.new(1, 0, 0, 30)
    tabsContainer.Position = UDim2.new(0, 0, 0, 30)
    tabsContainer.BackgroundColor3 = MPB.Config.Theme.ElementBackground
    tabsContainer.BorderSizePixel = 0
    tabsContainer.Parent = self.Frame
    
    -- Content container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, 0, 1, -60)
    contentContainer.Position = UDim2.new(0, 0, 0, 60)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = self.Frame
    
    -- Setup events
    self:SetupEvents(closeButton, minimizeButton, titleBar)
    
    -- Add to library
    table.insert(self.Library.Windows, self)
    self.Library.ActiveWindow = self
    
    return self
end

function MPB.Window:SetupEvents(closeButton, minimizeButton, titleBar)
    -- Close button
    closeButton.MouseButton1Click:Connect(function()
        self:Close()
    end)
    
    -- Minimize button
    minimizeButton.MouseButton1Click:Connect(function()
        self:Minimize()
    end)
    
    -- Drag functionality
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging = true
            self.DragStart = input.Position
            self.DragOffset = Vector2.new(
                self.Frame.AbsolutePosition.X - self.DragStart.X,
                self.Frame.AbsolutePosition.Y - self.DragStart.Y
            )
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and self.Dragging then
            local newPosition = Vector2.new(
                input.Position.X + self.DragOffset.X,
                input.Position.Y + self.DragOffset.Y
            )
            self.Frame.Position = UDim2.new(0, newPosition.X, 0, newPosition.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging = false
        end
    end)
end

function MPB.Window:CreateTab(name)
    local tab = MPB.Tab.new(self, name)
    table.insert(self.Tabs, tab)
    
    if #self.Tabs == 1 then
        self:SetActiveTab(tab)
    end
    
    return tab
end

function MPB.Window:SetActiveTab(tab)
    if self.ActiveTab then
        self.ActiveTab:Hide()
    end
    
    self.ActiveTab = tab
    tab:Show()
end

function MPB.Window:Show()
    self.Visible = true
    self.Frame.Visible = true
    
    -- Fade in animation
    self.Frame.BackgroundTransparency = 1
    local tween = CreateTween(self.Frame, {
        BackgroundTransparency = 0
    })
    tween:Play()
    
    -- Bring to front
    self.Frame.ZIndex = 10
    for _, window in ipairs(self.Library.Windows) do
        if window ~= self then
            window.Frame.ZIndex = window.Frame.ZIndex - 1
        end
    end
end

function MPB.Window:Hide()
    self.Visible = false
    self.Frame.Visible = false
end

function MPB.Window:Close()
    self:Hide()
    for i, window in ipairs(self.Library.Windows) do
        if window == self then
            table.remove(self.Library.Windows, i)
            break
        end
    end
    self.Frame:Destroy()
end

function MPB.Window:Minimize()
    if self.Frame.Size == UDim2.new(0, 800, 0, 30) then
        self.Frame.Size = self.Size
        self.TabsContainer.Visible = true
        self.ContentContainer.Visible = true
    else
        self.Frame.Size = UDim2.new(0, 800, 0, 30)
        self.TabsContainer.Visible = false
        self.ContentContainer.Visible = false
    end
end

-- Tab Class
MPB.Tab = {}
MPB.Tab.__index = MPB.Tab

function MPB.Tab.new(window, name)
    local self = setmetatable({}, MPB.Tab)
    self.Window = window
    self.Name = name
    self.Visible = false
    self.Elements = {}
    
    -- Create tab button
    self.TabButton = Instance.new("TextButton")
    self.TabButton.Name = "TabButton_" .. name
    self.TabButton.Size = UDim2.new(0, 100, 1, 0)
    self.TabButton.Position = UDim2.new(0, (#window.Tabs) * 105, 0, 0)
    self.TabButton.BackgroundColor3 = MPB.Config.Theme.Dark
    self.TabButton.BorderSizePixel = 0
    self.TabButton.Text = name
    self.TabButton.Font = Enum.Font.Gotham
    self.TabButton.TextSize = 12
    self.TabButton.TextColor3 = MPB.Config.Theme.TextLight
    self.TabButton.TextStrokeTransparency = 0.5
    self.TabButton.TextStrokeColor3 = MPB.Config.Theme.Highlight
    self.TabButton.Parent = window.TabsContainer
    
    -- Create tab content
    self.Content = Instance.new("Frame")
    self.Content.Name = "TabContent_" .. name
    self.Content.Size = UDim2.new(1, 0, 1, 0)
    self.Content.Position = UDim2.new(0, 0, 0, 0)
    self.Content.BackgroundTransparency = 1
    self.Content.Parent = window.ContentContainer
    
    -- Setup events
    self:SetupEvents()
    
    return self
end

function MPB.Tab:SetupEvents()
    self.TabButton.MouseButton1Click:Connect(function()
        self.Window:SetActiveTab(self)
    end)
    
    -- Hover effects
    self.TabButton.MouseEnter:Connect(function()
        local tween = CreateTween(self.TabButton, {
            BackgroundColor3 = MPB.Config.Theme.Primary
        })
        tween:Play()
    end)
    
    self.TabButton.MouseLeave:Connect(function()
        if self.Window.ActiveTab ~= self then
            local tween = CreateTween(self.TabButton, {
                BackgroundColor3 = MPB.Config.Theme.Dark
            })
            tween:Play()
        end
    end)
end

function MPB.Tab:Show()
    self.Visible = true
    self.Content.Visible = true
    self.TabButton.BackgroundColor3 = MPB.Config.Theme.Primary
    self.TabButton.TextColor3 = MPB.Config.Theme.White
    
    -- Hide other tabs
    for _, tab in ipairs(self.Window.Tabs) do
        if tab ~= self then
            tab:Hide()
        end
    end
end

function MPB.Tab:Hide()
    self.Visible = false
    self.Content.Visible = false
    if self.Window.ActiveTab ~= self then
        self.TabButton.BackgroundColor3 = MPB.Config.Theme.Dark
        self.TabButton.TextColor3 = MPB.Config.Theme.TextLight
    end
end

-- Button Class
MPB.Button = {}
MPB.Button.__index = MPB.Button

function MPB.Button.new(tab, text, position, size, callback)
    local self = setmetatable({}, MPB.Button)
    self.Tab = tab
    self.Text = text or "Button"
    self.Position = position or UDim2.new(0, 10, 0, 10)
    self.Size = size or UDim2.new(0, 120, 0, 30)
    self.Callback = callback
    self.Hovered = false
    self.Pressed = false
    
    -- Create button
    self.Button = Instance.new("TextButton")
    self.Button.Name = "Button_" .. text
    self.Button.Size = self.Size
    self.Button.Position = self.Position
    self.Button.BackgroundColor3 = MPB.Config.Theme.Dark
    self.Button.BorderSizePixel = 0
    self.Button.Text = self.Text
    self.Button.Font = Enum.Font.GothamBold
    self.Button.TextSize = 14
    self.Button.TextColor3 = MPB.Config.Theme.Text
    self.Button.TextStrokeTransparency = 0.3
    self.Button.TextStrokeColor3 = MPB.Config.Theme.Highlight
    self.Button.Parent = tab.Content
    
    -- Setup events
    self:SetupEvents()
    
    return self
end

function MPB.Button:SetupEvents()
    self.Button.MouseEnter:Connect(function()
        self.Hovered = true
        local tween = CreateTween(self.Button, {
            BackgroundColor3 = MPB.Config.Theme.Primary
        })
        tween:Play()
    end)
    
    self.Button.MouseLeave:Connect(function()
        self.Hovered = false
        if not self.Pressed then
            local tween = CreateTween(self.Button, {
                BackgroundColor3 = MPB.Config.Theme.Dark
            })
            tween:Play()
        end
    end)
    
    self.Button.MouseButton1Down:Connect(function()
        self.Pressed = true
        local tween = CreateTween(self.Button, {
            BackgroundColor3 = MPB.Config.Theme.Accent
        })
        tween:Play()
    end)
    
    self.Button.MouseButton1Up:Connect(function()
        self.Pressed = false
        if self.Hovered then
            local tween = CreateTween(self.Button, {
                BackgroundColor3 = MPB.Config.Theme.Primary
            })
            tween:Play()
        else
            local tween = CreateTween(self.Button, {
                BackgroundColor3 = MPB.Config.Theme.Dark
            })
            tween:Play()
        end
        
        if self.Callback then
            self.Callback()
        end
    end)
    
    self.Button.MouseButton1Click:Connect(function()
        if self.Callback then
            self.Callback()
        end
    end)
end

-- Label Class
MPB.Label = {}
MPB.Label.__index = MPB.Label

function MPB.Label.new(tab, text, position, size)
    local self = setmetatable({}, MPB.Label)
    self.Tab = tab
    self.Text = text or "Label"
    self.Position = position or UDim2.new(0, 10, 0, 10)
    self.Size = size or UDim2.new(0, 200, 0, 20)
    
    -- Create label
    self.Label = Instance.new("TextLabel")
    self.Label.Name = "Label_" .. text
    self.Label.Size = self.Size
    self.Label.Position = self.Position
    self.Label.BackgroundTransparency = 1
    self.Label.Text = self.Text
    self.Label.Font = Enum.Font.Gotham
    self.Label.TextSize = 14
    self.Label.TextColor3 = MPB.Config.Theme.Text
    self.Label.TextStrokeTransparency = 0.3
    self.Label.TextStrokeColor3 = MPB.Config.Theme.Highlight
    self.Label.Parent = tab.Content
    
    return self
end

-- TextBox Class
MPB.TextBox = {}
MPB.TextBox.__index = MPB.TextBox

function MPB.TextBox.new(tab, placeholder, position, size, callback)
    local self = setmetatable({}, MPB.TextBox)
    self.Tab = tab
    self.Placeholder = placeholder or "Enter text..."
    self.Position = position or UDim2.new(0, 10, 0, 10)
    self.Size = size or UDim2.new(0, 200, 0, 30)
    self.Callback = callback
    self.Focused = false
    
    -- Create textbox
    self.TextBox = Instance.new("TextBox")
    self.TextBox.Name = "TextBox"
    self.TextBox.Size = self.Size
    self.TextBox.Position = self.Position
    self.TextBox.BackgroundColor3 = MPB.Config.Theme.Dark
    self.TextBox.BorderSizePixel = 0
    self.TextBox.PlaceholderText = self.Placeholder
    self.TextBox.Font = Enum.Font.Gotham
    self.TextBox.TextSize = 14
    self.TextBox.TextColor3 = MPB.Config.Theme.Text
    self.TextBox.TextStrokeTransparency = 0.3
    self.TextBox.TextStrokeColor3 = MPB.Config.Theme.Highlight
    self.TextBox.ClearTextOnFocus = false
    self.TextBox.Parent = tab.Content
    
    -- Create UIStroke for border effect
    local stroke = Instance.new("UIStroke")
    stroke.Color = MPB.Config.Theme.Border
    stroke.Thickness = 1
    stroke.Parent = self.TextBox
    
    -- Setup events
    self:SetupEvents()
    
    return self
end

function MPB.TextBox:SetupEvents()
    self.TextBox.Focused:Connect(function()
        self.Focused = true
        local tween = CreateTween(self.TextBox, {
            BackgroundColor3 = MPB.Config.Theme.ElementBackground
        })
        tween:Play()
        
        local strokeTween = CreateTween(self.TextBox.UIStroke, {
            Color = MPB.Config.Theme.Primary
        })
        strokeTween:Play()
    end)
    
    self.TextBox.FocusLost:Connect(function(enterPressed)
        self.Focused = false
        local tween = CreateTween(self.TextBox, {
            BackgroundColor3 = MPB.Config.Theme.Dark
        })
        tween:Play()
        
        local strokeTween = CreateTween(self.TextBox.UIStroke, {
            Color = MPB.Config.Theme.Border
        })
        strokeTween:Play()
        
        if self.Callback and enterPressed then
            self.Callback(self.TextBox.Text)
        end
    end)
end

-- Slider Class
MPB.Slider = {}
MPB.Slider.__index = MPB.Slider

function MPB.Slider.new(tab, min, max, value, position, size, callback)
    local self = setmetatable({}, MPB.Slider)
    self.Tab = tab
    self.Min = min or 0
    self.Max = max or 100
    self.Value = value or 50
    self.Position = position or UDim2.new(0, 10, 0, 10)
    self.Size = size or UDim2.new(0, 200, 0, 20)
    self.Callback = callback
    self.Dragging = false
    
    -- Create slider container
    self.Container = Instance.new("Frame")
    self.Container.Name = "SliderContainer"
    self.Container.Size = self.Size
    self.Container.Position = self.Position
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = tab.Content
    
    -- Create slider track
    self.Track = Instance.new("Frame")
    self.Track.Name = "SliderTrack"
    self.Track.Size = UDim2.new(1, 0, 0, 4)
    self.Track.Position = UDim2.new(0, 0, 0.5, -2)
    self.Track.BackgroundColor3 = MPB.Config.Theme.Dark
    self.Track.BorderSizePixel = 0
    self.Track.Parent = self.Container
    
    -- Create slider fill
    self.Fill = Instance.new("Frame")
    self.Fill.Name = "SliderFill"
    self.Fill.Size = UDim2.new(0.5, 0, 1, 0)
    self.Fill.BackgroundColor3 = MPB.Config.Theme.Primary
    self.Fill.BorderSizePixel = 0
    self.Fill.Parent = self.Track
    
    -- Create slider thumb
    self.Thumb = Instance.new("Frame")
    self.Thumb.Name = "SliderThumb"
    self.Thumb.Size = UDim2.new(0, 16, 0, 16)
    self.Thumb.Position = UDim2.new(0.5, -8, 0.5, -8)
    self.Thumb.BackgroundColor3 = MPB.Config.Theme.White
    self.Thumb.BorderSizePixel = 0
    self.Thumb.Parent = self.Container
    
    -- Create value label
    self.ValueLabel = Instance.new("TextLabel")
    self.ValueLabel.Name = "ValueLabel"
    self.ValueLabel.Size = UDim2.new(0, 50, 0, 20)
    self.ValueLabel.Position = UDim2.new(1, 10, 0, -10)
    self.ValueLabel.BackgroundTransparency = 1
    self.ValueLabel.Text = tostring(self.Value)
    self.ValueLabel.Font = Enum.Font.GothamBold
    self.ValueLabel.TextSize = 14
    self.ValueLabel.TextColor3 = MPB.Config.Theme.Text
    self.ValueLabel.TextStrokeTransparency = 0.3
    self.ValueLabel.TextStrokeColor3 = MPB.Config.Theme.Highlight
    self.ValueLabel.Parent = self.Container
    
    -- Setup events
    self:SetupEvents()
    self:UpdateValue(self.Value)
    
    return self
end

function MPB.Slider:SetupEvents()
    self.Thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if self.Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = Vector2.new(input.Position.X, input.Position.Y)
            local trackPos = self.Track.AbsolutePosition
            local trackSize = self.Track.AbsoluteSize
            local relativeX = mousePos.X - trackPos.X
            
            if relativeX < 0 then relativeX = 0 end
            if relativeX > trackSize.X then relativeX = trackSize.X end
            
            local percentage = relativeX / trackSize.X
            local newValue = self.Min + (self.Max - self.Min) * percentage
            self:UpdateValue(newValue)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging = false
        end
    end)
end

function MPB.Slider:UpdateValue(value)
    self.Value = math.clamp(value, self.Min, self.Max)
    local percentage = (self.Value - self.Min) / (self.Max - self.Min)
    
    -- Update fill
    self.Fill:TweenSize(UDim2.new(percentage, 0, 1, 0), Enum.Direction.Left, 0, true, 0.1)
    
    -- Update thumb position
    self.Thumb:TweenPosition(UDim2.new(percentage, -8, 0.5, -8), Enum.Direction.Left, 0, true, 0.1)
    
    -- Update value label
    self.ValueLabel.Text = tostring(math.floor(self.Value))
    
    if self.Callback then
        self.Callback(self.Value)
    end
end

-- Toggle Class
MPB.Toggle = {}
MPB.Toggle.__index = MPB.Toggle

function MPB.Toggle.new(tab, text, defaultValue, position, callback)
    local self = setmetatable({}, MPB.Toggle)
    self.Tab = tab
    self.Text = text or "Toggle"
    self.DefaultValue = defaultValue or false
    self.Value = self.DefaultValue
    self.Position = position or UDim2.new(0, 10, 0, 10)
    self.Callback = callback
    
    -- Create container
    self.Container = Instance.new("Frame")
    self.Container.Name = "ToggleContainer"
    self.Container.Size = UDim2.new(0, 200, 0, 30)
    self.Container.Position = self.Position
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = tab.Content
    
    -- Create label
    self.Label = Instance.new("TextLabel")
    self.Label.Name = "ToggleLabel"
    self.Label.Size = UDim2.new(0.7, 0, 1, 0)
    self.Label.Position = UDim2.new(0, 0, 0, 0)
    self.Label.BackgroundTransparency = 1
    self.Label.Text = self.Text
    self.Label.Font = Enum.Font.Gotham
    self.Label.TextSize = 14
    self.Label.TextColor3 = MPB.Config.Theme.Text
    self.Label.TextStrokeTransparency = 0.3
    self.Label.TextStrokeColor3 = MPB.Config.Theme.Highlight
    self.Label.Parent = self.Container
    
    -- Create toggle button
    self.ToggleButton = Instance.new("Frame")
    self.ToggleButton.Name = "ToggleButton"
    self.ToggleButton.Size = UDim2.new(0, 40, 0, 20)
    self.ToggleButton.Position = UDim2.new(0.7, 10, 0.5, -10)
    self.ToggleButton.BackgroundColor3 = self.Value and MPB.Config.Theme.Primary or MPB.Config.Theme.Dark
    self.ToggleButton.BorderSizePixel = 0
    self.ToggleButton.Parent = self.Container
    
    -- Create toggle knob
    self.Knob = Instance.new("Frame")
    self.Knob.Name = "ToggleKnob"
    self.Knob.Size = UDim2.new(0, 16, 0, 16)
    self.Knob.Position = UDim2.new(self.Value and 1 or 0, -8, 0.5, -8)
    self.Knob.BackgroundColor3 = MPB.Config.Theme.White
    self.Knob.BorderSizePixel = 0
    self.Knob.Parent = self.ToggleButton
    
    -- Setup events
    self:SetupEvents()
    
    return self
end

function MPB.Toggle:SetupEvents()
    self.Container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self:Toggle()
        end
    end)
    
    self.ToggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self:Toggle()
        end
    end)
end

function MPB.Toggle:Toggle()
    self.Value = not self.Value
    
    -- Animate toggle button
    local targetColor = self.Value and MPB.Config.Theme.Primary or MPB.Config.Theme.Dark
    local targetPosition = self.Value and UDim2.new(1, -8, 0.5, -8) or UDim2.new(0, -8, 0.5, -8)
    
    local colorTween = CreateTween(self.ToggleButton, {
        BackgroundColor3 = targetColor
    })
    colorTween:Play()
    
    local positionTween = CreateTween(self.Knob, {
        Position = targetPosition
    })
    positionTween:Play()
    
    if self.Callback then
        self.Callback(self.Value)
    end
end

-- Dropdown Class
MPB.Dropdown = {}
MPB.Dropdown.__index = MPB.Dropdown

function MPB.Dropdown.new(tab, options, defaultValue, position, size, callback)
    local self = setmetatable({}, MPB.Dropdown)
    self.Tab = tab
    self.Options = options or {"Option 1", "Option 2", "Option 3"}
    self.DefaultValue = defaultValue or 1
    self.Value = self.DefaultValue
    self.Position = position or UDim2.new(0, 10, 0, 10)
    self.Size = size or UDim2.new(0, 200, 0, 30)
    self.Callback = callback
    self.Open = false
    
    -- Create dropdown container
    self.Container = Instance.new("Frame")
    self.Container.Name = "DropdownContainer"
    self.Container.Size = self.Size
    self.Container.Position = self.Position
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = tab.Content
    
    -- Create dropdown button
    self.Button = Instance.new("TextButton")
    self.Button.Name = "DropdownButton"
    self.Button.Size = UDim2.new(1, 0, 1, 0)
    self.Button.BackgroundColor3 = MPB.Config.Theme.Dark
    self.Button.BorderSizePixel = 0
    self.Button.Text = self.Options[self.Value]
    self.Button.Font = Enum.Font.Gotham
    self.Button.TextSize = 14
    self.Button.TextColor3 = MPB.Config.Theme.Text
    self.Button.TextStrokeTransparency = 0.3
    self.Button.TextStrokeColor3 = MPB.Config.Theme.Highlight
    self.Button.Parent = self.Container
    
    -- Create dropdown arrow
    self.Arrow = Instance.new("TextLabel")
    self.Arrow.Name = "DropdownArrow"
    self.Arrow.Size = UDim2.new(0, 20, 0, 20)
    self.Arrow.Position = UDim2.new(1, -30, 0.5, -10)
    self.Arrow.AnchorPoint = Vector2.new(1, 0.5)
    self.Arrow.BackgroundTransparency = 1
    self.Arrow.Text = "▼"
    self.Arrow.Font = Enum.Font.GothamBold
    self.Arrow.TextSize = 16
    self.Arrow.TextColor3 = MPB.Config.Theme.TextLight
    self.Arrow.TextStrokeTransparency = 0.5
    self.Arrow.TextStrokeColor3 = MPB.Config.Theme.Highlight
    self.Arrow.Parent = self.Button
    
    -- Create dropdown list
    self.List = Instance.new("Frame")
    self.List.Name = "DropdownList"
    self.List.Size = UDim2.new(1, 0, 0, #self.Options * 30)
    self.List.Position = UDim2.new(0, 0, 1, 0)
    self.List.BackgroundColor3 = MPB.Config.Theme.ElementBackground
    self.List.BorderSizePixel = 0
    self.List.Visible = false
    self.List.Parent = self.Container
    
    -- Create list items
    self.ListItems = {}
    for i, option in ipairs(self.Options) do
        local item = Instance.new("TextButton")
        item.Name = "ListItem_" .. i
        item.Size = UDim2.new(1, 0, 0, 30)
        item.Position = UDim2.new(0, 0, 0, (i-1) * 30)
        item.BackgroundColor3 = MPB.Config.Theme.Dark
        item.BorderSizePixel = 0
        item.Text = option
        item.Font = Enum.Font.Gotham
        item.TextSize = 14
        item.TextColor3 = MPB.Config.Theme.TextLight
        item.TextStrokeTransparency = 0.5
        item.TextStrokeColor3 = MPB.Config.Theme.Highlight
        item.Parent = self.List
        
        -- Setup item events
        item.MouseEnter:Connect(function()
            local tween = CreateTween(item, {
                BackgroundColor3 = MPB.Config.Theme.Primary
            })
            tween:Play()
        end)
        
        item.MouseLeave:Connect(function()
            local tween = CreateTween(item, {
                BackgroundColor3 = MPB.Config.Theme.Dark
            })
            tween:Play()
        end)
        
        item.MouseButton1Click:Connect(function()
            self:SetValue(i)
            self:Close()
        end)
        
        table.insert(self.ListItems, item)
    end
    
    -- Setup events
    self:SetupEvents()
    
    return self
end

function MPB.Dropdown:SetupEvents()
    self.Button.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    self.Button.MouseEnter:Connect(function()
        local tween = CreateTween(self.Button, {
            BackgroundColor3 = MPB.Config.Theme.Primary
        })
        tween:Play()
    end)
    
    self.Button.MouseLeave:Connect(function()
        if not self.Open then
            local tween = CreateTween(self.Button, {
                BackgroundColor3 = MPB.Config.Theme.Dark
            })
            tween:Play()
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and self.Open then
            local mousePos = Vector2.new(input.Position.X, input.Position.Y)
            local listPos = self.List.AbsolutePosition
            local listSize = self.List.AbsoluteSize
            
            if mousePos.X < listPos.X or mousePos.X > listPos.X + listSize.X or
               mousePos.Y < listPos.Y or mousePos.Y > listPos.Y + listSize.Y then
                self:Close()
            end
        end
    end)
end

function MPB.Dropdown:Toggle()
    self.Open = not self.Open
    self.List.Visible = self.Open
    
    if self.Open then
        self.List:TweenSize(UDim2.new(1, 0, 0, #self.Options * 30), Enum.Direction.Down, 0, true, 0.2)
    else
        self.List:TweenSize(UDim2.new(1, 0, 0, 0), Enum.Direction.Up, 0, true, 0.2)
    end
end

function MPB.Dropdown:Close()
    self.Open = false
    self.List:TweenSize(UDim2.new(1, 0, 0, 0), Enum.Direction.Up, 0, true, 0.2)
    task.wait(0.2)
    self.List.Visible = false
end

function MPB.Dropdown:SetValue(index)
    self.Value = index
    self.Button.Text = self.Options[index]
    
    -- Update button color
    local tween = CreateTween(self.Button, {
        BackgroundColor3 = MPB.Config.Theme.Primary
    })
    tween:Play()
    
    task.wait(0.2)
    
    if not self.Open then
        local tween2 = CreateTween(self.Button, {
            BackgroundColor3 = MPB.Config.Theme.Dark
        })
        tween2:Play()
    end
    
    if self.Callback then
        self.Callback(index)
    end
end

-- ColorPicker Class
MPB.ColorPicker = {}
MPB.ColorPicker.__index = MPB.ColorPicker

function MPB.ColorPicker.new(tab, defaultValue, position, size, callback)
    local self = setmetatable({}, MPB.ColorPicker)
    self.Tab = tab
    self.DefaultValue = defaultValue or Color3.fromRGB(138, 43, 226)
    self.Value = self.DefaultValue
    self.Position = position or UDim2.new(0, 10, 0, 10)
    self.Size = size or UDim2.new(0, 200, 0, 30)
    self.Callback = callback
    self.Open = false
    
    -- Create container
    self.Container = Instance.new("Frame")
    self.Container.Name = "ColorPickerContainer"
    self.Container.Size = self.Size
    self.Container.Position = self.Position
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = tab.Content
    
    -- Create color display
    self.ColorDisplay = Instance.new("Frame")
    self.ColorDisplay.Name = "ColorDisplay"
    self.ColorDisplay.Size = UDim2.new(0, 30, 1, 0)
    self.ColorDisplay.Position = UDim2.new(0, 0, 0, 0)
    self.ColorDisplay.BackgroundColor3 = self.Value
    self.ColorDisplay.BorderSizePixel = 0
    self.ColorDisplay.Parent = self.Container
    
    -- Create color label
    self.Label = Instance.new("TextLabel")
    self.Label.Name = "ColorLabel"
    self.Label.Size = UDim2.new(1, -40, 1, 0)
    self.Label.Position = UDim2.new(0, 40, 0, 0)
    self.Label.BackgroundTransparency = 1
    self.Label.Text = "Color"
    self.Label.Font = Enum.Font.Gotham
    self.Label.TextSize = 14
    self.Label.TextColor3 = MPB.Config.Theme.Text
    self.Label.TextStrokeTransparency = 0.3
    self.Label.TextStrokeColor3 = MPB.Config.Theme.Highlight
    self.Label.Parent = self.Container
    
    -- Create color picker button
    self.Button = Instance.new("TextButton")
    self.Button.Name = "ColorPickerButton"
    self.Button.Size = UDim2.new(0, 20, 0, 20)
    self.Button.Position = UDim2.new(1, -30, 0.5, -10)
    self.Button.AnchorPoint = Vector2.new(1, 0.5)
    self.Button.BackgroundColor3 = MPB.Config.Theme.Dark
    self.Button.BorderSizePixel = 0
    self.Button.Text = "▼"
    self.Button.Font = Enum.Font.GothamBold
    self.Button.TextSize = 16
    self.Button.TextColor3 = MPB.Config.Theme.TextLight
    self.Button.TextStrokeTransparency = 0.5
    self.Button.TextStrokeColor3 = MPB.Config.Theme.Highlight
    self.Button.Parent = self.Container
    
    -- Create color picker panel
    self.Panel = Instance.new("Frame")
    self.Panel.Name = "ColorPickerPanel"
    self.Panel.Size = UDim2.new(0, 250, 0, 200)
    self.Panel.Position = UDim2.new(1, 10, 0, 0)
    self.Panel.BackgroundColor3 = MPB.Config.Theme.ElementBackground
    self.Panel.BorderSizePixel = 0
    self.Panel.Visible = false
    self.Panel.Parent = self.Container
    
    -- Create hue slider
    self.HueSlider = MPB.Slider.new(self.Panel, 0, 360, 0, UDim2.new(0, 20, 0, 150), UDim2.new(0, 30, 0, 150), function(value)
        self:UpdateColor()
    end)
    
    -- Create saturation/brightness area
    self.ColorArea = Instance.new("ImageLabel")
    self.ColorArea.Name = "ColorArea"
    self.ColorArea.Size = UDim2.new(1, -40, 1, -40)
    self.ColorArea.Position = UDim2.new(0, 40, 0, 20)
    self.ColorArea.BackgroundColor3 = MPB.Config.Theme.Dark
    self.ColorArea.BorderSizePixel = 0
    self.ColorArea.Image = "rbxassetid://3572486092"
    self.ColorArea.ImageColor3 = Color3.new(1, 1, 1)
    self.ColorArea.Parent = self.Panel
    
    -- Create color cursor
    self.ColorCursor = Instance.new("Frame")
    self.ColorCursor.Name = "ColorCursor"
    self.ColorCursor.Size = UDim2.new(0, 10, 0, 10)
    self.ColorCursor.BackgroundColor3 = MPB.Config.Theme.White
    self.ColorCursor.BorderSizePixel = 2
    self.ColorCursor.BorderColor3 = MPB.Config.Theme.Black
    self.ColorCursor.Parent = self.ColorArea
    
    -- Create hex input
    self.HexInput = MPB.TextBox.new(self.Panel, "#8888EE", UDim2.new(0, 10, 1, 0), UDim2.new(0, 200, 0, 30), function(text)
        self:ParseHex(text)
    end)
    
    -- Setup events
    self:SetupEvents()
    
    return self
end

function MPB.ColorPicker:SetupEvents()
    self.Button.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    self.ColorArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self:UpdateFromColorArea(input)
        end
    end)
    
    self.ColorArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            self:UpdateFromColorArea(input)
        end
    end)
end

function MPB.ColorPicker:Toggle()
    self.Open = not self.Open
    self.Panel.Visible = self.Open
    
    if self.Open then
        self.Panel:TweenSize(UDim2.new(0, 250, 0, 200), Enum.Direction.Down, 0, true, 0.2)
    else
        self.Panel:TweenSize(UDim2.new(0, 250, 0, 0), Enum.Direction.Up, 0, true, 0.2)
    end
end

function MPB.ColorPicker:UpdateFromColorArea(input)
    local mousePos = Vector2.new(input.Position.X, input.Position.Y)
    local areaPos = self.ColorArea.AbsolutePosition
    local areaSize = self.ColorArea.AbsoluteSize
    
    local x = math.clamp(mousePos.X - areaPos.X, 0, areaSize.X)
    local y = math.clamp(mousePos.Y - areaPos.Y, 0, areaSize.Y)
    
    local saturation = x / areaSize.X
    local brightness = 1 - (y / areaSize.Y)
    
    local hue = self.HueSlider.Value / 360
    local r, g, b = HSVToRGB(hue, saturation, brightness)
    
    self.ColorCursor:TweenPosition(UDim2.new(saturation, -5, 1 - brightness, -5), Enum.Direction.Left, 0, true, 0.1)
    
    self.Value = Color3.new(r, g, b)
    self.ColorDisplay.BackgroundColor3 = self.Value
    self:UpdateHex()
    
    if self.Callback then
        self.Callback(self.Value)
    end
end

function MPB.ColorPicker:UpdateColor()
    local hue = self.HueSlider.Value / 360
    local saturation = 1
    local brightness = 1
    
    local r, g, b = HSVToRGB(hue, saturation, brightness)
    self.ColorArea.ImageColor3 = Color3.new(r, g, b)
    self:UpdateHex()
    
    if self.Callback then
        self.Callback(self.Value)
    end
end

function MPB.ColorPicker:UpdateHex()
    local r, g, b = math.floor(self.Value.R * 255), math.floor(self.Value.G * 255), math.floor(self.Value.B * 255)
    self.HexInput.TextBox.Text = string.format("#%02X%02X%02X", r, g, b)
end

function MPB.ColorPicker:ParseHex(hex)
    local r, g, b = tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
    if r and g and b then
        self.Value = Color3.fromRGB(r, g, b)
        self.ColorDisplay.BackgroundColor3 = self.Value
        self:UpdateFromRGB(r, g, b)
    end
end

function MPB.ColorPicker:UpdateFromRGB(r, g, b)
    local h, s, v = RGBToHSV(r/255, g/255, b/255)
    self.HueSlider:UpdateValue(h * 360)
    
    local saturation = s
    local brightness = v
    
    self.ColorCursor:TweenPosition(UDim2.new(saturation, -5, 1 - brightness, -5), Enum.Direction.Left, 0, true, 0.1)
    
    if self.Callback then
        self.Callback(self.Value)
    end
end

-- Notification System
MPB.Notifications = {}
MPB.Notifications.__index = MPB.Notifications

function MPB.Notifications:Show(title, text, duration, type)
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 300, 0, 80)
    notification.Position = UDim2.new(1, -320, 0, 100)
    notification.BackgroundColor3 = MPB.Config.Theme.ElementBackground
    notification.BorderSizePixel = 0
    notification.Parent = MPB.Library.ScreenGui
    
    -- Notification icon
    local icon = Instance.new("TextLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 40, 0, 40)
    icon.Position = UDim2.new(0, 10, 0.5, -20)
    icon.AnchorPoint = Vector2.new(0, 0.5)
    icon.BackgroundTransparency = 1
    icon.Text = type == "success" and "✓" or type == "error" and "✕" or "ℹ"
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 24
    icon.TextColor3 = type == "success" and Color3.fromRGB(78, 205, 196) or 
                    type == "error" and Color3.fromRGB(255, 107, 107) or 
                    MPB.Config.Theme.Primary
    icon.TextStrokeTransparency = 0.3
    icon.TextStrokeColor3 = MPB.Config.Theme.Highlight
    icon.Parent = notification
    
    -- Notification title
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(1, -60, 0, 20)
    titleText.Position = UDim2.new(0, 60, 0, 10)
    titleText.BackgroundTransparency = 1
    titleText.Text = title or "Notification"
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 14
    titleText.TextColor3 = MPB.Config.Theme.Text
    titleText.TextStrokeTransparency = 0.3
    titleText.TextStrokeColor3 = MPB.Config.Theme.Highlight
    titleText.Parent = notification
    
    -- Notification text
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "TextLabel"
    textLabel.Size = UDim2.new(1, -60, 0, 20)
    textLabel.Position = UDim2.new(0, 60, 0, 35)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text or "This is a notification"
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 12
    textLabel.TextColor3 = MPB.Config.Theme.TextLight
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextStrokeColor3 = MPB.Config.Theme.Highlight
    textLabel.TextWrapped = true
    textLabel.Parent = notification
    
    -- Slide in animation
    notification:TweenPosition(UDim2.new(1, -320, 0, 100), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
    
    -- Auto hide
    task.wait(duration or 3)
    
    -- Slide out animation
    notification:TweenPosition(UDim2.new(1, 0, 0, 100), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.3, true)
    
    task.wait(0.3)
    notification:Destroy()
end

-- Export the library
return MPB

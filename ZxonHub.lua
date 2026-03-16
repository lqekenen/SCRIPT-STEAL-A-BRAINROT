local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local ZxonHub = Instance.new("ScreenGui")
ZxonHub.Parent = LocalPlayer:WaitForChild("PlayerGui")
ZxonHub.ResetOnSpawn = true
ZxonHub.Name = "ZxonHub"
ZxonHub.IgnoreGuiInset = true
ZxonHub.Enabled = true

local GOLD_LIGHT    = Color3.fromRGB(255, 215, 0)
local GOLD_DARK     = Color3.fromRGB(180, 140, 0)
local GOLD_DIM      = Color3.fromRGB(120, 95, 10)
local BG_DARK       = Color3.fromRGB(22, 20, 10)
local BG_MID        = Color3.fromRGB(32, 28, 14)
local BG_PANEL      = Color3.fromRGB(28, 24, 10)
local TEXT_WHITE    = Color3.fromRGB(255, 248, 220)
local BTN_OFF       = Color3.fromRGB(60, 50, 20)
local BTN_ON        = Color3.fromRGB(200, 160, 0)

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ZxonHub
MainFrame.BackgroundColor3 = BG_DARK
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Size = UDim2.new(0.44, 0, 0.52, 0)
MainFrame.Visible = true
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.Parent = MainFrame
MainCorner.CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color = GOLD_LIGHT
MainStroke.Thickness = 2.5

local ShimmerBar = Instance.new("Frame")
ShimmerBar.Parent = MainFrame
ShimmerBar.BackgroundColor3 = GOLD_LIGHT
ShimmerBar.Size = UDim2.new(1, 0, 0.008, 0)
ShimmerBar.Position = UDim2.new(0, 0, 0, 0)
ShimmerBar.BorderSizePixel = 0
ShimmerBar.ZIndex = 5

local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.BackgroundColor3 = BG_MID
Header.Size = UDim2.new(1, 0, 0.135, 0)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BorderSizePixel = 0
Header.ZIndex = 2

local HeaderBottomStroke = Instance.new("Frame")
HeaderBottomStroke.Parent = Header
HeaderBottomStroke.BackgroundColor3 = GOLD_DARK
HeaderBottomStroke.Size = UDim2.new(1, 0, 0.04, 0)
HeaderBottomStroke.Position = UDim2.new(0, 0, 1, -2)
HeaderBottomStroke.BorderSizePixel = 0
HeaderBottomStroke.ZIndex = 3

local LogoLabel = Instance.new("TextLabel")
LogoLabel.Parent = Header
LogoLabel.BackgroundTransparency = 1
LogoLabel.Position = UDim2.new(0.02, 0, 0.1, 0)
LogoLabel.Size = UDim2.new(0.06, 0, 0.8, 0)
LogoLabel.Font = Enum.Font.GothamBold
LogoLabel.TextScaled = true
LogoLabel.TextColor3 = GOLD_LIGHT
LogoLabel.Text = "⬡"
LogoLabel.ZIndex = 3

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = Header
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0.09, 0, 0.08, 0)
TitleLabel.Size = UDim2.new(0.6, 0, 0.84, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextScaled = true
TitleLabel.TextColor3 = GOLD_LIGHT
TitleLabel.TextStrokeTransparency = 0.5
TitleLabel.TextStrokeColor3 = GOLD_DARK
TitleLabel.Text = "ZXON HUB"
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 3

local TitleStroke = Instance.new("UIStroke")
TitleStroke.Parent = TitleLabel
TitleStroke.Color = GOLD_DARK
TitleStroke.Thickness = 1.5

local MinBtn = Instance.new("TextButton")
MinBtn.Parent = Header
MinBtn.BackgroundColor3 = BTN_OFF
MinBtn.Position = UDim2.new(0.755, 0, 0.15, 0)
MinBtn.Size = UDim2.new(0.1, 0, 0.7, 0)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextScaled = true
MinBtn.Text = "-"
MinBtn.TextColor3 = GOLD_LIGHT
MinBtn.TextStrokeTransparency = 1
MinBtn.ZIndex = 4

local MinBtnCorner = Instance.new("UICorner")
MinBtnCorner.Parent = MinBtn
MinBtnCorner.CornerRadius = UDim.new(0, 6)

local MinBtnStroke = Instance.new("UIStroke")
MinBtnStroke.Parent = MinBtn
MinBtnStroke.Color = GOLD_DARK
MinBtnStroke.Thickness = 1.5

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Header
CloseBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 10)
CloseBtn.Position = UDim2.new(0.87, 0, 0.15, 0)
CloseBtn.Size = UDim2.new(0.1, 0, 0.7, 0)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextScaled = true
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 120, 60)
CloseBtn.TextStrokeTransparency = 1
CloseBtn.ZIndex = 4

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.Parent = CloseBtn
CloseBtnCorner.CornerRadius = UDim.new(0, 6)

local CloseBtnStroke = Instance.new("UIStroke")
CloseBtnStroke.Parent = CloseBtn
CloseBtnStroke.Color = Color3.fromRGB(180, 60, 20)
CloseBtnStroke.Thickness = 1.5

local RestoreButton = Instance.new("TextButton")
RestoreButton.Parent = ZxonHub
RestoreButton.BackgroundColor3 = BG_DARK
RestoreButton.Position = UDim2.new(0.92, 0, 0.48, 0)
RestoreButton.Size = UDim2.new(0.065, 0, 0.055, 0)
RestoreButton.Font = Enum.Font.GothamBold
RestoreButton.TextScaled = true
RestoreButton.Text = "Z"
RestoreButton.TextColor3 = GOLD_LIGHT
RestoreButton.TextStrokeTransparency = 1
RestoreButton.Visible = false
RestoreButton.ZIndex = 10

local RestoreCorner = Instance.new("UICorner")
RestoreCorner.Parent = RestoreButton
RestoreCorner.CornerRadius = UDim.new(1, 0)

local RestoreStroke = Instance.new("UIStroke")
RestoreStroke.Parent = RestoreButton
RestoreStroke.Color = GOLD_LIGHT
RestoreStroke.Thickness = 2

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    RestoreButton.Visible = true
end)
RestoreButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    RestoreButton.Visible = false
end)
CloseBtn.MouseButton1Click:Connect(function()
    ZxonHub:Destroy()
end)

local Sidebar = Instance.new("Frame")
Sidebar.Parent = MainFrame
Sidebar.BackgroundColor3 = BG_MID
Sidebar.Position = UDim2.new(0, 0, 0.135, 0)
Sidebar.Size = UDim2.new(0.22, 0, 0.73, 0)
Sidebar.BorderSizePixel = 0

local SidebarRightLine = Instance.new("Frame")
SidebarRightLine.Parent = Sidebar
SidebarRightLine.BackgroundColor3 = GOLD_DARK
SidebarRightLine.Position = UDim2.new(1, -2, 0, 0)
SidebarRightLine.Size = UDim2.new(0, 2, 1, 0)
SidebarRightLine.BorderSizePixel = 0

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = Sidebar
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0.02, 0)
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.Parent = Sidebar
SidebarPadding.PaddingTop = UDim.new(0.04, 0)

local activeTabBtn = nil

local function setTabActive(btn)
    if activeTabBtn then
        TweenService:Create(activeTabBtn, TweenInfo.new(0.15), {
            BackgroundColor3 = BTN_OFF,
            TextColor3 = GOLD_DIM
        }):Play()
    end
    activeTabBtn = btn
    TweenService:Create(btn, TweenInfo.new(0.15), {
        BackgroundColor3 = BTN_ON,
        TextColor3 = BG_DARK
    }):Play()
end

local function createTabButton(label, icon)
    local btn = Instance.new("TextButton")
    btn.Parent = Sidebar
    btn.BackgroundColor3 = BTN_OFF
    btn.Size = UDim2.new(0.85, 0, 0, 30)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Text = icon .. "  " .. label
    btn.TextColor3 = GOLD_DIM
    btn.TextStrokeTransparency = 1
    btn.AutoButtonColor = false

    local c = Instance.new("UICorner")
    c.Parent = btn
    c.CornerRadius = UDim.new(0, 7)

    local s = Instance.new("UIStroke")
    s.Parent = btn
    s.Color = GOLD_DARK
    s.Thickness = 1.2

    btn.MouseEnter:Connect(function()
        if btn ~= activeTabBtn then
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 65, 20)}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if btn ~= activeTabBtn then
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = BTN_OFF}):Play()
        end
    end)

    return btn
end

local function createTabPanel()
    local panel = Instance.new("ScrollingFrame")
    panel.Parent = MainFrame
    panel.BackgroundTransparency = 1
    panel.Position = UDim2.new(0.23, 0, 0.14, 0)
    panel.Size = UDim2.new(0.75, 0, 0.72, 0)
    panel.Visible = false
    panel.ScrollBarThickness = 3
    panel.ScrollBarImageColor3 = GOLD_DARK
    panel.CanvasSize = UDim2.new(0, 0, 0, 0)
    panel.AutomaticCanvasSize = Enum.AutomaticSize.Y
    panel.BorderSizePixel = 0

    local layout = Instance.new("UIListLayout")
    layout.Parent = panel
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)

    local padding = Instance.new("UIPadding")
    padding.Parent = panel
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 6)
    padding.PaddingRight = UDim.new(0, 6)

    return panel
end

local function createFeatureButton(parent, labelText, callback)
    local row = Instance.new("Frame")
    row.Parent = parent
    row.BackgroundColor3 = BG_PANEL
    row.Size = UDim2.new(1, 0, 0, 38)
    row.BorderSizePixel = 0

    local rowCorner = Instance.new("UICorner")
    rowCorner.Parent = row
    rowCorner.CornerRadius = UDim.new(0, 8)

    local rowStroke = Instance.new("UIStroke")
    rowStroke.Parent = row
    rowStroke.Color = GOLD_DARK
    rowStroke.Thickness = 1.2

    local dot = Instance.new("Frame")
    dot.Parent = row
    dot.BackgroundColor3 = Color3.fromRGB(80, 60, 10)
    dot.Position = UDim2.new(0.03, 0, 0.5, -7)
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.BorderSizePixel = 0

    local dotCorner = Instance.new("UICorner")
    dotCorner.Parent = dot
    dotCorner.CornerRadius = UDim.new(1, 0)

    local dotStroke = Instance.new("UIStroke")
    dotStroke.Parent = dot
    dotStroke.Color = GOLD_DARK
    dotStroke.Thickness = 1.5

    local lbl = Instance.new("TextLabel")
    lbl.Parent = row
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0.12, 0, 0.1, 0)
    lbl.Size = UDim2.new(0.55, 0, 0.8, 0)
    lbl.Font = Enum.Font.Gotham
    lbl.TextScaled = true
    lbl.TextColor3 = TEXT_WHITE
    lbl.TextStrokeTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = labelText

    local pill = Instance.new("TextButton")
    pill.Parent = row
    pill.BackgroundColor3 = BTN_OFF
    pill.Position = UDim2.new(0.68, 0, 0.18, 0)
    pill.Size = UDim2.new(0.28, 0, 0.64, 0)
    pill.Font = Enum.Font.GothamBold
    pill.TextScaled = true
    pill.Text = "OFF"
    pill.TextColor3 = GOLD_DIM
    pill.TextStrokeTransparency = 1
    pill.AutoButtonColor = false

    local pillCorner = Instance.new("UICorner")
    pillCorner.Parent = pill
    pillCorner.CornerRadius = UDim.new(1, 0)

    local pillStroke = Instance.new("UIStroke")
    pillStroke.Parent = pill
    pillStroke.Color = GOLD_DARK
    pillStroke.Thickness = 1.5

    local isOn = false
    pill.MouseButton1Click:Connect(function()
        isOn = not isOn
        if isOn then
            TweenService:Create(pill, TweenInfo.new(0.18), {BackgroundColor3 = BTN_ON, TextColor3 = BG_DARK}):Play()
            TweenService:Create(dot, TweenInfo.new(0.18), {BackgroundColor3 = GOLD_LIGHT}):Play()
            TweenService:Create(rowStroke, TweenInfo.new(0.18), {Color = GOLD_LIGHT}):Play()
            pill.Text = "ON"
            pillStroke.Color = GOLD_LIGHT
        else
            TweenService:Create(pill, TweenInfo.new(0.18), {BackgroundColor3 = BTN_OFF, TextColor3 = GOLD_DIM}):Play()
            TweenService:Create(dot, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(80, 60, 10)}):Play()
            TweenService:Create(rowStroke, TweenInfo.new(0.18), {Color = GOLD_DARK}):Play()
            pill.Text = "OFF"
            pillStroke.Color = GOLD_DARK
        end
        if callback then callback(isOn) end
    end)

    return row
end

local function createSection(parent, text)
    local lbl = Instance.new("TextLabel")
    lbl.Parent = parent
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextScaled = true
    lbl.TextColor3 = GOLD_DARK
    lbl.TextStrokeTransparency = 1
    lbl.Text = ">  " .. string.upper(text)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
end

local MainTabBtn   = createTabButton("Main",   "!")
local ESPTabBtn    = createTabButton("ESP",    "@")
local HelperTabBtn = createTabButton("Helper", "#")

local MainPanel   = createTabPanel()
local ESPPanel    = createTabPanel()
local HelperPanel = createTabPanel()

createSection(MainPanel, "Combat")
createFeatureButton(MainPanel, "Auto Kick")
createFeatureButton(MainPanel, "Anti Ragdoll")
createFeatureButton(MainPanel, "Anti Sentry")
createSection(MainPanel, "Network")
createFeatureButton(MainPanel, "Desync", function(enabled)
    if enabled then
        task.spawn(function()
            setfflag("LargeReplicatorWrite5", "false")
            setfflag("LargeReplicatorEnabled9", "false")
            setfflag("AngularVelociryLimit", "180")
        end)
    end
end)

createSection(ESPPanel, "Visuals")
createFeatureButton(ESPPanel, "BestBrainrot")
createFeatureButton(ESPPanel, "Player ESP")
createFeatureButton(ESPPanel, "Timer")
createFeatureButton(ESPPanel, "WallHack")

createSection(HelperPanel, "Utilities")
createFeatureButton(HelperPanel, "Allow / Disallow")
createFeatureButton(HelperPanel, "Bat Destroyer")
createFeatureButton(HelperPanel, "Speed")

local function switchTab(btn, panel)
    for _, p in ipairs({MainPanel, ESPPanel, HelperPanel}) do
        p.Visible = false
    end
    panel.Visible = true
    setTabActive(btn)
end

MainTabBtn.MouseButton1Click:Connect(function()   switchTab(MainTabBtn, MainPanel) end)
ESPTabBtn.MouseButton1Click:Connect(function()    switchTab(ESPTabBtn, ESPPanel) end)
HelperTabBtn.MouseButton1Click:Connect(function() switchTab(HelperTabBtn, HelperPanel) end)

switchTab(MainTabBtn, MainPanel)

local Footer = Instance.new("Frame")
Footer.Parent = MainFrame
Footer.BackgroundColor3 = BG_MID
Footer.Position = UDim2.new(0, 0, 0.865, 0)
Footer.Size = UDim2.new(1, 0, 0.135, 0)
Footer.BorderSizePixel = 0

local FooterTopLine = Instance.new("Frame")
FooterTopLine.Parent = Footer
FooterTopLine.BackgroundColor3 = GOLD_DARK
FooterTopLine.Size = UDim2.new(1, 0, 0.03, 0)
FooterTopLine.Position = UDim2.new(0, 0, 0, 0)
FooterTopLine.BorderSizePixel = 0

local ProfileImage = Instance.new("ImageLabel")
ProfileImage.Parent = Footer
ProfileImage.BackgroundColor3 = GOLD_DARK
ProfileImage.Position = UDim2.new(0.02, 0, 0.15, 0)
ProfileImage.Size = UDim2.new(0.12, 0, 0.7, 0)

local success2, UserThumbnail = pcall(function()
    return Players:GetUserThumbnailAsync(
        LocalPlayer.UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size420x420
    )
end)
ProfileImage.Image = success2 and UserThumbnail or ""

local ProfileCorner = Instance.new("UICorner")
ProfileCorner.Parent = ProfileImage
ProfileCorner.CornerRadius = UDim.new(1, 0)

local ProfileStroke = Instance.new("UIStroke")
ProfileStroke.Parent = ProfileImage
ProfileStroke.Color = GOLD_LIGHT
ProfileStroke.Thickness = 1.5

local UsernameLabel = Instance.new("TextLabel")
UsernameLabel.Parent = Footer
UsernameLabel.BackgroundTransparency = 1
UsernameLabel.Position = UDim2.new(0.16, 0, 0.1, 0)
UsernameLabel.Size = UDim2.new(0.38, 0, 0.45, 0)
UsernameLabel.Font = Enum.Font.GothamBold
UsernameLabel.TextScaled = true
UsernameLabel.TextColor3 = GOLD_LIGHT
UsernameLabel.TextStrokeTransparency = 1
UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
UsernameLabel.Text = "@hebadnd"

local DiscordLabel = Instance.new("TextLabel")
DiscordLabel.Parent = Footer
DiscordLabel.BackgroundTransparency = 1
DiscordLabel.Position = UDim2.new(0.16, 0, 0.52, 0)
DiscordLabel.Size = UDim2.new(0.8, 0, 0.38, 0)
DiscordLabel.Font = Enum.Font.Gotham
DiscordLabel.TextScaled = true
DiscordLabel.TextColor3 = GOLD_DIM
DiscordLabel.TextStrokeTransparency = 1
DiscordLabel.TextXAlignment = Enum.TextXAlignment.Left
DiscordLabel.Text = "discord.gg/h3UZEksE7"

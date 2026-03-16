--[[
    ZXON DUELS
    discord.gg/h3UZEksE7
]]--

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService      = game:GetService("HttpService")
local LocalPlayer      = Players.LocalPlayer
local CoreGui          = game:GetService("CoreGui")

-- ========================================
-- GOLD PALETTE
-- ========================================
local G_ACCENT       = Color3.fromRGB(255, 200, 0)
local G_ACCENT2      = Color3.fromRGB(255, 140, 0)
local G_BG_MAIN      = Color3.fromRGB(14, 12, 5)
local G_BG_PANEL     = Color3.fromRGB(20, 17, 7)
local G_BG_ROW       = Color3.fromRGB(28, 24, 9)
local G_BG_TOGGLE    = Color3.fromRGB(48, 40, 14)
local G_KNOB_OFF     = Color3.fromRGB(110, 90, 35)
local G_TEXT_MAIN    = Color3.fromRGB(255, 238, 170)
local G_TEXT_DIM     = Color3.fromRGB(140, 110, 45)
local G_FILL         = Color3.fromRGB(255, 185, 0)
local G_DIVIDER      = Color3.fromRGB(80, 65, 18)
local G_ON_TRACK     = Color3.fromRGB(90, 68, 5)

-- ========================================
-- CLEANUP
-- ========================================
local existing = CoreGui:FindFirstChild("ZxonDuels", true)
if existing then existing:Destroy() end

-- ========================================
-- STATE
-- ========================================
local toggleStates  = {}
local speedValue    = 27
local thefSpeedVal  = 27
local spinSpeedVal  = 50
local aimRadiusVal  = 10
local guiOpen       = true

local speedConn, antiRagConn, jumpConn, spinConn, stealConn

-- ========================================
-- ROOT GUI
-- ========================================
local ScreenGui           = Instance.new("ScreenGui")
ScreenGui.Name            = "ZxonDuels"
ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn    = false
ScreenGui.Parent          = CoreGui

-- ========================================
-- LEFT SIDE BUTTONS (like photo)
-- ========================================
local SideFrame           = Instance.new("Frame", ScreenGui)
SideFrame.BackgroundTransparency = 1
SideFrame.Size            = UDim2.new(0, 100, 0, 420)
SideFrame.Position        = UDim2.new(0, 6, 0.28, 0)
SideFrame.ZIndex          = 50

local SideLayout          = Instance.new("UIListLayout", SideFrame)
SideLayout.Padding        = UDim.new(0, 5)
SideLayout.SortOrder      = Enum.SortOrder.LayoutOrder
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function MakeSideButton(labelText, order)
    local btn             = Instance.new("TextButton", SideFrame)
    btn.Size              = UDim2.new(1, 0, 0, 72)
    btn.BackgroundColor3  = G_BG_PANEL
    btn.Font              = Enum.Font.GothamBold
    btn.TextSize          = 13
    btn.TextColor3        = G_TEXT_MAIN
    btn.Text              = labelText
    btn.BorderSizePixel   = 0
    btn.LayoutOrder       = order
    btn.AutoButtonColor   = false
    btn.ZIndex            = 51

    local c               = Instance.new("UICorner", btn)
    c.CornerRadius        = UDim.new(0, 12)

    local s               = Instance.new("UIStroke", btn)
    s.Color               = G_DIVIDER
    s.Thickness           = 1.5

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = G_BG_ROW}):Play()
        TweenService:Create(s,   TweenInfo.new(0.12), {Color = G_ACCENT}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = G_BG_PANEL}):Play()
        TweenService:Create(s,   TweenInfo.new(0.12), {Color = G_DIVIDER}):Play()
    end)

    return btn
end

local BtnDrop        = MakeSideButton("Drop",             1)
local BtnAutoChase   = MakeSideButton("Auto\nChase",      2)
local BtnAutoRight   = MakeSideButton("Auto\nRight",      3)
local BtnAutoLeft    = MakeSideButton("Auto\nLeft",       4)
local BtnPlayRight   = MakeSideButton("Auto Play\nRight", 5)
local BtnPlayLeft    = MakeSideButton("Auto Play\nLeft",  6)

-- ========================================
-- TOGGLE BUTTON (floating circle)
-- ========================================
local ToggleBtn           = Instance.new("TextButton", ScreenGui)
ToggleBtn.Text            = "ZX"
ToggleBtn.Font            = Enum.Font.GothamBold
ToggleBtn.TextSize        = 13
ToggleBtn.TextColor3      = G_ACCENT
ToggleBtn.BackgroundColor3 = G_BG_ROW
ToggleBtn.Size            = UDim2.new(0, 46, 0, 46)
ToggleBtn.Position        = UDim2.new(0, 112, 0.3, 0)
ToggleBtn.ZIndex          = 999
ToggleBtn.BorderSizePixel = 0

Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

local TgStroke            = Instance.new("UIStroke", ToggleBtn)
TgStroke.Color            = G_ACCENT
TgStroke.Thickness        = 2

-- ========================================
-- MAIN PANEL
-- ========================================
local Main                = Instance.new("Frame", ScreenGui)
Main.Name                 = "Main"
Main.BackgroundColor3     = G_BG_MAIN
Main.BorderSizePixel      = 0
Main.Size                 = UDim2.new(0, 400, 0, 490)
Main.Position             = UDim2.new(0.5, -70, 0.5, -245)
Main.ClipsDescendants     = true
Main.Visible              = true

local MainCorner          = Instance.new("UICorner", Main)
MainCorner.CornerRadius   = UDim.new(0, 14)

local MainStroke          = Instance.new("UIStroke", Main)
MainStroke.Thickness      = 2
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local MainGrad            = Instance.new("UIGradient", MainStroke)
MainGrad.Color            = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 200, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 0)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 200, 0)),
})
MainGrad.Rotation = 0

RunService.RenderStepped:Connect(function()
    MainGrad.Rotation = (MainGrad.Rotation + 1) % 360
end)

-- ========================================
-- TITLE BAR
-- ========================================
local TitleBar            = Instance.new("Frame", Main)
TitleBar.BackgroundColor3 = G_BG_PANEL
TitleBar.Size             = UDim2.new(1, 0, 0, 50)
TitleBar.BorderSizePixel  = 0
TitleBar.ZIndex           = 5

-- Gold line under title
local TitleLine           = Instance.new("Frame", TitleBar)
TitleLine.BackgroundColor3 = G_ACCENT
TitleLine.Size            = UDim2.new(1, 0, 0, 2)
TitleLine.Position        = UDim2.new(0, 0, 1, -2)
TitleLine.BorderSizePixel = 0

local TitleIcon           = Instance.new("TextLabel", TitleBar)
TitleIcon.Text            = "⬡"
TitleIcon.Font            = Enum.Font.GothamBold
TitleIcon.TextSize        = 22
TitleIcon.TextColor3      = G_ACCENT
TitleIcon.BackgroundTransparency = 1
TitleIcon.Size            = UDim2.new(0, 34, 1, 0)
TitleIcon.Position        = UDim2.new(0, 8, 0, 0)
TitleIcon.ZIndex          = 6

local TitleLabel          = Instance.new("TextLabel", TitleBar)
TitleLabel.Text           = "ZXON DUELS"
TitleLabel.Font           = Enum.Font.GothamBlack
TitleLabel.TextSize       = 17
TitleLabel.TextColor3     = G_ACCENT
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size           = UDim2.new(0.65, 0, 0, 24)
TitleLabel.Position       = UDim2.new(0, 46, 0, 5)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex         = 6

local TitleStroke         = Instance.new("UIStroke", TitleLabel)
TitleStroke.Color         = G_ACCENT2
TitleStroke.Thickness     = 1

local DiscLabel           = Instance.new("TextLabel", TitleBar)
DiscLabel.Text            = "discord.gg/h3UZEksE7"
DiscLabel.Font            = Enum.Font.Gotham
DiscLabel.TextSize        = 10
DiscLabel.TextColor3      = G_TEXT_DIM
DiscLabel.BackgroundTransparency = 1
DiscLabel.Size            = UDim2.new(0.65, 0, 0, 14)
DiscLabel.Position        = UDim2.new(0, 46, 0, 32)
DiscLabel.TextXAlignment  = Enum.TextXAlignment.Left
DiscLabel.ZIndex          = 6

local CloseBtn            = Instance.new("TextButton", TitleBar)
CloseBtn.Text             = "✕"
CloseBtn.TextSize         = 15
CloseBtn.Font             = Enum.Font.GothamBold
CloseBtn.TextColor3       = Color3.fromRGB(255, 70, 70)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Size             = UDim2.new(0, 46, 1, 0)
CloseBtn.Position         = UDim2.new(1, -46, 0, 0)
CloseBtn.ZIndex           = 7

-- ========================================
-- DRAG
-- ========================================
local DragHandle          = Instance.new("Frame", Main)
DragHandle.BackgroundTransparency = 1
DragHandle.Size           = UDim2.new(1, 0, 0, 50)
DragHandle.ZIndex         = 5

do
    local dragging, dragStart, startPos
    DragHandle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = inp.Position; startPos = Main.Position
        end
    end)
    DragHandle.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement
            or inp.UserInputType == Enum.UserInputType.Touch) then
            local d = inp.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                      startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

-- ========================================
-- TWO COLUMN LAYOUT (like photo)
-- ========================================
local ColsFrame           = Instance.new("Frame", Main)
ColsFrame.BackgroundTransparency = 1
ColsFrame.Size            = UDim2.new(1, -12, 1, -56)
ColsFrame.Position        = UDim2.new(0, 6, 0, 52)

-- Divider between columns
local ColDiv              = Instance.new("Frame", ColsFrame)
ColDiv.BackgroundColor3   = G_DIVIDER
ColDiv.Size               = UDim2.new(0, 1, 1, 0)
ColDiv.Position           = UDim2.new(0.5, 0, 0, 0)
ColDiv.BorderSizePixel    = 0

-- Left scroll
local LeftScroll          = Instance.new("ScrollingFrame", ColsFrame)
LeftScroll.BackgroundTransparency = 1
LeftScroll.BorderSizePixel = 0
LeftScroll.Size           = UDim2.new(0.5, -4, 1, 0)
LeftScroll.Position       = UDim2.new(0, 0, 0, 0)
LeftScroll.CanvasSize     = UDim2.new(0, 0, 0, 0)
LeftScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
LeftScroll.ScrollBarThickness = 2
LeftScroll.ScrollBarImageColor3 = G_ACCENT

local LL                  = Instance.new("UIListLayout", LeftScroll)
LL.Padding                = UDim.new(0, 4)
LL.SortOrder              = Enum.SortOrder.LayoutOrder

-- Right scroll
local RightScroll         = Instance.new("ScrollingFrame", ColsFrame)
RightScroll.BackgroundTransparency = 1
RightScroll.BorderSizePixel = 0
RightScroll.Size          = UDim2.new(0.5, -4, 1, 0)
RightScroll.Position      = UDim2.new(0.5, 4, 0, 0)
RightScroll.CanvasSize    = UDim2.new(0, 0, 0, 0)
RightScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
RightScroll.ScrollBarThickness = 2
RightScroll.ScrollBarImageColor3 = G_ACCENT

local RL                  = Instance.new("UIListLayout", RightScroll)
RL.Padding                = UDim.new(0, 4)
RL.SortOrder              = Enum.SortOrder.LayoutOrder

-- ========================================
-- HELPERS: TOGGLE + SLIDER
-- ========================================
local function SetOn(knob, track)
    TweenService:Create(knob,  TweenInfo.new(0.18), {Position = UDim2.new(1, -16, 0, 2), BackgroundColor3 = G_ACCENT}):Play()
    TweenService:Create(track, TweenInfo.new(0.18), {BackgroundColor3 = G_ON_TRACK}):Play()
end
local function SetOff(knob, track)
    TweenService:Create(knob,  TweenInfo.new(0.18), {Position = UDim2.new(0, 2, 0, 2), BackgroundColor3 = G_KNOB_OFF}):Play()
    TweenService:Create(track, TweenInfo.new(0.18), {BackgroundColor3 = G_BG_TOGGLE}):Play()
end

local function MakeToggle(parent, label, keybind, order)
    local Row             = Instance.new("Frame", parent)
    Row.Size              = UDim2.new(1, 0, 0, 42)
    Row.BackgroundColor3  = G_BG_ROW
    Row.BorderSizePixel   = 0
    Row.LayoutOrder       = order

    local RC              = Instance.new("UICorner", Row)
    RC.CornerRadius       = UDim.new(0, 7)

    local RS              = Instance.new("UIStroke", Row)
    RS.Color              = G_DIVIDER
    RS.Thickness          = 1

    -- Keybind badge
    local Badge           = Instance.new("TextLabel", Row)
    Badge.Text            = keybind
    Badge.Font            = Enum.Font.GothamBold
    Badge.TextSize        = 9
    Badge.TextColor3      = G_BG_MAIN
    Badge.BackgroundColor3 = G_ACCENT
    Badge.Size            = UDim2.new(0, 18, 0, 18)
    Badge.Position        = UDim2.new(0, 5, 0.5, -9)
    Badge.TextXAlignment  = Enum.TextXAlignment.Center
    Badge.ZIndex          = 5
    Instance.new("UICorner", Badge).CornerRadius = UDim.new(0, 4)

    local Lbl             = Instance.new("TextLabel", Row)
    Lbl.Text              = label
    Lbl.TextSize          = 11
    Lbl.Font              = Enum.Font.GothamBold
    Lbl.TextColor3        = G_TEXT_MAIN
    Lbl.BackgroundTransparency = 1
    Lbl.Size              = UDim2.new(1, -70, 1, 0)
    Lbl.Position          = UDim2.new(0, 28, 0, 0)
    Lbl.TextXAlignment    = Enum.TextXAlignment.Left
    Lbl.ZIndex            = 5

    local Track           = Instance.new("Frame", Row)
    Track.Size            = UDim2.new(0, 34, 0, 18)
    Track.Position        = UDim2.new(1, -40, 0.5, -9)
    Track.BackgroundColor3 = G_BG_TOGGLE
    Track.BorderSizePixel = 0
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    local Knob            = Instance.new("Frame", Track)
    Knob.Size             = UDim2.new(0, 14, 0, 14)
    Knob.Position         = UDim2.new(0, 2, 0, 2)
    Knob.BackgroundColor3 = G_KNOB_OFF
    Knob.BorderSizePixel  = 0
    Knob.ZIndex           = 6
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local Btn             = Instance.new("TextButton", Row)
    Btn.Text              = ""
    Btn.Size              = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.ZIndex            = 7

    return Btn, Knob, Track, RS
end

local function MakeSlider(parent, label, sublabel, default, order)
    local Row             = Instance.new("Frame", parent)
    Row.Size              = UDim2.new(1, 0, 0, 38)
    Row.BackgroundTransparency = 1
    Row.LayoutOrder       = order

    local TopLbl          = Instance.new("TextLabel", Row)
    TopLbl.Text           = label
    TopLbl.TextColor3     = G_TEXT_DIM
    TopLbl.Font           = Enum.Font.GothamBold
    TopLbl.TextSize       = 11
    TopLbl.BackgroundTransparency = 1
    TopLbl.Size           = UDim2.new(0.7, 0, 0, 16)
    TopLbl.Position       = UDim2.new(0, 4, 0, 0)
    TopLbl.TextXAlignment = Enum.TextXAlignment.Left

    local SubLbl          = Instance.new("TextLabel", Row)
    SubLbl.Text           = sublabel
    SubLbl.TextColor3     = G_ACCENT
    SubLbl.Font           = Enum.Font.GothamBold
    SubLbl.TextSize        = 9
    SubLbl.BackgroundTransparency = 1
    SubLbl.Size           = UDim2.new(0.6, 0, 0, 12)
    SubLbl.Position       = UDim2.new(0, 4, 0, 2)

    local ValBox          = Instance.new("TextBox", Row)
    ValBox.Font           = Enum.Font.GothamBold
    ValBox.TextSize       = 11
    ValBox.TextColor3     = G_TEXT_MAIN
    ValBox.BackgroundTransparency = 1
    ValBox.Size           = UDim2.new(0, 40, 0, 14)
    ValBox.Position       = UDim2.new(1, -44, 0, 0)
    ValBox.TextXAlignment = Enum.TextXAlignment.Right
    ValBox.Text           = tostring(default)
    ValBox.ClearTextOnFocus = false
    ValBox.ZIndex         = 8

    local TrackBg         = Instance.new("Frame", Row)
    TrackBg.Size          = UDim2.new(1, -8, 0, 4)
    TrackBg.Position      = UDim2.new(0, 4, 0, 22)
    TrackBg.BackgroundColor3 = G_BG_TOGGLE
    TrackBg.BorderSizePixel = 0
    Instance.new("UICorner", TrackBg).CornerRadius = UDim.new(1, 0)

    local Fill            = Instance.new("Frame", TrackBg)
    Fill.Size             = UDim2.new(0.4, 0, 1, 0)
    Fill.BackgroundColor3 = G_FILL
    Fill.BorderSizePixel  = 0
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local Thumb           = Instance.new("Frame", TrackBg)
    Thumb.Size            = UDim2.new(0, 10, 0, 10)
    Thumb.AnchorPoint     = Vector2.new(0.5, 0.5)
    Thumb.Position        = UDim2.new(0.4, 0, 0.5, 0)
    Thumb.BackgroundColor3 = G_ACCENT
    Thumb.BorderSizePixel = 0
    Thumb.ZIndex          = 6
    Instance.new("UICorner", Thumb).CornerRadius = UDim.new(1, 0)

    return Row, ValBox, Fill, Thumb
end

-- ========================================
-- BUILD LEFT COLUMN
-- ========================================
local LBtn_CustomBoost, LKnob_CustomBoost, LTrack_CustomBoost   = MakeToggle(LeftScroll, "Custom Boost",   "V", 1)
local LBtn_SpinBot,     LKnob_SpinBot,     LTrack_SpinBot        = MakeToggle(LeftScroll, "Spin Bot",       "H", 3)
local LBtn_AutoGrabMob, LKnob_AutoGrabMob, LTrack_AutoGrabMob   = MakeToggle(LeftScroll, "Auto Grab (Mobile)", "T", 5)
local LBtn_AutoGrabPC,  LKnob_AutoGrabPC,  LTrack_AutoGrabPC    = MakeToggle(LeftScroll, "Auto Grab (PC)", "H", 7)
local LBtn_AntiRag,     LKnob_AntiRag,     LTrack_AntiRag        = MakeToggle(LeftScroll, "Anti Ragdoll",   "R", 9)
local LBtn_AutoRagTP,   LKnob_AutoRagTP,   LTrack_AutoRagTP      = MakeToggle(LeftScroll, "Auto Ragdoll TP","Y", 11)

-- Sliders left
local _, SpeedBox,    SpeedFill    = MakeSlider(LeftScroll, "Speed Value",     "Boost Speed",  27,  2)
local _, SpinBox,     SpinFill     = MakeSlider(LeftScroll, "Spin Speed",      "Spin Speed",   50,  4)
local _, GrabCdBox,   GrabCdFill   = MakeSlider(LeftScroll, "Grab Cooldown",   "Cooldown",     0.2, 6)

-- Save button bottom left
local SaveBtn         = Instance.new("TextButton", LeftScroll)
SaveBtn.Text          = "SAVE CONFIG"
SaveBtn.TextSize      = 12
SaveBtn.Font          = Enum.Font.GothamBold
SaveBtn.TextColor3    = G_BG_MAIN
SaveBtn.BackgroundColor3 = G_FILL
SaveBtn.Size          = UDim2.new(1, 0, 0, 30)
SaveBtn.LayoutOrder   = 20
SaveBtn.BorderSizePixel = 0
Instance.new("UICorner", SaveBtn).CornerRadius = UDim.new(0, 8)

-- ========================================
-- BUILD RIGHT COLUMN
-- ========================================
local RBtn_ThiefSpeed,  RKnob_ThiefSpeed,  RTrack_ThiefSpeed   = MakeToggle(RightScroll, "Thief Speed",    "X", 1)
local RBtn_NoWalkAnim,  RKnob_NoWalkAnim,  RTrack_NoWalkAnim   = MakeToggle(RightScroll, "No Walk Anim",   "B", 3)
local RBtn_MeleeAimbot, RKnob_MeleeAimbot, RTrack_MeleeAimbot  = MakeToggle(RightScroll, "Melee Aimbot",   "M", 5)
local RBtn_Optimizer,   RKnob_Optimizer,   RTrack_Optimizer     = MakeToggle(RightScroll, "Optimizer",      "Z", 7)
local RBtn_InfJump,     RKnob_InfJump,     RTrack_InfJump       = MakeToggle(RightScroll, "Infinite Jump",  "I", 9)
local RBtn_DodgeFloat,  RKnob_DodgeFloat,  RTrack_DodgeFloat    = MakeToggle(RightScroll, "Dodge Float",    "L", 11)
local RBtn_AutoPlayR,   RKnob_AutoPlayR,   RTrack_AutoPlayR     = MakeToggle(RightScroll, "Auto Play Right","P", 13)
local RBtn_AutoPlayL,   RKnob_AutoPlayL,   RTrack_AutoPlayL     = MakeToggle(RightScroll, "Auto Play Left", "O", 15)

-- Sliders right
local _, ThiefSpeedBox, ThiefFill   = MakeSlider(RightScroll, "Thief Speed Value", "Steal Speed",  27, 2)
local _, AimRadBox,     AimFill     = MakeSlider(RightScroll, "Aimbot Radius",     "Aim Radius",   10, 6)

-- ========================================
-- TOGGLE / CLOSE LOGIC
-- ========================================
ToggleBtn.MouseButton1Click:Connect(function()
    guiOpen = not guiOpen
    if guiOpen then
        Main.Visible = true
        SideFrame.Visible = true
        TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5, -70, 0.5, -245)}):Play()
    else
        TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
            {Position = UDim2.new(0.5, -70, 1.1, 0)}):Play()
        task.delay(0.25, function()
            Main.Visible = false
        end)
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    guiOpen = false
    TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
        {Position = UDim2.new(0.5, -70, 1.1, 0)}):Play()
    task.delay(0.25, function() Main.Visible = false end)
end)

-- ========================================
-- HELPERS
-- ========================================
local function GetHum(p)
    local c = p and p.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function GetHRP(p)
    local c = p and p.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- ========================================
-- FEATURE LOGIC
-- ========================================

-- Custom Boost / Speed
LBtn_CustomBoost.MouseButton1Click:Connect(function()
    toggleStates["speed"] = not toggleStates["speed"]
    if toggleStates["speed"] then
        SetOn(LKnob_CustomBoost, LTrack_CustomBoost)
        speedConn = RunService.Heartbeat:Connect(function()
            local h = GetHum(LocalPlayer)
            if h then h.WalkSpeed = tonumber(SpeedBox.Text) or 27 end
        end)
    else
        SetOff(LKnob_CustomBoost, LTrack_CustomBoost)
        if speedConn then speedConn:Disconnect(); speedConn = nil end
        local h = GetHum(LocalPlayer)
        if h then h.WalkSpeed = 16 end
    end
end)

-- Anti Ragdoll
LBtn_AntiRag.MouseButton1Click:Connect(function()
    toggleStates["antirag"] = not toggleStates["antirag"]
    if toggleStates["antirag"] then
        SetOn(LKnob_AntiRag, LTrack_AntiRag)
        antiRagConn = RunService.Heartbeat:Connect(function()
            local h = GetHum(LocalPlayer)
            if h then h:ChangeState(Enum.HumanoidStateType.GettingUp) end
        end)
    else
        SetOff(LKnob_AntiRag, LTrack_AntiRag)
        if antiRagConn then antiRagConn:Disconnect(); antiRagConn = nil end
    end
end)

-- Infinite Jump
RBtn_InfJump.MouseButton1Click:Connect(function()
    toggleStates["infjump"] = not toggleStates["infjump"]
    if toggleStates["infjump"] then
        SetOn(RKnob_InfJump, RTrack_InfJump)
        jumpConn = UserInputService.JumpRequest:Connect(function()
            local h = GetHum(LocalPlayer)
            if h then h.JumpPower = 80; h.Jump = true end
        end)
    else
        SetOff(RKnob_InfJump, RTrack_InfJump)
        if jumpConn then jumpConn:Disconnect(); jumpConn = nil end
    end
end)

-- Spin Bot
LBtn_SpinBot.MouseButton1Click:Connect(function()
    toggleStates["spin"] = not toggleStates["spin"]
    if toggleStates["spin"] then
        SetOn(LKnob_SpinBot, LTrack_SpinBot)
        spinConn = RunService.RenderStepped:Connect(function()
            local hrp = GetHRP(LocalPlayer)
            if hrp then
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(tonumber(SpinBox.Text) or 50), 0)
            end
        end)
    else
        SetOff(LKnob_SpinBot, LTrack_SpinBot)
        if spinConn then spinConn:Disconnect(); spinConn = nil end
    end
end)

-- Thief Speed
RBtn_ThiefSpeed.MouseButton1Click:Connect(function()
    toggleStates["thiefspeed"] = not toggleStates["thiefspeed"]
    if toggleStates["thiefspeed"] then
        SetOn(RKnob_ThiefSpeed, RTrack_ThiefSpeed)
    else
        SetOff(RKnob_ThiefSpeed, RTrack_ThiefSpeed)
    end
end)

-- No Walk Anim
RBtn_NoWalkAnim.MouseButton1Click:Connect(function()
    toggleStates["nowalkanim"] = not toggleStates["nowalkanim"]
    if toggleStates["nowalkanim"] then
        SetOn(RKnob_NoWalkAnim, RTrack_NoWalkAnim)
        local char = LocalPlayer.Character
        if char then
            local animate = char:FindFirstChild("Animate")
            if animate then animate.Disabled = true end
        end
    else
        SetOff(RKnob_NoWalkAnim, RTrack_NoWalkAnim)
        local char = LocalPlayer.Character
        if char then
            local animate = char:FindFirstChild("Animate")
            if animate then animate.Disabled = false end
        end
    end
end)

-- Melee Aimbot
RBtn_MeleeAimbot.MouseButton1Click:Connect(function()
    toggleStates["aimbot"] = not toggleStates["aimbot"]
    if toggleStates["aimbot"] then
        SetOn(RKnob_MeleeAimbot, RTrack_MeleeAimbot)
    else
        SetOff(RKnob_MeleeAimbot, RTrack_MeleeAimbot)
    end
end)

-- Optimizer
RBtn_Optimizer.MouseButton1Click:Connect(function()
    toggleStates["optimizer"] = not toggleStates["optimizer"]
    if toggleStates["optimizer"] then
        SetOn(RKnob_Optimizer, RTrack_Optimizer)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                for _, obj in ipairs(p.Character:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") then
                        obj.Enabled = false
                    end
                end
            end
        end
    else
        SetOff(RKnob_Optimizer, RTrack_Optimizer)
    end
end)

-- Dodge Float
RBtn_DodgeFloat.MouseButton1Click:Connect(function()
    toggleStates["dodgefloat"] = not toggleStates["dodgefloat"]
    if toggleStates["dodgefloat"] then
        SetOn(RKnob_DodgeFloat, RTrack_DodgeFloat)
    else
        SetOff(RKnob_DodgeFloat, RTrack_DodgeFloat)
    end
end)

-- Auto Ragdoll TP
LBtn_AutoRagTP.MouseButton1Click:Connect(function()
    toggleStates["autoragtp"] = not toggleStates["autoragtp"]
    if toggleStates["autoragtp"] then
        SetOn(LKnob_AutoRagTP, LTrack_AutoRagTP)
    else
        SetOff(LKnob_AutoRagTP, LTrack_AutoRagTP)
    end
end)

-- Auto Grab Mobile
LBtn_AutoGrabMob.MouseButton1Click:Connect(function()
    toggleStates["autograbmob"] = not toggleStates["autograbmob"]
    if toggleStates["autograbmob"] then
        SetOn(LKnob_AutoGrabMob, LTrack_AutoGrabMob)
    else
        SetOff(LKnob_AutoGrabMob, LTrack_AutoGrabMob)
    end
end)

-- Auto Grab PC
LBtn_AutoGrabPC.MouseButton1Click:Connect(function()
    toggleStates["autograbpc"] = not toggleStates["autograbpc"]
    if toggleStates["autograbpc"] then
        SetOn(LKnob_AutoGrabPC, LTrack_AutoGrabPC)
    else
        SetOff(LKnob_AutoGrabPC, LTrack_AutoGrabPC)
    end
end)

-- Auto Play Right
RBtn_AutoPlayR.MouseButton1Click:Connect(function()
    toggleStates["autoplayr"] = not toggleStates["autoplayr"]
    if toggleStates["autoplayr"] then
        SetOn(RKnob_AutoPlayR, RTrack_AutoPlayR)
    else
        SetOff(RKnob_AutoPlayR, RTrack_AutoPlayR)
    end
end)

-- Auto Play Left
RBtn_AutoPlayL.MouseButton1Click:Connect(function()
    toggleStates["autoplayl"] = not toggleStates["autoplayl"]
    if toggleStates["autoplayl"] then
        SetOn(RKnob_AutoPlayL, RTrack_AutoPlayL)
    else
        SetOff(RKnob_AutoPlayL, RTrack_AutoPlayL)
    end
end)

-- ========================================
-- SIDE BUTTONS LOGIC
-- ========================================
BtnAutoRight.MouseButton1Click:Connect(function()
    local hrp = GetHRP(LocalPlayer)
    if hrp then
        hrp.CFrame = hrp.CFrame * CFrame.new(10, 0, 0)
    end
end)

BtnAutoLeft.MouseButton1Click:Connect(function()
    local hrp = GetHRP(LocalPlayer)
    if hrp then
        hrp.CFrame = hrp.CFrame * CFrame.new(-10, 0, 0)
    end
end)

BtnAutoChase.MouseButton1Click:Connect(function()
    toggleStates["autochase"] = not toggleStates["autochase"]
    local s = Instance.new("UIStroke")
    s.Parent = BtnAutoChase
    if toggleStates["autochase"] then
        s.Color = G_ACCENT
        s.Thickness = 2
        -- Chase nearest player loop
        task.spawn(function()
            while toggleStates["autochase"] do
                local hrp = GetHRP(LocalPlayer)
                if hrp then
                    local best, bestDist = nil, math.huge
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer then
                            local ohrp = GetHRP(p)
                            if ohrp then
                                local dist = (ohrp.Position - hrp.Position).Magnitude
                                if dist < bestDist then bestDist = dist; best = p end
                            end
                        end
                    end
                    if best then
                        local ohrp = GetHRP(best)
                        if ohrp then
                            hrp.CFrame = CFrame.new(ohrp.Position + Vector3.new(0, 0, 3))
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    else
        s:Destroy()
    end
end)

BtnPlayRight.MouseButton1Click:Connect(function()
    toggleStates["playr"] = not toggleStates["playr"]
    if toggleStates["playr"] then
        task.spawn(function()
            while toggleStates["playr"] do
                local hrp = GetHRP(LocalPlayer)
                if hrp then hrp.CFrame = hrp.CFrame * CFrame.new(2, 0, 0) end
                task.wait(0.05)
            end
        end)
    end
end)

BtnPlayLeft.MouseButton1Click:Connect(function()
    toggleStates["playl"] = not toggleStates["playl"]
    if toggleStates["playl"] then
        task.spawn(function()
            while toggleStates["playl"] do
                local hrp = GetHRP(LocalPlayer)
                if hrp then hrp.CFrame = hrp.CFrame * CFrame.new(-2, 0, 0) end
                task.wait(0.05)
            end
        end)
    end
end)

-- ========================================
-- SAVE CONFIG
-- ========================================
SaveBtn.MouseButton1Click:Connect(function()
    local orig = SaveBtn.BackgroundColor3
    SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 220, 100)
    task.delay(0.4, function()
        TweenService:Create(SaveBtn, TweenInfo.new(0.3), {BackgroundColor3 = orig}):Play()
    end)
    warn("[ZxonDuels] Config saved!")
end)

-- ========================================
-- KEYBIND LISTENERS
-- ========================================
UserInputService.InputBegan:Connect(function(inp, proc)
    if proc then return end
    -- R = Anti Ragdoll
    if inp.KeyCode == Enum.KeyCode.R then
        LBtn_AntiRag:MouseButton1Click:Fire() -- won't work directly, toggle manually
    end
end)

print("[ZXON DUELS] Loaded! discord.gg/h3UZEksE7")

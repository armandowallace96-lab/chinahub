pcall(function()
    (gethui and gethui() or game.CoreGui).ChinaHub:Destroy()
end)

local Pl = game.Players
local U = game:GetService("UserInputService")
local R = game:GetService("RunService")
local TS = game:GetService("TweenService")
local St = game:GetService("Stats")
local MP = game:GetService("MarketplaceService")

local me = Pl.LocalPlayer

-- =========================================================
-- CONFIG
-- VER = {GRANDE, FUNÇÃO, AJUSTE, CORREÇÃO}
-- =========================================================

local VER = {4, 0, 0, 0}
local NOTES = "Aba DEFESA (anti-fling + anti-void) e sliders"
local LINK = "https://www.tiktok.com/@euwlz"
local VS = table.concat(VER, ".")

-- =========================================================
-- CORES / ESTADO
-- =========================================================

local RED = Color3.fromRGB(222, 41, 16)
local GOLD = Color3.fromRGB(255, 222, 0)
local BLK = Color3.fromRGB(10, 6, 6)
local W = Color3.new(1, 1, 1)
local GR = Color3.fromRGB(70, 60, 60)

local dist = 10
local cd = 1
local last = 0
local busy = false
local locked = false
local fps = 60
local n = 0

local afOn = false
local avOn = false
local vlim = 150
local blocks = 0
local safe = nil
local lastSafe = 0

local touched = {}
local grads = {}

-- =========================================================
-- ÍCONE
-- =========================================================

local IMG = "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"

-- =========================================================
-- BASE64
-- =========================================================

local function b64(s)
    local ch = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local m = {}

    for i = 1, 64 do
        m[ch:sub(i, i)] = i - 1
    end

    local o = {}
    s = s:gsub("[^%w%+/=]", "")

    for i = 1, #s, 4 do
        local a = m[s:sub(i, i)]
        local b = m[s:sub(i + 1, i + 1)]
        local c = m[s:sub(i + 2, i + 2)]
        local d = m[s:sub(i + 3, i + 3)]

        local v = a * 262144 + b * 4096 + (c or 0) * 64 + (d or 0)

        o[#o + 1] = string.char(math.floor(v / 65536) % 256)

        if c then
            o[#o + 1] = string.char(math.floor(v / 256) % 256)
        end

        if d then
            o[#o + 1] = string.char(v % 256)
        end
    end

    return table.concat(o)
end

-- =========================================================
-- DASH
-- =========================================================

local function dash()
    local ch = me.Character
    local r = ch and ch:FindFirstChild("HumanoidRootPart")
    local h = ch and ch:FindFirstChildOfClass("Humanoid")

    if busy or tick() - last < cd or not (r and h) then
        return
    end

    local d = h.MoveDirection

    if d.Magnitude < 0.1 then
        d = r.CFrame.LookVector
    end

    d = Vector3.new(d.X, 0, d.Z).Unit

    busy = true
    last = tick()

    local t = tick()
    local s = dist / 0.12

    while tick() - t < 0.12 and r.Parent do
        r.AssemblyLinearVelocity = Vector3.new(
            d.X * s,
            r.AssemblyLinearVelocity.Y,
            d.Z * s
        )

        R.Heartbeat:Wait()
    end

    busy = false
end

U.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.Q then
        dash()
    end
end)

-- =========================================================
-- DEFESA
-- =========================================================

local function restore()
    for v in pairs(touched) do
        pcall(function()
            v.CanCollide = true
        end)
    end

    touched = {}
end

R.Stepped:Connect(function()
    if not afOn then
        return
    end

    for _, p in ipairs(Pl:GetPlayers()) do
        if p ~= me and p.Character then
            for _, v in ipairs(p.Character:GetChildren()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                    touched[v] = true
                end
            end
        end
    end
end)

local function defense(t)
    local ch = me.Character
    local hr = ch and ch:FindFirstChild("HumanoidRootPart")
    local h = ch and ch:FindFirstChildOfClass("Humanoid")

    if not hr then
        return
    end

    -- Anti-fling
    if afOn and not (busy or t - last < 0.4) then
        local v = hr.AssemblyLinearVelocity

        if Vector3.new(v.X, 0, v.Z).Magnitude > vlim
            or hr.AssemblyAngularVelocity.Magnitude > 40 then

            hr.AssemblyLinearVelocity = Vector3.zero
            hr.AssemblyAngularVelocity = Vector3.zero
            blocks += 1
        end
    end

    -- Anti-void
    if avOn then
        local pos = hr.Position
        local fh = workspace.FallenPartsDestroyHeight

        if fh < -1e5 then
            fh = -500
        end

        local bad =
            pos.Y < fh + 100
            or pos.Magnitude > 1e5
            or pos.X ~= pos.X
            or (safe and (pos - safe.Position).Magnitude > 3000)

        if bad then
            if safe then
                hr.CFrame = safe
                hr.AssemblyLinearVelocity = Vector3.zero
                hr.AssemblyAngularVelocity = Vector3.zero
                blocks += 1
            end
        elseif h
            and h.FloorMaterial ~= Enum.Material.Air
            and t - lastSafe > 0.5 then

            safe = hr.CFrame + Vector3.new(0, 3, 0)
            lastSafe = t
        end
    end
end

-- =========================================================
-- HELPERS DE UI
-- =========================================================

local G = Instance.new("ScreenGui")
G.Name = "ChinaHub"
G.ResetOnSpawn = false

if not pcall(function()
    G.Parent = gethui and gethui() or game.CoreGui
end) then
    G.Parent = me.PlayerGui
end

local function new(c, p, par)
    local x = Instance.new(c)

    for k, v in pairs(p) do
        x[k] = v
    end

    x.Parent = par
    return x
end

local function round(x, r)
    new("UICorner", {
        CornerRadius = UDim.new(0, r)
    }, x)
end

local function glow(x, t)
    local s = new("UIStroke", {
        Color = W,
        Thickness = t
    }, x)

    grads[#grads + 1] = new("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, GOLD),
            ColorSequenceKeypoint.new(0.5, RED),
            ColorSequenceKeypoint.new(1, GOLD)
        })
    }, s)
end

local function txt(p, t, s, pos, sz, col, bold, al)
    return new("TextLabel", {
        BackgroundTransparency = 1,
        Text = t,
        TextColor3 = col or W,
        Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham,
        TextSize = s,
        Position = pos,
        Size = sz,
        TextXAlignment = al or Enum.TextXAlignment.Left,
        TextWrapped = true
    }, p)
end

local function press(b)
    local s = new("UIScale", {}, b)

    local function up()
        TS:Create(
            s,
            TweenInfo.new(0.2, Enum.EasingStyle.Back),
            { Scale = 1 }
        ):Play()
    end

    b.MouseButton1Down:Connect(function()
        TS:Create(
            s,
            TweenInfo.new(0.08),
            { Scale = 0.92 }
        ):Play()
    end)

    b.MouseButton1Up:Connect(up)
    b.MouseLeave:Connect(up)
end

local function drag(h, t, tap)
    h.InputBegan:Connect(function(i)
        if i.UserInputType ~= Enum.UserInputType.MouseButton1
            and i.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local st = i.Position
        local sp = t.Position
        local moved = false

        local con = U.InputChanged:Connect(function(m)
            if locked
                or not (m == i or m.UserInputType == Enum.UserInputType.MouseMovement) then
                return
            end

            local d = m.Position - st

            if d.Magnitude > 6 then
                moved = true
            end

            if moved then
                t.Position = UDim2.new(
                    sp.X.Scale,
                    sp.X.Offset + d.X,
                    sp.Y.Scale,
                    sp.Y.Offset + d.Y
                )
            end
        end)

        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then
                con:Disconnect()

                if not moved and tap then
                    tap()
                end
            end
        end)
    end)
end

local function flash(b, t)
    local o = b.Text
    b.Text = t

    task.delay(1.2, function()
        b.Text = o
    end)
end

local function stars(p, big, sm, bs, ss, aw, ah)
    local function s(x, y, sz, rot)
        new("TextLabel", {
            BackgroundTransparency = 1,
            Text = "★",
            TextColor3 = GOLD,
            TextSize = sz,
            Font = Enum.Font.SourceSansBold,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(x, y),
            Size = UDim2.fromOffset(sz, sz),
            Rotation = rot or 0
        }, p)
    end

    s(big[1], big[2], bs)

    for _, q in ipairs(sm) do
        s(
            q[1],
            q[2],
            ss,
            math.deg(
                math.atan2(
                    (big[1] - q[1]) * aw,
                    -((big[2] - q[2]) * ah)
                )
            )
        )
    end
end

-- =========================================================
-- PAINEL
-- =========================================================

local fr = new("Frame", {
    Size = UDim2.fromOffset(480, 300),
    Position = UDim2.fromOffset(20, 84),
    BackgroundColor3 = W,
    BorderSizePixel = 0,
    ClipsDescendants = true
}, G)

round(fr, 24)
glow(fr, 2.5)

local silk = new("UIGradient", {
    Rotation = 25,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 15, 10)),
        ColorSequenceKeypoint.new(0.2, Color3.fromRGB(235, 45, 25)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(120, 8, 8)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(225, 40, 22)),
        ColorSequenceKeypoint.new(0.8, Color3.fromRGB(130, 10, 10)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 30, 20))
    })
}, fr)

stars(
    fr,
    {0.075, 0.1},
    {
        {0.13, 0.035},
        {0.155, 0.085},
        {0.155, 0.15},
        {0.13, 0.2}
    },
    48,
    18,
    480,
    300
)

local sc = new("UIScale", {}, fr)

drag(fr, fr)

-- =========================================================
-- BRILHOS FLUTUANTES
-- =========================================================

local sp = {}

for i = 1, 7 do
    sp[i] = {
        new("TextLabel", {
            BackgroundTransparency = 1,
            Text = "✦",
            TextColor3 = GOLD,
            TextSize = math.random(10, 16),
            Position = UDim2.fromOffset(
                math.random(20, 460),
                math.random(60, 290)
            ),
            Size = UDim2.fromOffset(16, 16)
        }, fr),
        math.random() * 6,
        math.random(20, 40) / 100
    }
end

local tt = txt(
    fr,
    "ChinaHub",
    26,
    UDim2.fromOffset(92, 6),
    UDim2.fromOffset(220, 30),
    W,
    true
)

new("UIGradient", {
    Color = ColorSequence.new(GOLD, W)
}, tt)

txt(
    fr,
    "@" .. me.Name .. "  ·  v" .. VS,
    12,
    UDim2.fromOffset(92, 34),
    UDim2.fromOffset(260, 16),
    Color3.fromRGB(255, 225, 200)
)

local lk = new("TextButton", {
    Size = UDim2.fromOffset(34, 34),
    Position = UDim2.fromOffset(436, 8),
    BackgroundColor3 = BLK,
    BackgroundTransparency = 0.3,
    Text = "🔓",
    TextSize = 16,
    AutoButtonColor = false
}, fr)

round(lk, 17)
press(lk)

lk.MouseButton1Click:Connect(function()
    locked = not locked
    lk.Text = locked and "🔒" or "🔓"
end)

-- =========================================================
-- ABAS
-- =========================================================

local tabbar = new("Frame", {
    Position = UDim2.fromOffset(12, 56),
    Size = UDim2.fromOffset(456, 36),
    BackgroundColor3 = BLK,
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0
}, fr)

round(tabbar, 18)

local ind = new("Frame", {
    Size = UDim2.fromOffset(84, 3),
    Position = UDim2.fromOffset(5, 31),
    BackgroundColor3 = GOLD,
    BorderSizePixel = 0
}, tabbar)

round(ind, 2)

local body = new("Frame", {
    Position = UDim2.fromOffset(12, 100),
    Size = UDim2.fromOffset(456, 188),
    BackgroundColor3 = BLK,
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
    ClipsDescendants = true
}, fr)

round(body, 18)

local pages = {}
local tabs = {}

local function show(i)
    for j = 1, #pages do
        pages[j].Visible = j == i
        tabs[j].BackgroundColor3 =
            j == i and RED or Color3.fromRGB(35, 22, 22)
        tabs[j].TextColor3 = j == i and GOLD or W
    end

    TS:Create(
        ind,
        TweenInfo.new(0.3, Enum.EasingStyle.Quint),
        {
            Position = UDim2.fromOffset(
                5 + (i - 1) * 91,
                31
            )
        }
    ):Play()

    local p = pages[i]
    p.Position = UDim2.fromOffset(0, 16)

    TS:Create(
        p,
        TweenInfo.new(0.3, Enum.EasingStyle.Quint),
        {
            Position = UDim2.new()
        }
    ):Play()
end

local function page(name)
    local i = #pages + 1

    local p = new("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = GOLD,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false
    }, body)

    new("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, p)

    new("UIPadding", {
        PaddingTop = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 10)
    }, p)

    local b = new("TextButton", {
        Size = UDim2.fromOffset(88, 30),
        Position = UDim2.fromOffset(
            3 + (i - 1) * 91,
            2
        ),
        Text = name,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        AutoButtonColor = false,
        BackgroundTransparency = 0
    }, tabbar)

    round(b, 15)
    press(b)

    pages[i] = p
    tabs[i] = b

    b.MouseButton1Click:Connect(function()
        show(i)
    end)

    return p
end

-- =========================================================
-- COMPONENTES
-- =========================================================

local function row(p, h)
    n += 1

    local r = new("Frame", {
        Size = UDim2.new(1, 0, 0, h or 38),
        BackgroundColor3 = Color3.fromRGB(28, 14, 14),
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        LayoutOrder = n
    }, p)

    round(r, 12)

    return r
end

local function toggle(p, t, init, cb)
    local r = row(p)

    txt(
        r,
        t,
        14,
        UDim2.fromOffset(12, 0),
        UDim2.new(1, -76, 1, 0)
    )

    local b = new("TextButton", {
        Size = UDim2.fromOffset(46, 26),
        Position = UDim2.new(1, -56, 0.5, -13),
        BackgroundColor3 = GR,
        Text = "",
        AutoButtonColor = false
    }, r)

    round(b, 13)

    local k = new("Frame", {
        Size = UDim2.fromOffset(22, 22),
        Position = UDim2.fromOffset(2, 2),
        BackgroundColor3 = W,
        BorderSizePixel = 0
    }, b)

    round(k, 11)

    local s

    local function set(v)
        s = v

        TS:Create(
            b,
            TweenInfo.new(0.2),
            {
                BackgroundColor3 = v and RED or GR
            }
        ):Play()

        TS:Create(
            k,
            TweenInfo.new(0.25, Enum.EasingStyle.Back),
            {
                Position = UDim2.fromOffset(
                    v and 22 or 2,
                    2
                )
            }
        ):Play()

        cb(v)
    end

    b.MouseButton1Click:Connect(function()
        set(not s)
    end)

    set(init)
end

local function slider(p, t, min, max, val, cb, suf)
    local r = row(p, 54)

    local lb = txt(
        r,
        "",
        14,
        UDim2.fromOffset(12, 4),
        UDim2.new(1, -24, 0, 22),
        W
    )

    local tr = new("TextButton", {
        Position = UDim2.fromOffset(12, 34),
        Size = UDim2.new(1, -24, 0, 10),
        BackgroundColor3 = GR,
        Text = "",
        AutoButtonColor = false
    }, r)

    round(tr, 5)

    local fl = new("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = RED,
        BorderSizePixel = 0
    }, tr)

    round(fl, 5)

    local kn = new("Frame", {
        Size = UDim2.fromOffset(18, 18),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = GOLD,
        BorderSizePixel = 0
    }, tr)

    round(kn, 9)

    local function set(v)
        v = math.clamp(
            math.floor(v * 10 + 0.5) / 10,
            min,
            max
        )

        local a = (v - min) / (max - min)

        fl.Size = UDim2.new(a, 0, 1, 0)
        kn.Position = UDim2.new(a, 0, 0.5, 0)

        lb.Text =
            t .. ": "
            .. string.format("%.1f", v)
            .. (suf or "")

        cb(v)
    end

    set(val)

    local dragging = false

    local function drag_slider()
        dragging = true
        while dragging do
            local m = U:GetMouseLocation()
            local x = m.X - tr.AbsolutePosition.X
            local w = tr.AbsoluteSize.X
            set(min + (x / w) * (max - min))
            R.Heartbeat:Wait()
        end
    end

    tr.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag_slider()
        end
    end)

    tr.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- =========================================================
-- ABAS DE CONTEÚDO
-- =========================================================

local p1 = page("📊 INFO")
info(p1, "Versão").Text = VS
info(p1, "Link").Text = LINK
info(p1, "Notas").Text = NOTES

local p2 = page("⚡ DASH")
toggle(p2, "DASH Ativo", true, function(v) end)
slider(p2, "Distância", 5, 50, dist, function(v) dist = v end, " un")
slider(p2, "Recarga", 0, 5, cd, function(v) cd = v end, "s")

local p3 = page("🛡️ DEFESA")
toggle(p3, "Anti-Fling", false, function(v) afOn = v restore() end)
toggle(p3, "Anti-Void", false, function(v) avOn = v end)
slider(p3, "Limite Velocidade", 50, 300, vlim, function(v) vlim = v end, " un/s")
info(p3, "Bloqueios").Text = tostring(blocks)

show(1)

-- =========================================================
-- LOOP PRINCIPAL
-- =========================================================

R.Heartbeat:Connect(function(dt)
    defense(tick())
    silk.Offset = Vector2.new(math.sin(tick() * 0.8) * 0.2, 0)
    for _, g in ipairs(grads) do
        g.Rotation = (tick() * 80) % 360
    end
end)

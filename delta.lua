pcall(function()(gethui and gethui() or game.CoreGui).ChinaHub:Destroy()end)
local Pl,U,R,TS,St,MP=game.Players,game:GetService("UserInputService"),game:GetService("RunService"),game:GetService("TweenService"),game:GetService("Stats"),game:GetService("MarketplaceService")
local me=Pl.LocalPlayer
local RED,GOLD,BLK,W,GR=Color3.fromRGB(222,41,16),Color3.fromRGB(255,222,0),Color3.fromRGB(10,6,6),Color3.new(1,1,1),Color3.fromRGB(70,60,60)
local dist,cd,last,busy,locked,fps,n=10,0,0,false,false,60,0
local grads={}

-- DASH
local function dash()
 local ch=me.Character
 local r,h=ch and ch:FindFirstChild("HumanoidRootPart"),ch and ch:FindFirstChildOfClass("Humanoid")
 if busy or tick()-last<cd or not(r and h)then return end
 local d=h.MoveDirection
 if d.Magnitude<.1 then d=r.CFrame.LookVector end
 d=Vector3.new(d.X,0,d.Z).Unit
 busy,last=true,tick()
 local t,s=tick(),dist/.12
 while tick()-t<.12 and r.Parent do
  r.AssemblyLinearVelocity=Vector3.new(d.X*s,r.AssemblyLinearVelocity.Y,d.Z*s)
  R.Heartbeat:Wait()
 end
 busy=false
end
U.InputBegan:Connect(function(i,g)if not g and i.KeyCode==Enum.KeyCode.Q then dash()end end)

-- helpers de UI
local G=Instance.new("ScreenGui")G.Name="ChinaHub"G.ResetOnSpawn=false
if not pcall(function()G.Parent=gethui and gethui() or game.CoreGui end)then G.Parent=me.PlayerGui end
local function new(c,p,par)local x=Instance.new(c)for k,v in pairs(p)do x[k]=v end x.Parent=par return x end
local function round(x,r)new("UICorner",{CornerRadius=UDim.new(0,r)},x)end
local function glow(x,t)
 local s=new("UIStroke",{Color=W,Thickness=t},x)
 grads[#grads+1]=new("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,GOLD),ColorSequenceKeypoint.new(.5,RED),ColorSequenceKeypoint.new(1,GOLD)})},s)
end
local function txt(p,t,s,pos,sz,col,bold,al)
 return new("TextLabel",{BackgroundTransparency=1,Text=t,TextColor3=col or W,Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham,TextSize=s,Position=pos,Size=sz,TextXAlignment=al or Enum.TextXAlignment.Left,TextWrapped=true},p)
end
local function press(b)
 local s=new("UIScale",{},b)
 local function up()TS:Create(s,TweenInfo.new(.2,Enum.EasingStyle.Back),{Scale=1}):Play()end
 b.MouseButton1Down:Connect(function()TS:Create(s,TweenInfo.new(.08),{Scale=.92}):Play()end)
 b.MouseButton1Up:Connect(up)b.MouseLeave:Connect(up)
end
local function drag(h,t,tap)
 h.InputBegan:Connect(function(i)
  if i.UserInputType~=Enum.UserInputType.MouseButton1 and i.UserInputType~=Enum.UserInputType.Touch then return end
  local st,sp,moved=i.Position,t.Position,false
  local con=U.InputChanged:Connect(function(m)
   if locked or not(m==i or m.UserInputType==Enum.UserInputType.MouseMovement)then return end
   local d=m.Position-st
   if d.Magnitude>6 then moved=true end
   if moved then t.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)end
  end)
  i.Changed:Connect(function()
   if i.UserInputState==Enum.UserInputState.End then con:Disconnect()if not moved and tap then tap()end end
  end)
 end)
end

-- estrelas da bandeira (as pequenas apontam pra grande)
local function stars(p,big,sm,bs,ss,aw,ah)
 local function s(x,y,sz,rot)
  new("TextLabel",{BackgroundTransparency=1,Text="★",TextColor3=GOLD,TextSize=sz,Font=Enum.Font.SourceSansBold,AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(x,y),Size=UDim2.fromOffset(sz,sz),Rotation=rot or 0},p)
 end
 s(big[1],big[2],bs)
 for _,q in ipairs(sm)do
  s(q[1],q[2],ss,math.deg(math.atan2((big[1]-q[1])*aw,-((big[2]-q[2])*ah))))
 end
end

-- PAINEL (bandeira de seda ondulando)
local fr=new("Frame",{Size=UDim2.fromOffset(480,300),Position=UDim2.fromOffset(20,76),BackgroundColor3=W,BorderSizePixel=0,ClipsDescendants=true},G)
round(fr,22)glow(fr,2.5)
local silk=new("UIGradient",{Rotation=25,Color=ColorSequence.new({
 ColorSequenceKeypoint.new(0,Color3.fromRGB(150,15,10)),ColorSequenceKeypoint.new(.2,Color3.fromRGB(235,45,25)),
 ColorSequenceKeypoint.new(.4,Color3.fromRGB(120,8,8)),ColorSequenceKeypoint.new(.6,Color3.fromRGB(225,40,22)),
 ColorSequenceKeypoint.new(.8,Color3.fromRGB(130,10,10)),ColorSequenceKeypoint.new(1,Color3.fromRGB(200,30,20))})},fr)
stars(fr,{.09,.2},{{.165,.07},{.2,.15},{.2,.27},{.165,.35}},64,24,480,300)
local sc=new("UIScale",{},fr)
drag(fr,fr)

local tt=txt(fr,"ChinaHub",24,UDim2.fromOffset(125,6),UDim2.fromOffset(200,28),W,true)
new("UIGradient",{Color=ColorSequence.new(GOLD,W)},tt)
txt(fr,"@"..me.Name.."  ·  v3.0",12,UDim2.fromOffset(125,32),UDim2.fromOffset(250,16),Color3.fromRGB(255,225,200))
local lk=new("TextButton",{Size=UDim2.fromOffset(34,34),Position=UDim2.fromOffset(438,8),BackgroundColor3=BLK,BackgroundTransparency=.3,Text="🔓",TextSize=16,AutoButtonColor=false},fr)
round(lk,17)press(lk)
lk.MouseButton1Click:Connect(function()locked=not locked lk.Text=locked and"🔒"or"🔓"end)

-- abas
local side=new("Frame",{Position=UDim2.fromOffset(12,52),Size=UDim2.fromOffset(110,236),BackgroundColor3=BLK,BackgroundTransparency=.3,BorderSizePixel=0},fr)round(side,16)
new("UIListLayout",{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder},side)
new("UIPadding",{PaddingTop=UDim.new(0,8),PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8)},side)
local body=new("Frame",{Position=UDim2.fromOffset(130,52),Size=UDim2.fromOffset(338,236),BackgroundColor3=BLK,BackgroundTransparency=.3,BorderSizePixel=0},fr)round(body,16)
local pages,tabs={},{}
local function show(i)for j=1,#pages do pages[j].Visible=j==i tabs[j].BackgroundColor3=j==i and RED or Color3.fromRGB(35,22,22)tabs[j].TextColor3=j==i and GOLD or W end end
local function page(name)
 local i=#pages+1
 local p=new("ScrollingFrame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=GOLD,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false},body)
 new("UIListLayout",{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder},p)
 new("UIPadding",{PaddingTop=UDim.new(0,8),PaddingBottom=UDim.new(0,8),PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,10)},p)
 local b=new("TextButton",{Size=UDim2.new(1,0,0,34),Text=name,Font=Enum.Font.GothamBold,TextSize=12,AutoButtonColor=false,LayoutOrder=i},side)round(b,12)press(b)
 pages[i],tabs[i]=p,b
 b.MouseButton1Click:Connect(function()show(i)end)
 return p
end
local function row(p,h)
 n+=1
 local r=new("Frame",{Size=UDim2.new(1,0,0,h or 38),BackgroundColor3=Color3.fromRGB(28,14,14),BackgroundTransparency=.15,BorderSizePixel=0,LayoutOrder=n},p)
 round(r,12)return r
end
local function toggle(p,t,init,cb)
 local r=row(p)
 txt(r,t,14,UDim2.fromOffset(12,0),UDim2.new(1,-76,1,0))
 local b=new("TextButton",{Size=UDim2.fromOffset(46,26),Position=UDim2.new(1,-56,.5,-13),BackgroundColor3=GR,Text="",AutoButtonColor=false},r)round(b,13)
 local k=new("Frame",{Size=UDim2.fromOffset(22,22),Position=UDim2.fromOffset(2,2),BackgroundColor3=W,BorderSizePixel=0},b)round(k,11)
 local s
 local function set(v)
  s=v
  TS:Create(b,TweenInfo.new(.2),{BackgroundColor3=v and RED or GR}):Play()
  TS:Create(k,TweenInfo.new(.25,Enum.EasingStyle.Back),{Position=UDim2.fromOffset(v and 22 or 2,2)}):Play()
  cb(v)
 end
 b.MouseButton1Click:Connect(function()set(not s)end)
 set(init)
end
local function stepper(p,t,list,i,cb,suf)
 local r=row(p,40)
 txt(r,t,14,UDim2.fromOffset(12,0),UDim2.new(1,-160,1,0))
 local v=txt(r,"",13,UDim2.new(1,-118,0,0),UDim2.fromOffset(70,40),GOLD,true,Enum.TextXAlignment.Center)
 local function sh()v.Text=tostring(list[i])..(suf or"")end sh()
 for j,d in ipairs({-1,1})do
  local b=new("TextButton",{Size=UDim2.fromOffset(30,30),Position=UDim2.new(1,j==1 and -152 or -44,.5,-15),BackgroundColor3=RED,Text=d<0 and"–"or"+",TextColor3=GOLD,Font=Enum.Font.GothamBold,TextSize=18,AutoButtonColor=false},r)
  round(b,15)press(b)
  b.MouseButton1Click:Connect(function()i=math.clamp(i+d,1,#list)sh()cb(list[i])end)
 end
end
local function info(p,label)
 local r=row(p,30)
 txt(r,label,13,UDim2.fromOffset(12,0),UDim2.new(.4,0,1,0),GOLD)
 local v=txt(r,"...",13,UDim2.new(.4,0,0,0),UDim2.new(.6,-12,1,0),W,true,Enum.TextXAlignment.Right)
 v.TextTruncate=Enum.TextTruncate.AtEnd
 return v
end

-- ABA MAIN (informações do jogador)
local pm=page("👤 MAIN")
local c=row(pm,78)
local av=new("ImageLabel",{Size=UDim2.fromOffset(62,62),Position=UDim2.fromOffset(8,8),BackgroundColor3=BLK,BorderSizePixel=0},c)round(av,31)
task.spawn(function()local ok,img=pcall(function()return Pl:GetUserThumbnailAsync(me.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150)end)if ok then av.Image=img end end)
txt(c,me.DisplayName,17,UDim2.fromOffset(80,14),UDim2.new(1,-88,0,22),W,true)
txt(c,"@"..me.Name,13,UDim2.fromOffset(80,38),UDim2.new(1,-88,0,18),GOLD)
info(pm,"ID").Text=tostring(me.UserId)
info(pm,"Conta").Text=me.AccountAge.." dias"
local vPing,vFps,vPl,vGame=info(pm,"Ping"),info(pm,"FPS"),info(pm,"Jogadores"),info(pm,"Jogo")
task.spawn(function()local ok,i=pcall(function()return MP:GetProductInfo(game.PlaceId).Name end)vGame.Text=ok and i or"?"end)

-- ABA DASH
local pd=page("⚡ DASH")
local db=new("TextButton",{Size=UDim2.fromOffset(68,68),Position=UDim2.new(1,-108,1,-200),BackgroundColor3=BLK,Text="DASH",TextColor3=GOLD,Font=Enum.Font.GothamBold,TextSize=15,AutoButtonColor=false},G)
round(db,34)glow(db,3)press(db)drag(db,db,dash)
toggle(pd,"Botão DASH",true,function(v)db.Visible=v end)
stepper(pd,"Distância",{5,8,10,15,20,25,30,40},3,function(v)dist=v end)
stepper(pd,"Recarga",{0,.5,1,2,3,5},1,function(v)cd=v end,"s")

-- ABA EM BREVE
local pb=page("🔒 EM BREVE")
local soon=row(pb,120)
txt(soon,"🚧\nEm breve...\nNovas funções chegando",16,UDim2.new(),UDim2.new(1,0,1,0),W,true,Enum.TextXAlignment.Center)
show(1)

-- BOLINHA (bandeira)
local bub=new("TextButton",{Size=UDim2.fromOffset(56,56),Position=UDim2.fromOffset(20,10),BackgroundColor3=RED,Text="",AutoButtonColor=false},G)
round(bub,28)glow(bub,3)press(bub)
stars(bub,{.34,.5},{{.68,.22},{.78,.4},{.78,.6},{.68,.78}},26,11,56,56)
drag(bub,bub,function()
 fr.Visible=not fr.Visible
 if fr.Visible then sc.Scale=.8 TS:Create(sc,TweenInfo.new(.35,Enum.EasingStyle.Back),{Scale=1}):Play()end
end)

local acc=0
R.Heartbeat:Connect(function(dt)
 silk.Offset=Vector2.new(math.sin(tick()*.8)*.2,0)
 for _,g in ipairs(grads)do g.Rotation=(tick()*80)%360 end
 fps=fps+(1/dt-fps)*.05
 acc+=dt
 if acc>.5 then
  acc=0
  local ok,pg=pcall(function()return math.floor(St.Network.ServerStatsItem["Data Ping"]:GetValue())end)
  vPing.Text=ok and pg.." ms"or"-"
  vFps.Text=tostring(math.floor(fps))
  vPl.Text=#Pl:GetPlayers().."/"..Pl.MaxPlayers
 end
 local rem=cd-(tick()-last)
 db.Text=rem>0 and string.format("%.1f",rem)or"DASH"
 db.TextTransparency=rem>0 and .35 or 0
end)

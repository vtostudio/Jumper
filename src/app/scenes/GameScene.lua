-- 游戏场景
local GameScene = class("GameScene", function()
    return display.newPhysicsScene("GameScene")
end)

--引入UI操作层
local UILayer = require("app.scenes.UILayer")
--引入Map层
local MapLayer = require("app.scenes.MapLayer")
--引入Player
local Player = require("app.scenes.Player")
--引入ContactListener
local ContactListener = require("app.scenes.ContactListener")

--秒计数
GameScene.timeCount = 0
GameScene.isFailed = false

--操作UI层
GameScene.uiLayer = nil
--操作map层
GameScene.mapLayer = nil
--玩家
GameScene.player = nil

--摄像机
--GameScene.camera = nil

function GameScene:ctor()

	--创建摄像机
	--self.camera = cc.Camera:createOrthographic(display.width, display.height, 0, 1):pos(0, 0):addTo(self, -1)
	--self.camera:setCameraFlag(cc.CameraFlag.USER1)

    --获取物理世界
    self.world = self:getPhysicsWorld()
    self.world:setGravity(cc.p(0, -2000)) --0没有重力

	-- 初始化
    self:init()

end

-- 初始化
function GameScene:init()

	-- 加载图片集
    display.addSpriteFrames("res/gamescene.plist", "res/gamescene.png", nil)

    -- 添加背景图片
    display.newSprite("#Bg1.png"):align(display.CENTER_LEFT, display.left, display.cy):addTo(self)
    
    --地图层
    self.mapLayer = MapLayer.new(self)
    --操作ui层
    self.uiLayer = UILayer.new(self)
    --玩家
    self.player = Player.new(self)
    --注册监听碰撞
    ContactListener.new(self)
end
 
function GameScene:onEnter()
end

function GameScene:onExit()
end

function GameScene:onStart()
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.onUpdate))
    --解决刚体穿透
    self.world:setAutoStep(false)
    self:scheduleUpdate()
end

function GameScene:onUpdate(dt)
    --解决刚体穿透
    for i=1,3 do
        self.world:step(1/180.0)
    end

    if not self.isFailed then
        --移动背景地图
        if self.mapLayer:move() then
            self:failed()
        end
    else
        self:exitGame()
    end
end

function GameScene:failed()
    self.isFailed = true
end

function GameScene:exitGame()
    self.uiLayer:back()
    self.world:removeAllBodies()
    self.world = nil
    self:removeNodeEventListenersByEvent(cc.NODE_ENTER_FRAME_EVENT)
    -- 跳转到游戏场景
    app:enterScene("MainScene", nil, "fade", 1.2)
end

function GameScene:getMapLayer()
    return self.mapLayer
end

function GameScene:getUILayer()
    return self.uiLayer
end

function GameScene:getPlayer()
    return self.player
end

return GameScene
local MapLayer = class("MapLayer", function()
    return display.newLayer()
end)

MapLayer.mapWidth = 0
MapLayer.flag = nil
MapLayer.success = true

MapLayer.scene = nil

function MapLayer:ctor(scene)

	self:pos(0, 0)
    self:addTo(scene)
    self.scene = scene
	
    -- 地图
	local map = cc.TMXTiledMap:create("res/level1.tmx"):pos(0, 0):addTo(self)

	--加载UI
	self:initUI(map:getContentSize().width)

	--加载地图数据
	self:initMap(map)
end

function MapLayer:initUI(mapWidth)

	self.mapWidth = mapWidth

	--子弹提示
	--display.newSprite("#Tip.png"):pos(display.left + 330, display.top - 132):addTo(self)
    
    --开始彩虹
    display.newSprite("#RainBow.png"):pos(display.left + 60, display.cy + 40):addTo(self, -1)

    --结束彩虹
	display.newSprite("#RainBow.png"):flipX(true):pos(mapWidth - 60, display.cy + 40):addTo(self, -1)

	--旗帜
	self.flag = display.newSprite("#Flag.png"):pos(mapWidth - 150, display.bottom + 103):addTo(self, -1)
end

--地图宽度
function MapLayer:initMap(map)
	--加载方块
	for i,v in ipairs(map:getObjectGroup("blocks"):getObjects()) do
        local name = v["type"] == "0" and v["name"] or (v["name"].."_"..math.random(1, 3))
        local animation = display.newAnimation(display.newFrames(name.."_%d.png", 0, 5), 0.3)
        local block = display.newSprite("#"..name.."_0.png"):pos(v["x"] + v["width"] / 2, v["y"] + v["height"] / 2):addTo(self)
        block:playAnimationForever(animation)
        
        local body = cc.PhysicsBody:createBox(cc.size(v["width"], v["height"]), cc.PhysicsMaterial(0, 0, 0))
        body:setDynamic(false)
        body:setCategoryBitmask(1)
        body:setContactTestBitmask(1)
        body:setCollisionBitmask(1)
        block:setPhysicsBody(body)
        block:setTag(v["type"] == "0" and TYPE_BLOCK_0 or TYPE_BLOCK_1)
    end

    --金币
    for i,v in ipairs(map:getObjectGroup("coins"):getObjects()) do
        local animation = display.newAnimation(display.newFrames("coin_%d.png", 0, 8), 0.25)
        local coin = display.newSprite("#coin_0.png"):pos(v["x"] + v["width"] / 2, v["y"] + v["height"] / 2):addTo(self)
        coin:playAnimationForever(animation)
        
        local body = cc.PhysicsBody:createBox(cc.size(v["width"], v["height"]), cc.PhysicsMaterial(0, 0, 0))
        body:setDynamic(false)

        body:setCategoryBitmask(3)
        body:setContactTestBitmask(1)
        body:setCollisionBitmask(2)
        coin:setPhysicsBody(body)
        coin:setTag(TYPE_COIN)
    end

    --子弹
    for i,v in ipairs(map:getObjectGroup("bullets"):getObjects()) do
        local animation = display.newAnimation(display.newFrames("bullet_%d.png", 0, 8), 0.25)
        local bullet = display.newSprite("#bullet_0.png"):pos(v["x"] + v["width"] / 2, v["y"] + v["height"] / 2):addTo(self)
        bullet:playAnimationForever(animation)
        
        local body = cc.PhysicsBody:createBox(cc.size(v["width"], v["height"]), cc.PhysicsMaterial(0, 0, 0))
        body:setDynamic(false)
        body:setCategoryBitmask(3)
        body:setContactTestBitmask(1)
        body:setCollisionBitmask(2)
        bullet:setPhysicsBody(body)
        bullet:setTag(TYPE_BULLET)
    end

    --金币罐
    for i,v in ipairs(map:getObjectGroup("pots"):getObjects()) do
        local animation = display.newAnimation(display.newFrames("pot_%d.png", 0, 8), 0.25)
        local pot = display.newSprite("#pot_0.png"):pos(v["x"] + v["width"] / 2, v["y"] + v["height"] / 2):addTo(self)
        pot:playAnimationForever(animation)
        
        local body = cc.PhysicsBody:createBox(cc.size(v["width"], v["height"]), cc.PhysicsMaterial(0, 0, 0))
        body:setDynamic(false)
        body:setCategoryBitmask(3)
        body:setContactTestBitmask(1)
        body:setCollisionBitmask(2)
        pot:setPhysicsBody(body)
        pot:setTag(TYPE_POT)
    end
    
    --墙
    for i,v in ipairs(map:getObjectGroup("walls"):getObjects()) do
        local wall = display.newNode():pos(v["x"] + v["width"] / 2, v["y"] + v["height"] / 2):addTo(self)
        local body = cc.PhysicsBody:createBox(cc.size(v["width"], v["height"]), cc.PhysicsMaterial(0, 0, 0))
        body:setDynamic(false)
        body:setCategoryBitmask(1)
        body:setContactTestBitmask(1)
        body:setCollisionBitmask(1)
        wall:setPhysicsBody(body)
        wall:setTag(TYPE_WALL)
    end
    
    --水
    for i,v in ipairs(map:getObjectGroup("waters"):getObjects()) do
        local water = display.newSprite("#water_1.png"):pos(v["x"] + v["width"] / 2, v["y"] + v["height"] / 2 - 3):addTo(self, -2)
        local seq = cc.Sequence:create(cc.MoveBy:create(1, cc.p(0, -6)),cc.MoveBy:create(1, cc.p(0, 6)))
        display.newSprite("#water_1.png"):pos(v["x"] + v["width"] / 2 + 10, v["y"] + v["height"] / 2):addTo(self, -1):runAction(cc.RepeatForever:create(seq))
    
        local body = cc.PhysicsBody:createBox(cc.size(v["width"], v["height"]), cc.PhysicsMaterial(0, 0, 0))
        body:setDynamic(false)
        body:setCategoryBitmask(1)
        body:setContactTestBitmask(1)
        body:setCollisionBitmask(1)
        water:setPhysicsBody(body)
        water:setTag(TYPE_WATER)
    end
    
     --虫
    for i,v in ipairs(map:getObjectGroup("worms"):getObjects()) do
        local animation = display.newAnimation(display.newFrames("worm_%d.png", 0, 4), 0.25)
        local worm = display.newSprite("#worm_0.png"):pos(v["x"] + v["width"] / 2, v["y"] + v["height"] / 2):addTo(self)
        worm:playAnimationForever(animation)

        local body = cc.PhysicsBody:createBox(cc.size(v["width"], v["height"]), cc.PhysicsMaterial(0, 0, 0))
        body:setCategoryBitmask(1)
        body:setContactTestBitmask(1)
        body:setCollisionBitmask(1)
        body:setVelocity(cc.p(-100, 0))
        worm:setPhysicsBody(body)
        worm:setTag(TYPE_WORM)
    end
end

function MapLayer:getMapWidth()
	return self.mapWidth
end

function MapLayer:move()
    --设置玩家不倒下
    self.scene:getPlayer():setRotation(0)
    local playerX = self.scene:getPlayer():getPositionX()
    if playerX >= self.flag:getPositionX() then
        if self.success == true then
            transition.moveBy(self.flag, {time = 0.5, y = 210})
            self.success = false
            transition.stopTarget(self.scene:getPlayer())
        end
        return true
    else
        self.scene:getPlayer():jumpX(200)
        local px = 300 -  playerX
        px = px > 0 and 0 or px
        local width = display.width - self.mapWidth
        px = px < width and width or px
        self:setPositionX(px)
        return false
    end
end

return MapLayer
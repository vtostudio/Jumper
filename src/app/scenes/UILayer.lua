local UILayer = class("UILayer", function()
    return display.newLayer()
end)

--引入定时器
local scheduler = require("framework.scheduler")

UILayer.handle = nil

UILayer.scene = nil

UILayer.coin = nil

UILayer.bullet = nil

UILayer.start = false

function UILayer:ctor(scene)

	self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(false)
    self:addTo(scene)
    self.scene = scene

	-- 加载图片集
    display.addSpriteFrames("res/gameui.plist", "res/gameui.png", nil)

    --UI控件
    self:initUI()

end

function UILayer:initUI()
	
	--生命
    display.newSprite("#Header.png"):pos(display.left + 45, display.top - 28):addTo(self)
    cc.Label:createWithCharMap("res/Number.png", 23, 31, 48):pos(display.left + 85, display.top - 30):addTo(self):setString("5")
    
    --金币
    local coinAnim = display.newAnimation(display.newFrames("coinx_%d.png", 0, 7), 0.25)
    display.newSprite("#coinx_0.png"):pos(display.left + 180, display.top - 28):addTo(self):playAnimationForever(coinAnim)
    self.coin = cc.Label:createWithCharMap("res/Number.png", 23, 31, 48):align(display.LEFT_CENTER, display.left + 205, display.top - 30):addTo(self)
    self.coin:setString("0")

    --子弹
    local bulletAnim = display.newAnimation(display.newFrames("bulletx_%d.png", 0, 7), 0.25)
    display.newSprite("#bulletx_0.png"):pos(display.left + 300, display.top - 24):addTo(self):playAnimationForever(bulletAnim)
    self.bullet = cc.Label:createWithCharMap("res/Number.png", 23, 31, 48):align(display.LEFT_CENTER, display.left + 325, display.top - 30):addTo(self)
    self.bullet:setString("0")

    --计时器
    local timerAnim = display.newAnimation(display.newFrames("timer_%d.png", 0, 7), 1)
    display.newSprite("#timer_0.png"):pos(display.right - 180, display.top - 30):addTo(self):playAnimationForever(timerAnim)
    local totalTimes = cc.Label:createWithCharMap("res/Number.png", 23, 31, 48):align(display.LEFT_CENTER, display.right - 150, display.top - 30):addTo(self)
    totalTimes:setString("280")
    self.handle = scheduler.scheduleGlobal(function(dt)
    	local total = tonumber(totalTimes:getString())
		if total > 0 then
			totalTimes:setString(total - 1)
		else
			self.scene:exitGame()
		end
    end, 1)

    -- 暂停按钮
    local pause = display.newSprite("#Pause.png"):pos(display.right - 26, display.top - 30):addTo(self)
    -- 设置触摸事件
    pause:setTouchEnabled(true)
    pause:setTouchSwallowEnabled(true)
    pause:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == 'began' then
            pause:setScale(0.8)
        elseif event.name == 'moved' then
            
        elseif event.name == 'ended' then
            pause:setScale(1.0)
            self.scene:exitGame()
        end
        return true
    end)

    --[[前走按钮
    local right = display.newSprite("#Flag.png"):pos(display.left + 200, display.bottom + 40):addTo(self)
    -- 设置触摸事件
    right:setTouchEnabled(true)
    right:setTouchSwallowEnabled(true)
    right:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == 'began' then
            --self.scene:getPlayer():flipX(false)
            self.scene:getPlayer():jumpX(200)
            
        end
        return true
    end)

    -- 后走按钮
    local left = display.newSprite("#Flag.png"):flipX(true):pos(display.left + 100, display.bottom + 40):addTo(self)
    -- 设置触摸事件
    left:setTouchEnabled(true)
    left:setTouchSwallowEnabled(true)
    left:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == 'began' then
            --self.scene:getPlayer():flipX(true)
            self.scene:getPlayer():jumpX(-200)
        end
        return true
    end)]]

    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == 'began' then
            if not self.start then
                self.scene:getPlayer():startAnim()
                self.scene:onStart()
                self.start = true
            else
                if self.scene:getPlayer():getIsJump() == true then
                    self.scene:getPlayer():jumpY(800)
                    self.scene:getPlayer():setIsJump(false)
                end
            end
        end
        return true
    end)
end

function UILayer:setCoins(num)
    local total = tonumber(self.coin:getString())
    self.coin:setString(total + num)
end

function UILayer:setBullets(num)
    local total = tonumber(self.bullet:getString())
    self.bullet:setString(total + num)
end

function UILayer:back()
    if self.handle then
        scheduler.unscheduleGlobal(self.handle)
    end
end

return UILayer
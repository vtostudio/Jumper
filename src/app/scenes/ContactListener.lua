local ContactListener = class("ContactListener")

ContactListener.scene = nil

function ContactListener:ctor(scene)
	self.scene = scene
	
	--注册我们的碰撞检测
	--当有事件发生的时候，就能调用这个回调函数 self.onContactBegin
	local eventDispathcher = cc.Director:getInstance():getEventDispatcher()

	--begin
    local listener = cc.EventListenerPhysicsContact:create()
    listener:registerScriptHandler(handler(self,self.onContactBegin), cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    eventDispathcher:addEventListenerWithSceneGraphPriority(listener, self.scene) 
    --end

    --[[PreSolve
    listener = cc.EventListenerPhysicsContact:create()
    listener:registerScriptHandler(handler(self,self.onPresolve), cc.Handler.EVENT_PHYSICS_CONTACT_PRESOLVE)
    eventDispathcher:addEventListenerWithSceneGraphPriority(listener, self.scene) 
    --end

    --PostSolve
    listener = cc.EventListenerPhysicsContact:create()
    listener:registerScriptHandler(handler(self,self.onPostSolve), cc.Handler.EVENT_PHYSICS_CONTACT_POSTSOLVE)
    eventDispathcher:addEventListenerWithSceneGraphPriority(listener, self.scene) 
    --end

    --endContast
    listener = cc.EventListenerPhysicsContact:create()
    listener:registerScriptHandler(handler(self,self.onContactEnd), cc.Handler.EVENT_PHYSICS_CONTACT_SEPERATE)
    eventDispathcher:addEventListenerWithSceneGraphPriority(listener, self.scene) 
    --end]]
end

--BeginContact,回调函数
function ContactListener:onContactBegin(contact)

    --碰撞接触面
    local p = contact:getContactData()["normal"]

    local bodyA = contact:getShapeA():getBody()
    local bodyB = contact:getShapeB():getBody()

    local tagA = bodyA:getNode():getTag()
    local tagB = bodyB:getNode():getTag()

	--是哪两个物体
    self:contactAB(bodyA)
    self:contactAB(bodyB)

    if tagA == TYPE_PLAYER and tagB == TYPE_WATER or tagB == TYPE_PLAYER and tagA == TYPE_WATER  then
        self.scene:getPlayer():stopAnim()
        self.scene:failed()
    end

    if tagA == TYPE_BLOCK_0 or tagA == TYPE_BLOCK_1 then
        local p = contact:getContactData()["normal"]
        if p.y == -1 and p.x == 0 then
            bodyA:removeFromWorld()
            bodyA:getNode():stopAllActions()
            bodyA:getNode():playAnimationOnce(display.newAnimation(display.newFrames("bullet_%d.png", 8, 4), 0.25), true)
        else
            self.scene:getPlayer():resumeAnim()
        end
    end

    if tagB == TYPE_BLOCK_0 or tagB == TYPE_BLOCK_1 then
        local p = contact:getContactData()["normal"]
        if p.y == 1 and p.x == 0 then
            bodyB:removeFromWorld()
            bodyB:getNode():stopAllActions()
            bodyB:getNode():playAnimationOnce(display.newAnimation(display.newFrames("bullet_%d.png", 8, 4), 0.25), true)
        else
            self.scene:getPlayer():resumeAnim()
        end
    end

    self:contactWorm(bodyA, bodyB, p)
    
    return true
end

function ContactListener:contactWorm(bodyA, bodyB, p)
    if bodyA:getNode():getTag() == TYPE_WORM then
        --[[if p.x < 0 then
            bodyA:setVelocity(cc.p(100, 0))
            bodyA:getNode():flipX(true)
        end
        if p.x > 0 then
            bodyA:setVelocity(cc.p(-100, 0))
            bodyA:getNode():flipX(false)
        end]]
        local d = p.x < 0 and 1 or -1
        bodyA:setVelocity(cc.p(d * 100, 0))
        bodyA:getNode():flipX(p.x < 0)
    end
    if bodyB:getNode():getTag() == TYPE_WORM then
        --[[if p.x > 0 then
            bodyB:setVelocity(cc.p(100, 0))
            bodyB:getNode():flipX(true)
        end
        if p.x < 0 then
            bodyB:setVelocity(cc.p(-100, 0))
            bodyB:getNode():flipX(false)
        end]]
        local d = p.x > 0 and 1 or -1
        bodyB:setVelocity(cc.p(d * 100, 0))
        bodyB:getNode():flipX(p.x > 0)
    end
end

function ContactListener:contactAB(body)
	local node = body:getNode()
	local tag = node:getTag()
	if tag == TYPE_COIN then
		self.scene:getUILayer():setCoins(1)
		body:removeFromWorld()
		node:stopAllActions()
		node:playAnimationOnce(display.newAnimation(display.newFrames("coin_%d.png", 8, 4), 0.25), true)
	elseif tag == TYPE_BULLET then
		self.scene:getUILayer():setBullets(1)
		body:removeFromWorld()
		node:stopAllActions()
		node:playAnimationOnce(display.newAnimation(display.newFrames("bullet_%d.png", 8, 4), 0.25), true)
	elseif tag == TYPE_POT then
		self.scene:getUILayer():setCoins(5)
		body:removeFromWorld()
		node:stopAllActions()
		node:playAnimationOnce(display.newAnimation(display.newFrames("pot_%d.png", 8, 4), 0.25), true)
	elseif tag == TYPE_PLAYER then
		self.scene:getPlayer():setIsJump(true)
    elseif tag == TYPE_WALL then
        self.scene:getPlayer():resumeAnim()
	end
end

function ContactListener:onContactEnd(contact)
    local sp1 = contact:getShapeA():getBody():getNode();
    local sp2 = contact:getShapeB():getBody():getNode();
    print("onContactEnd")
end

function ContactListener:onPresolve(contact, solve)
    local sp1 = contact:getShapeA():getBody():getNode();
    local sp2 = contact:getShapeB():getBody():getNode();
    print("onPresolve")
    return true
end

function ContactListener:onPostSolve(contact)
    local sp1 = contact:getShapeA():getBody():getNode();
    local sp2 = contact:getShapeB():getBody():getNode();
    print("onPostSolve")
    return true
end

return ContactListener
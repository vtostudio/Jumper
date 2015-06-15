local Player = class("Player", function()
    return display.newSprite("#player_0.png")
end)

Player.scene = nil
Player.bBody = nil

Player.isJump = true

Player.animation = nil

function Player:ctor(scene)
	
	self:addTo(scene:getMapLayer())
	self.scene = scene
	self.isJump = true

	self.bBody = cc.PhysicsBody:createBox(cc.size(48, 76), cc.PhysicsMaterial(5000, 0.8, 0))
    self.bBody:setDynamic(true)
    self.bBody:setCategoryBitmask(1)
    self.bBody:setContactTestBitmask(1)
    self.bBody:setCollisionBitmask(1)
    self:setPhysicsBody(self.bBody)
    self:setPosition(100, display.bottom + 120)
    self:setTag(TYPE_PLAYER)
end

function Player:force(dx, dy)
	self.bBody:applyForce(cc.p(dx, dy))
end

function Player:jump(dx, dy)
	--self:flipX(dx < 0)
	self.bBody:setVelocity(cc.p(dx, dy))
end

function Player:jumpX(dx)
	self:jump(dx, self.bBody:getVelocity().y)
end

function Player:jumpY(dy)
	self:pauseAnim()
	self:setSpriteFrame(display.newSpriteFrame("player_5.png"))

	self:jump(self.bBody:getVelocity().x, dy)
end

function Player:startAnim()
	if not self.animation then
		self.animation = display.newAnimation(display.newFrames("player_%d.png", 0, 6), 0.1)
    	self:playAnimationForever(self.animation)
	end
end

function Player:pauseAnim()
	transition.pauseTarget(self)
end

function Player:resumeAnim()
	transition.resumeTarget(self)
end

function Player:stopAnim()
	transition.stopTarget(self)
	self:setSpriteFrame(display.newSpriteFrame("player_8.png"))
end

function Player:setIsJump(jsJump)
	self.isJump = jsJump
end

function Player:getIsJump()
	return self.isJump
end

return Player
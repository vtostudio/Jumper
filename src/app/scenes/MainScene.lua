
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    
    -- 加载图片集
    display.addSpriteFrames("res/mainscene.plist", "res/mainscene.png", nil)

     -- 添加背景图片
    local scale = display.width / display.height > 800 / 480 and display.width / 800 or display.height / 480
    local bg = display.newSprite("#Bg.png"):scale(scale):pos(display.cx, display.cy):addTo(self)
    bg:setKeypadEnabled(true)
    bg:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
        if event.key == "back" then
            app:exit()
        end
    end)

    -- 开始按钮
    local play = display.newSprite("#Start.png"):pos(display.cx + 90, display.cy - 9):addTo(self)
    -- 设置触摸事件
    play:setTouchEnabled(true)
    play:setTouchSwallowEnabled(false)
    play:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == 'began' then
            play:setScale(0.8)
        elseif event.name == 'moved' then

        elseif event.name == 'ended' then
            play:setScale(1.0)
            -- 跳转到游戏场景
            app:enterScene("GameScene", nil, "fade", 1.2)
        end
        return true
    end)

    -- 继续游戏按钮
    local continue = display.newSprite("#Continue.png"):pos(display.cx + 90, display.cy - 100):addTo(self)
    -- 设置触摸事件
    continue:setTouchEnabled(true)
    continue:setTouchSwallowEnabled(false)
    continue:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == 'began' then
            continue:setScale(0.8)
        elseif event.name == 'moved' then

        elseif event.name == 'ended' then
            continue:setScale(1.0)
            -- 跳转到游戏场景
            app:enterScene("GameScene", nil, "fade", 1.2)
        end
        return true
    end)

    -- 音效开关按钮
    local status = GameData.Sound == nil and true or GameData.Sound
    local sound = display.newSprite(status == true and "#On.png" or "#Off.png"):pos(display.right - 64, display.bottom + 64):addTo(self)
    -- 设置触摸事件
    sound:setTouchEnabled(true)
    sound:setTouchSwallowEnabled(false)
    sound:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == 'began' then
            sound:setScale(0.8)
        elseif event.name == 'moved' then

        elseif event.name == 'ended' then
            sound:setScale(1.0)
            status = not status
            sound:setSpriteFrame(display.newSpriteFrame(status == true and "On.png" or "Off.png"))
            GameData.Sound = status
            GameState.save(GameData)
        end
        return true
    end)

end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene

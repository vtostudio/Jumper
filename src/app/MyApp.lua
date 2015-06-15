
require("config")
require("cocos.init")
require("framework.init")

-- 加载GameState(数据存储)
require("framework.cc.init")
GameState=require("framework.cc.utils.GameState")
-- global var
GameData={}
TYPE_PLAYER  = 1000
TYPE_BLOCK_0 = 1001
TYPE_BLOCK_1 = 1002
TYPE_COIN    = 1003
TYPE_BULLET  = 1004
TYPE_POT     = 1005
TYPE_WALL    = 1006
TYPE_WATER   = 1007
TYPE_WORM    = 1008


local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)

    --设置随机函数种子
    math.randomseed(tonumber(tostring(os.time()):reverse()))

    -- 初始化
    GameState.init(function(param)
        local returnValue=nil
        if param.errorCode then
            CCLuaLog("error")
        else
            -- 加解密
            if param.name=="save" then
                local str=json.encode(param.values)
                str=crypto.encryptXXTEA(str, "vtostudio123")
                returnValue={data=str}
            elseif param.name=="load" then
                local str=crypto.decryptXXTEA(param.values.data, "vtostudio123")
                returnValue=json.decode(str)
            end
        end
        return returnValue
    end, "data.txt", "12345678")
    if io.exists(GameState.getGameStatePath()) then
        GameData=GameState.load()
    end
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    self:enterScene("MainScene")
end

return MyApp

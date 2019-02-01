---@class MenuState : BaseState
MenuState = Class {__includes = BaseState}

function MenuState:init()
    self._titleText = love.graphics.newText(gFont, "Press ENTER To Continue")
    self._titleMaxTimer = 2
    self._titleTimer = self._titleMaxTimer

    gSounds.theme:play()
    gSounds.theme:setLooping(true)
end

function MenuState:render()
    love.graphics.draw(
        gTextures.backgrounds[1],
        0,
        0,
        0,
        WINDOW_WIDTH / (gTextures.backgrounds[1]:getWidth() - 1),
        WINDOW_HEIGHT / (gTextures.backgrounds[1]:getHeight() - 1)
    )
    love.graphics.draw(gTextures.logo, WINDOW_WIDTH / 2 - gTextures.logo:getWidth() / 2, WINDOW_HEIGHT / 2 - 100)

    if (self._titleTimer <= 1.2) then
        love.graphics.draw(self._titleText, WINDOW_WIDTH / 2 - self._titleText:getWidth() / 2, WINDOW_HEIGHT / 2 + 100)
    end
end

function MenuState:update(dt)
    if (love.keyboard.wasPressed("return")) then
        gStateMachine:change("play")
    end

    if (self._titleTimer > 0) then self._titleTimer = math.max(0, self._titleTimer - dt)
    else self._titleTimer = self._titleMaxTimer end
end

function MenuState:exit()
    gSounds.theme:pause()
end

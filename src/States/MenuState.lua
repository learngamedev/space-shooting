---@class MenuState : BaseState
MenuState = Class {__includes = BaseState}

function MenuState:init()
    self._title = love.graphics.newText(gFont, "Press ENTER To Continue")
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
    love.graphics.draw(self._title, WINDOW_WIDTH / 2 - self._title:getWidth() / 2, WINDOW_HEIGHT / 2)
end

function MenuState:update(dt)
    if (love.keyboard.wasPressed("enter")) then
    end
end

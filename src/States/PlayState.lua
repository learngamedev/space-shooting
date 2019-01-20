---@class PlayState : BaseState
PlayState = Class {__includes = BaseState}

local PLAYER_SPEED = 70

function PlayState:init()
    self._player = Player(100, 100)
    self._backgroundsY = {0, nil, -480, -960}
    self._backgroundScrollSpeed = 130
end

function PlayState:render()
    for k, i in ipairs({1, 3, 4}) do
        love.graphics.draw(
            gTextures.backgrounds[i],
            0,
            self._backgroundsY[i],
            0,
            WINDOW_WIDTH / (640 - 1),
            WINDOW_HEIGHT / (480 - 1)
        )
    end
    self._player:render()
end

function PlayState:update(dt)
    for k, i in ipairs({1, 3, 4}) do
        self._backgroundsY[i] = self._backgroundsY[i] + self._backgroundScrollSpeed * dt
        if (self._backgroundsY[i] >= WINDOW_HEIGHT) then
            self._backgroundsY[i] = -959
        end
    end
    self._player:update(dt)
end

---@class PlayState : BaseState
PlayState = Class {__includes = BaseState}

function PlayState:init()
    self._player = Player(WINDOW_WIDTH / 2 - 23, 200)
    self._backgroundsY = {0, nil, -480, -960}
    self._backgroundScrollSpeed = 130
    self._crates = {} ---@type Crate[]
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

    for i = 1, #self._crates do
        if (self._crates[i]) then
            self._crates[i]:render()
        end
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

    for i = 1, #self._crates do
        if (self._crates[i]) then
            -- Update crates
            self._crates[i]:update(dt)

            if (not self._crates[i]._popped) then
                for j = 1, #self._player._bullets do
                    if (self._player._bullets[j]) then
                        if (self._crates[i]:collides(self._player._bullets[j], self._player._bulletID)) then
                            table.remove(self._player._bullets, j)
                            self._crates[i]:pop()
                            break
                        end 
                    end
                end
            else
                if (self._crates[i]:collides(self._player._ship)) then
                    self._player:getPowerup(self._crates[i])
                    table.remove(self._crates, i)
                end
            end
        end
    end
end

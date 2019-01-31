---@class PlayState : BaseState
PlayState = Class {__includes = BaseState}

function PlayState:init()
    self._player = Player(WINDOW_WIDTH / 2 - 23, WINDOW_HEIGHT - gFrames.ships[3].height)
    self._backgroundsY = {0, nil, -480, -960}
    self._backgroundScrollSpeed = 130
    self._crates = {} ---@type Crate[]
    self._enemies = LevelMaker.getLevel("data/level1.json") ---@type Enemy[]
    -- self._enemies = {Enemy(100, 100, 10, ENEMIES[10].bulletID, ENEMIES[10].hp, ENEMIES[10].speed, true, false)}
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

    for i = 1, #self._enemies do
        self._enemies[i]:render()
    end
end

function PlayState:update(dt)
    self:updateBackground(dt)
    self._player:update(dt)
    self:updateCrates(dt)
    self:updateEnemies(dt)
end

function PlayState:updateBackground(dt)
    for k, i in ipairs({1, 3, 4}) do
        self._backgroundsY[i] = math.floor(self._backgroundsY[i] + self._backgroundScrollSpeed * dt)
        if (self._backgroundsY[i] >= WINDOW_HEIGHT) then
            self._backgroundsY[i] = -959
        end
    end
end

function PlayState:updateCrates(dt)
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

function PlayState:updateEnemies(dt)
    for i = 1, #self._enemies do
        if (self._enemies[i]) then
            -- Update bullets
            for k = 1, #self._enemies[i]._bullets do
                local bullet = self._enemies[i]._bullets[k]
                if (bullet) then
                    bullet:update(dt)
                    if
                        (checkCollision(
                            bullet._x - gFrames.bullets[bullet._bulletID].width,
                            bullet._y - gFrames.bullets[bullet._bulletID].height,
                            gFrames.bullets[bullet._bulletID].width,
                            gFrames.bullets[bullet._bulletID].height,
                            self._player._ship._x,
                            self._player._ship._y,
                            self._player._width,
                            self._player._height
                        ))
                     then
                        self._player:changeHealth(-BULLETS[bullet._bulletID].damage)
                        table.remove(self._enemies[i]._bullets, k)
                    end

                    if (bullet._y > WINDOW_HEIGHT) then
                        table.remove(self._enemies[i]._bullets, k)
                    end
                end
            end

            -- Update enemy's ship
            if (not self._enemies[i]._destroyed) then
                self._enemies[i]:update(dt, self._player)
            end

            -- Check for collision with player's bullets
            for j = 1, #self._player._bullets do
                if (self._player._bullets[j]) then
                    if (self._enemies[i]:hit(self._player._bullets[j])) then
                        table.remove(self._player._bullets, j)
                        self._enemies[i]._ship._health =
                            self._enemies[i]._ship._health - BULLETS[self._player._bulletID].damage
                        if (self._enemies[i]._ship._health <= 0) then
                            self._enemies[i]._destroyed = true
                            self._player._score = self._player._score + ENEMIES[self._enemies[i]._ship._shipID].score
                        end
                    end
                end
            end

            if (self._enemies[i]._destroyed and #self._enemies[i]._bullets == 0) then
                table.remove(self._enemies, i)
            end
        end
    end
end

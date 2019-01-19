---@class Player
Player = Class {}

local PLAYER_SPEED = 180

function Player:init(x, y)
    self._ship = Ship(x, y, 3, 100)
    self._bulletID = 1
    self._bullets = {} ---@type Bullet[]
    self._width, self._height = gFrames.ships[3].width, gFrames.ships[3].height
end

function Player:render()
    self._ship:render()

    for i = 1, #self._bullets do
        if (self._bullets[i]) then
            self._bullets[i]:render()
        end
    end
end

function Player:update(dt)
    self:move(dt)
    self:shoot()

    for i = 1, #self._bullets do
        if (self._bullets[i]) then
            self._bullets[i]:update(dt)
            if (self._bullets[i]._y < -(gFrames.bullets[self._bulletID]).height) then
                table.remove(self._bullets, i)
            end
        end
    end
end

function Player:move(dt)
    if (love.keyboard.isDown("left")) then
        self._ship._x = math.max(0, self._ship._x - PLAYER_SPEED * dt)
    elseif (love.keyboard.isDown("right")) then
        self._ship._x = math.min(WINDOW_WIDTH - self._width, self._ship._x + PLAYER_SPEED * dt)
    end

    if (love.keyboard.isDown("up")) then
        self._ship._y = math.max(0, self._ship._y - PLAYER_SPEED * dt)
    elseif (love.keyboard.isDown("down")) then
        self._ship._y = math.min(WINDOW_HEIGHT - self._height, self._ship._y + PLAYER_SPEED * dt)
    end
end

function Player:shoot()
    if (love.keyboard.wasPressed("space")) then
        table.insert(
            self._bullets,
            Bullet(
                self._ship._x + self._width / 2 - gFrames.bullets[self._bulletID].width / 2,
                self._ship._y - 10,
                self._bulletID
            )
        )
        gSounds.shoot:play()
    end
end

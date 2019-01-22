---@class Player
Player = Class {}

local PLAYER_SPEED = 180

function Player:init(x, y)
    self._ship = Ship(x, y, 3, 100)
    self._width, self._height = gFrames.ships[3].width, gFrames.ships[3].height

    self._bulletID = 1
    self._bullets = {} ---@type Bullet[]

    self._cooldownTimer = 0

    self._health = {
        barX = WINDOW_WIDTH - gFrames.huds[4].width - 5,
        barY = 5,
        width = gFrames.huds[4].width,
        height = gFrames.huds[4].height
    }

    self._live = {
        remaining = 3,
        firstX = self._health.barX + (self._health.width / 2 - 85 / 2),
        firstY = self._health.barY + self._health.height,
        width = gFrames.huds[6].width,
        height = gFrames.huds[6].height
    }
end

function Player:render()
    self._ship:render()

    for i = 1, #self._bullets do
        if (self._bullets[i]) then
            self._bullets[i]:render()
        end
    end

    -- Render healh bar and lives
    love.graphics.draw(gTextures.huds, gFrameQuads.huds["health-bar"], self._health.barX, self._health.barY)
    love.graphics.draw(
        gTextures.huds,
        gFrameQuads.huds["health-bar-fill"],
        self._health.barX + 9,
        self._health.barY + 7
    )

    for i = 1, 3 do
        if (i <= self._live.remaining) then
            love.graphics.draw(
                gTextures.huds,
                gFrameQuads.huds["life-full"],
                self._live.firstX + (i - 1) * 30,
                self._live.firstY
            )
        else
            love.graphics.draw(
                gTextures.huds,
                gFrameQuads.huds["life-empty"],
                self._live.firstX + (i - 1) * 30,
                self._live.firstY
            )
        end
    end
end

function Player:update(dt)
    self:move(dt)
    self:shoot(dt)

    for i = 1, #self._bullets do
        if (self._bullets[i]) then
            self._bullets[i]:update(dt)
            if (self._bullets[i]._y < -(gFrames.bullets[self._bulletID]).height) then
                table.remove(self._bullets, i)
            end
        end
    end

    if (love.keyboard.wasPressed("f")) then
        if (self._bulletID < #BULLETS) then
            self._bulletID = self._bulletID + 1
        else self._bulletID = 1 end
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

function Player:shoot(dt)
    if (self._cooldownTimer == 0) then
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
            self._cooldownTimer = BULLETS[self._bulletID].cooldown
        end
    else self._cooldownTimer = math.max(0, self._cooldownTimer - 30 * dt) end
end

function Player:changeHealth(number)
    self._ship._health = math.min(100, self._ship._health + number)
    gFrameQuads.huds["health-bar-fill"] =
        love.graphics.newQuad(
        gFrames.huds[3].x,
        gFrames.huds[3].y,
        gFrames.huds[3].width / 100 * self._ship._health,
        gFrames.huds[3].height,
        gTextures.huds:getDimensions()
    )
end
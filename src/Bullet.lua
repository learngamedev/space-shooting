---@class Bullet
Bullet = Class{}

BULLETS = {
    [1] = {
        cooldown = 20,
        damage = 80,
        speed = 150
    },
    [2] = {
        cooldown = 10,
        damage = 50,
        speed = 130
    },
    [3] = {
        cooldown = 2,
        damage = 15,
        speed = 250
    },
    [4] = {
        cooldown = 5,
        damage = 15,
        speed = 200
    },
    [5] = {
        cooldown = 5,
        damage = 15,
        speed = 200
    },
    [6] = {
        cooldown = 5,
        damage = 15,
        speed = 200
    },
    [7] = {
        cooldown = 5,
        damage = 15,
        speed = 200
    }
}

function Bullet:init(x, y, bulletID)
    self._x, self._y = x, y
    self._bulletID = bulletID
end

function Bullet:render()
    love.graphics.draw(gTextures.bullets, gFrameQuads.bullets[self._bulletID], self._x, self._y)
end

function Bullet:update(dt)
    self._y = self._y - BULLETS[self._bulletID].speed * dt
end
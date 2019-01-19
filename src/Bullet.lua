---@class Bullet
Bullet = Class{}

function Bullet:init(x, y, bulletID)
    self._x, self._y = x, y
    self._bulletID = bulletID
end

function Bullet:render()
    love.graphics.draw(gTextures.bullets, gFrameQuads.bullets[self._bulletID], self._x, self._y)
end

function Bullet:update(dt)
    self._y = self._y - 200 * dt
end
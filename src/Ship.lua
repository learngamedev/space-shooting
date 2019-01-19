---@class Ship
Ship = Class{}

---@param shipID number
function Ship:init(x, y, shipID, health)
    self._x, self._y = x, y
    self._shipID = shipID
    self._health = health
end

function Ship:render()
    love.graphics.draw(gTextures.ships, gFrames.ships[self._shipID], self._x, self._y)
end
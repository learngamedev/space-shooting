---@class Crate
Crate = Class {}

gCrates = {}

local Y_VELOCITY = 20

function Crate:init(x, y)
    self._x, self._y = x, y
    self._popped = false
    self._itemID = nil
end

function Crate:render()
    if (not self._popped) then
        love.graphics.draw(gTextures.items, gFrameQuads.items["crate-2"], self._x, self._y, 0, 1.3, 1.3)
    else
        love.graphics.draw(
            gTextures.items,
            gFrameQuads.items[gFrames.items[self._itemID].key],
            self._x,
            self._y,
            0,
            1.3,
            1.3
        )
    end
end

function Crate:update(dt)
    self._y = self._y + Y_VELOCITY * dt
end

---@param target Bullet
function Crate:collides(target, bulletID)
    local targetWidth, targetHeight
    if (bulletID) then
        targetWidth, targetHeight = gFrames.bullets[bulletID].width, gFrames.bullets[bulletID].height
    else
        targetWidth, targetHeight = gFrames.ships[3].width, gFrames.ships[3].height
    end
    if
        (checkCollision(
            self._x,
            self._y,
            gFrames.items[2].width * 1.3,
            gFrames.items[2].height * 1.3,
            target._x,
            target._y,
            targetWidth,
            targetHeight
        ))
     then
        return true
    end
    return false
end

function Crate:pop()
    local rand = math.random(1, 2)
    if (rand == 1) then
        self._itemID = 3
    else self._itemID = 5 end
    self._popped = true
end

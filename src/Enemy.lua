---@class Enemy
Enemy = Class {}

function Enemy:init(x, y, shipID, bulletID, hp, speed, chasePlayer, randomMovement)
    self._ship = Ship(x, y, shipID, hp)

    self._dx, self._dy = 0, 0
    self._speed = speed

    self._chasingPlayer = chasePlayer or false
    self._randomMovement = randomMovement or false
    self._randomTimer = 50

    self._bulletID = bulletID
    self._bullets = {} ---@type Bullet[]
    self._cooldownTimer = 0
end

function Enemy:render()
    self._ship:render()

    for i = 1, #self._bullets do
        if (self._bullets[i]) then
            self._bullets[i]:render()
        end
    end
end

function Enemy:update(dt)
    if (self._randomMovement) then
        if (self._randomTimer == 0) then
            self:setVelocity(math.random(-1, 1), math.random(-1, 1))
            self._randomTimer = math.random(20, 50)
        else self._randomTimer = math.max(0, self._randomTimer - 20 * dt) end
    end

    self._ship._x = math.floor(self._ship._x + self._speed * self._dx * dt)
    self._ship._y = math.floor(self._ship._y + self._speed * self._dy * dt)

    self._ship._x = math.max(0, self._ship._x)
    self._ship._x = math.min(self._ship._x, WINDOW_WIDTH - gFrames.ships[self._ship._shipID].width)
    self._ship._y = math.max(0, self._ship._y)
    self._ship._y = math.min(self._ship._y, WINDOW_HEIGHT - gFrames.ships[self._ship._shipID].height)

    self:shoot(dt)
end

function Enemy:setVelocity(dx, dy)
    self._dx, self._dy = dx or 0, dy or 0
end

---@param target Bullet
function Enemy:hit(target)
    if
        (checkCollision(
            self._ship._x,
            self._ship._y,
            gFrames.ships[self._ship._shipID].width,
            gFrames.ships[self._ship._shipID].height,
            target._x,
            target._y,
            gFrames.bullets[target._bulletID].width,
            gFrames.bullets[target._bulletID].height
        ))
     then
        return true
    end
    return false
end

function Enemy:chasePlayer(player)
    local dx, dy = 0, 0
    if (self._ship._x > player._ship._x) then
        dx = -1
    elseif (self._ship._x < player._ship._x) then
        dx = 1
    end
    if (self._ship._y > player._ship._y) then
        dy = -1
    elseif (self._ship._y < player._ship._y) then
        dy = 1
    end
    self:setVelocity(dx, dy)
end

function Enemy:shoot(dt)
    if (self._cooldownTimer > 0) then
        self._cooldownTimer = math.max(0, self._cooldownTimer - 5 * dt)
    else
        table.insert(
            self._bullets,
            Bullet(
                self._ship._x + gFrames.ships[self._ship._shipID].width / 2 + gFrames.bullets[self._bulletID].width / 2,
                self._ship._y + gFrames.ships[self._ship._shipID].height + 3,
                self._bulletID,
                3.14
            )
        )
        self._bullets[#self._bullets]._dy = 1
        self._cooldownTimer = BULLETS[self._bulletID].cooldown
    end
end

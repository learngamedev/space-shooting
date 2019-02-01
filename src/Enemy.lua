---@class Enemy
Enemy = Class {}

ENEMIES = {
    [10] = {
        bulletID = nil,
        hp = 50,
        speed = 100,
        score = 20
    },
    [9] = {
        bulletID = nil,
        hp = 110,
        speed = 70,
        score = 50,
    },
    [8] = {
        bulletID = 5,
        hp = 350,
        speed = 50,
        score = 100
    }
}

function Enemy:init(x, y, shipID, bulletID, hp, speed, chasePlayer, randomMovement, item)
    self._ship = Ship(x, y, shipID, hp)

    self._dx, self._dy = 0, 0
    self._speed = speed

    self._chasingPlayer = chasePlayer or false
    self._chasingTimer = math.random(10, 50)
    self._idleTimer = 0
    self._randomMovement = randomMovement or false
    self._randomTimer = 50

    self._bulletID = bulletID
    self._bullets = {} ---@type Bullet[]
    self._cooldownTimer = 0

    self._destroyed = false

    self._item = item or 0
end

function Enemy:render()
    if (not self._destroyed) then
        self._ship:render()
    end

    for i = 1, #self._bullets do
        if (self._bullets[i]) then
            self._bullets[i]:render()
        end
    end
end

---@param player Player
function Enemy:update(dt, player)
    if (self._randomMovement) then
        if (self._randomTimer == 0) then
            self:setVelocity(math.random(-1, 1), math.random(-1, 1))
            self._randomTimer = math.random(20, 50)
        else
            self._randomTimer = math.max(0, self._randomTimer - 20 * dt)
        end
    end

    self._ship._x = self._ship._x + self._speed * self._dx * dt
    self._ship._y = self._ship._y + self._speed * self._dy * dt

    self._ship._x = math.max(0, self._ship._x)
    self._ship._x = math.min(self._ship._x, WINDOW_WIDTH - gFrames.ships[self._ship._shipID].width)
    self._ship._y = math.max(0, self._ship._y)
    self._ship._y = math.min(self._ship._y, WINDOW_HEIGHT - gFrames.ships[self._ship._shipID].height)

    if (self._bulletID) then
        self:shoot(dt)
    end

    if (self._chasingPlayer) then
        if (self._chasingTimer > 0) then
            self:chasePlayer(player)
            self._chasingTimer = math.max(0, self._chasingTimer - 20 * dt)
            if (self._chasingTimer == 0) then
                self._idleTimer = math.random(20, 80)
                self._dx, self._dy = 0, 0
            end
        elseif (self._idleTimer > 0) then
            self._idleTimer = math.max(0, self._idleTimer - 20 * dt)
            if (self._idleTimer == 0) then
                self._chasingTimer = math.random(10, 50)
            end
        end
    end
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

---@param player Player
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

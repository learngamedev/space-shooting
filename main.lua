require("src/dependencies")

function love.load()
    gFont = getImageFont("assets/font/font.png")
    love.graphics.setFont(gFont)

    gTextures = {
        ["backgrounds"] = {
            love.graphics.newImage("assets/graphics/backgrounds/1.png"),
            love.graphics.newImage("assets/graphics/backgrounds/2.png"),
            love.graphics.newImage("assets/graphics/backgrounds/3.png"),
            love.graphics.newImage("assets/graphics/backgrounds/4.png"),
            love.graphics.newImage("assets/graphics/backgrounds/5.png")
        },
        ["ships"] = love.graphics.newImage("assets/graphics/ships.png"),
        ["bullets"] = love.graphics.newImage("assets/graphics/bullets.png"),
        ["huds"] = love.graphics.newImage("assets/graphics/huds.png"),
        ["items"] = love.graphics.newImage("assets/graphics/items.png")
    }

    gFrames = {
        ["ships"] = generateQuads(gTextures.ships, "assets/graphics/ships.json"),
        ["bullets"] = generateQuads(gTextures.bullets, "assets/graphics/bullets.json"),
        ["huds"] = generateQuads(gTextures.huds, "assets/graphics/huds.json"),
        ["items"] = generateQuads(gTextures.items, "assets/graphics/items.json")
    }

    gSounds = {
        ["theme"] = love.audio.newSource("assets/sounds/theme.ogg", "stream"),
        ["shoot"] = love.audio.newSource("assets/sounds/shoot.wav", "static"),
        ["power-up"] = love.audio.newSource("assets/sounds/power-up.wav", "static")
    }

    gStateMachine = StateMachine{
        ["menu"] = function() return MenuState() end
    }
    gStateMachine:change("menu")
end

function love.draw()
    displaySystemUsage()

    gStateMachine:render()
end

function love.update(dt)
    require("lib/lovebird").update()

    if (dt >= 1) then
        love.keyboard.keysPressed = {}
    end

    gStateMachine:update(dt)
end

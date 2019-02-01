require("src/dependencies")

function love.load()
    love.mouse.setVisible(false)

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
        ["items"] = love.graphics.newImage("assets/graphics/items.png"),
        ["logo"] = love.graphics.newImage("assets/graphics/backgrounds/logo.png")
    }

    gFrames = {
        ["ships"] = getFramesFromJson("assets/graphics/ships.json"),
        ["bullets"] = getFramesFromJson("assets/graphics/bullets.json"),
        ["huds"] = getFramesFromJson("assets/graphics/huds.json"),
        ["items"] = getFramesFromJson("assets/graphics/items.json")
    }

    gFrameQuads = {
        ["ships"] = generateQuads(gTextures.ships, gFrames.ships),
        ["bullets"] = generateQuads(gTextures.bullets, gFrames.bullets),
        ["huds"] = generateQuads(gTextures.huds, gFrames.huds),
        ["items"] = generateQuads(gTextures.items, gFrames.items)
    }

    gSounds = {
        ["theme"] = love.audio.newSource("assets/sounds/theme.ogg", "stream"),
        ["shoot"] = love.audio.newSource("assets/sounds/shoot.wav", "static"),
        ["power-up"] = love.audio.newSource("assets/sounds/power-up.wav", "static")
    }

    gStateMachine = StateMachine{
        ["menu"] = function() return MenuState() end,
        ["play"] = function() return PlayState() end,
        ["gameover"] = function() return GameOverState() end,
        ["editor"] = function() return LevelEditor() end
    }
    gStateMachine:change("menu")

    gGamePaused = false
end

function love.draw()
    gStateMachine:render()
    displaySystemUsage()
end

function love.update(dt)
    require("lib/lovebird").update()

    if (dt < 1) and not gGamePaused then
        gStateMachine:update(dt)  
    end

    if (love.keyboard.wasPressed("p")) then
        gGamePaused = not gGamePaused
    end

    love.keyboard.keysPressed = {}
end

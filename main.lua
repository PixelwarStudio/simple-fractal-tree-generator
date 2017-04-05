-- modules
local Class = require('lib.middleclass')
local Suit = require('lib.suit')

-- source
local Node, Fractal = require('fractal')()

-- gui theme
Suit.theme.cornerRadius = 0
Suit.theme.color = {
    normal  = {bg = {218, 40, 40}, fg = {0, 0, 0}},
    hovered = {bg = {218, 22, 22}, fg = {0, 0, 0}},
    active  = {bg = {218, 6, 6}, fg = {0, 0, 0}}
}

local section = {}
section.options = {
    x = love.graphics.getWidth() / 2 - 125,
    y = (love.graphics.getHeight() - 6*40) / 2, 
    width = 250,
    cellHeight = 40,
    active = false
}
section.actions = {
    x = (love.graphics.getWidth() - 2 * 40) / 2,
    y = 0,
    width = 40
}
section.fractal = {
    x = 0,
    y = 0,
    width = love.graphics.getWidth(),
    height = love.graphics.getHeight()
}

-- input widgets
local input = {}
input.length = {text = '150'}
input.scale = {text = '0.5'}
input.angle = {text = '60'}
input.step = {text = '1'}
input.branches = {text = '2'}

-- default fractal
local fractal = Fractal(section.fractal.x + section.fractal.width / 2, love.graphics.getHeight(), 150, 0.5, math.rad(60), 2)

local image = {}
function love.load()
    image.next = love.graphics.newImage('img/next.png')
    image.nextHovered = love.graphics.newImage('img/next-hovered.png')
    image.new = love.graphics.newImage('img/new.png')
    image.newHovered = love.graphics.newImage('img/new-hovered.png')
end

function love.update(dt)
    Timer.update(dt)

    -- the gui layout
    -- Controlbar
    Suit.layout:reset(section.actions.x, section.actions.y)
    -- Button for creating new Fractal
    if Suit.ImageButton(image.new, {hovered = image.newHovered}, Suit.layout:col(section.actions.width, 40)).hit then
        section.options.active = not(section.options.active )
    end
    if Suit.ImageButton(image.next, {hovered = image.nextHovered}, Suit.layout:col()).hit then
        fractal:iterate()
    end
    
    -- panel: new fractal
    if  section.options.active then
        Suit.layout:reset(section.options.x, section.options.y)

        Suit.Label('New Fractal', Suit.layout:row(section.options.width, section.options.cellHeight))
        -- input for start length
        Suit.layout:push(Suit.layout:row())
            Suit.Label('Length', {align = 'left'}, Suit.layout:col(section.options.width * 0.6, 40))
            Suit.Input(input.length, Suit.layout:col(section.options.width * 0.4))
        Suit.layout:pop()

        -- input for scale
        Suit.layout:push(Suit.layout:row())
            Suit.Label('Scale', {align = 'left'}, Suit.layout:col(section.options.width * 0.6, 40))
            Suit.Input(input.scale, Suit.layout:col(section.options.width * 0.4))
        Suit.layout:pop()

        -- input for angle
        Suit.layout:push(Suit.layout:row())
            Suit.Label('Angle', {align = 'left'}, Suit.layout:col(section.options.width * 0.6, 40))
            Suit.Input(input.angle, Suit.layout:col(section.options.width * 0.4))
        Suit.layout:pop()

        -- input for branches
        Suit.layout:push(Suit.layout:row())
            Suit.Label('Branches per Iteration', {align = 'left'}, Suit.layout:col(section.options.width * 0.6, 40))
            Suit.Input(input.branches, Suit.layout:col(section.options.width * 0.4))
        Suit.layout:pop()

        -- button, which creates a new fractal with given scale and angle
        if Suit.Button('Create', Suit.layout:row()).hit then
            fractal = Fractal(section.fractal.x + section.fractal.width / 2, love.graphics.getHeight(), input.length.text, input.scale.text, math.rad(input.angle.text), input.branches.text)
            section.options.active = false
        end

        _, section.options.height = Suit.layout:nextRow()
    end
end

function love.draw()
    love.graphics.setBackgroundColor({231, 231, 231})
    fractal:draw()
    if section.options.active  then
        love.graphics.setColor(200, 200, 200)
        love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    end
    Suit.draw()
end

function love.resize(width, height)
    -- move fractal
    section.fractal.width = width
    section.fractal.height = height
    fractal:move(width / 2, height - fractal.pos.y)

    -- move controllbar
end

function love.textinput(t)
    Suit.textinput(t)
end

function love.keypressed(key)
    Suit.keypressed(key)
end


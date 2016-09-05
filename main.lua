-- modules
local Class = require('lib.middleclass')
local Vector = require('lib.vector')
local Timer = require('lib.timer')
local Suit = require('lib.suit')

-- source
local Node, Fractal = require('fractal')()

-- settings
Setting = {}
Setting.animation = {}
Setting.animation.duration = 0.5
Setting.animation.enabled = false

-- modified gui theme
Suit.theme.cornerRadius = 0

local section = {}
section.options = {
    x = 0,
    y = 0, 
    width = 125
}
section.info = {
    x = love.graphics.getWidth() - 125,
    y = 0,
    width = 125
}
section.fractal = {
    x = section.options.x + section.options.width,
    y = 0, 
    width = love.graphics.getWidth() - section.info.width - section.options.width
}

-- input widgets
local input = {}
input.length = {text = '150'}
input.scale = {text = '0.6'}
input.angle = {text = '60'}
input.step = {text = '1'}
input.duration = {text = tostring(Setting.animation.duration)}

-- checkbox widget
local checkbox = {}
checkbox.animation = {text = 'Enabled', checked = Setting.animation.enabled}

-- default fractal
local fractal = Fractal(section.fractal.x + section.fractal.width / 2, love.graphics.getHeight(), 150, 0.6, math.rad(60))

function love.update(dt)
    Timer.update(dt)

    -- the gui layout
    -- options section
    Suit.layout:reset(section.options.x, section.options.y)

    -- Panel: fractal settings
    Suit.Label('Settings', Suit.layout:row(section.options.width, 40))

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

    -- button, which creates a new fractal with given scale and angle
    if Suit.Button('Apply', {id = 1}, Suit.layout:row()).hit then
        fractal = Fractal(section.fractal.x + section.fractal.width / 2, love.graphics.getHeight(), input.length.text, input.scale.text, math.rad(input.angle.text))
    end

    -- Panel: actions
    Suit.Label('Actions', Suit.layout:row())

    -- input for iterating steps
    Suit.layout:push(Suit.layout:row())
        Suit.Label('Steps', {align = 'left'}, Suit.layout:col(section.options.width * 0.6, 40))
        Suit.Input(input.step, Suit.layout:col(section.options.width * 0.4))
    Suit.layout:pop()

    -- button, which iterates the fractal with the given steps
    if Suit.Button('Iterate', Suit.layout:row()).hit then
        if Setting.animation.enabled then
            Timer.every(Setting.animation.duration, function() fractal:iterate() end, tonumber(input.step.text))
        else
            for i = 1, tonumber(input.step.text) do fractal:iterate() end
        end
    end

    -- Panel: animation settings
    Suit.Label('Animation', Suit.layout:row())

    -- checkbox, which enables or disable animations
    Suit.Checkbox(checkbox.animation, Suit.layout:row())

    -- input for animation duration (if enabled)
    Suit.layout:push(Suit.layout:row())
        Suit.Label('Duration', {align = 'left'}, Suit.layout:col(section.options.width * 0.6, 40))
        Suit.Input(input.duration, Suit.layout:col(section.options.width * 0.4))
    Suit.layout:pop()

    -- button, which applies duation and animation enabling to (node-)settings
    if Suit.Button('Apply', {id = 2}, Suit.layout:row()).hit then
        Setting.animation.duration = tonumber(input.duration.text)
        Node.animation.duration = tonumber(input.duration.text)
        Setting.animation.enabled = checkbox.animation.checked
        Node.animation.enabled = Setting.animation.enabled
    end

    -- information section
    Suit.layout:reset(section.info.x, section.info.y)
    Suit.Label('Informations', Suit.layout:row(section.info.width, 40))
    Suit.Label(string.format('Iteration: %s', fractal.iter), {align = 'left'}, Suit.layout:row())
    Suit.Label(string.format('Nodes: %s', fractal:calcNodes()), {align = 'left'}, Suit.layout:row())
end

function love.draw()
    fractal:draw()
    Suit.draw()
end

function love.textinput(t)
    Suit.textinput(t)
end

function love.keypressed(key)
    Suit.keypressed(key)
end


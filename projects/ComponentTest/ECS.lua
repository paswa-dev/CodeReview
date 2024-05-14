-- Component
type System = (world) -> ()
type SystemInfo = System | {
    
}

local component = {}

function component.new()

end

local loop = {}

function loop.new(world)
    local self = {}
    self._world = world
    self._systems = {}
    return setmetatable(self, {
        __index = loop
    })
end

function loop:scheduleSystem(sys: SystemInfo)
    table.insert()
end

function loop:scheduleSystems()

end

function loop:removeSystem()

end

function loop:replaceSystem()

end

local world = {}

function world.new()

end

return {
    Loop = loop
    World = world,
    Component = component,
}
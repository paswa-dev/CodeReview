-- Component
type SystemTable = {
    system: (world: any) -> (),
    priority: number?,
    loop: string?,
}

type System = SystemTable | (world: any) -> ()

type LoopInitializer = {
    default: RBXScriptSignal,
    [string]: RBXScriptSignal
}

local nullPtr = newproxy(false)

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

function loop:_seperateSystemsByEvent(event_list)
    local systems = {}
    for _, system in next, self._systems do
        local event = system["loop"] or "default"
        if event_list[event] then
            if systems[event] == nil then
                systems[event] = {}
            end
            table.insert(systems[event], system["system"] or system)
        end
    end
    return systems
end

function loop:begin(initalizer: LoopInitializer)
    local systems = self:_seperateSystemsByEvent(initalizer)
    for event_name, event_list in next, systems do
        initalizer[event_name]:Connect(function()
            for _, event in next, event_list do
                event(self._world)
            end
        end)
    end
end

function loop:scheduleSystem(system: System)
    table.insert(self._systems, system)
end

function loop:scheduleSystems(systems: {System})
    for _, system in next, systems do
        table.insert(self._systems, system)
    end
end

function loop:removeSystem(system)
    table.remove(self._systems, table.find(system))
end

function loop:replaceSystem(oldSystem, newSystem)
    local index = table.find(self._systems, oldSystem)
    if index then
        self._systems[index] = newSystem
    end
end

local world = {}
-- Completely Isolate iterator function. Refining the search is fine, 
-- but not creating an entire new table

function world.new()
    local self = {
        entities = {},
        componentToEntity = {},
        nextId = 0,
        idDeinstancedCache = {} -- Retains unused entites for recyling
    }

    return setmetatable(self, {__index = world})
end

function world:_recycleNextId()
    if #idDeinstancedCache == 0 then
        self.nextId += 1
        return self.nextId
    end
    local recycleId = idDeinstancedCache[1]
    task.spawn(table.remove, 1)
    return recycleId
end

function world:query(...)
    local 
end

function world:spawn()

end

return {
    Loop = loop
    World = world,
    Component = component,
}
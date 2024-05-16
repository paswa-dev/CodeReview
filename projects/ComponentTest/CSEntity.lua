--// Collection Service Entity System
local CS = game:GetService("CollectionService")
local loop = {}

local function component(tag_name: string)
    local self = {}
    tag_string = tag_name
    data_table = {}

    function self.assign(key, value)
        data_table[key] = value
    end

    function self.build(object)
        local folder = Instance.new("Folder")
        folder.Name = tag_string

        for key, value in next, data_table do
            folder:SetAttribute(key, value)
        end

        folder.Parent = object
    end
    return self
end


local world = {
    id_number = 0,
    trackedEntity_table = {} -- ID -> INSTANCE
    trackedInstance_table = {} -- INSTANCE -> ID
}
--// Open/Closed Principle
-- All functions must do only one thing. 
-- If another piece of functionality exist, extend to another function.

local function containsResults(t, ...)
    for i=1, select("#", ...) do
        local selected = select(i, ...)
        if not table.find(t, selected) then
            return false
        end
    end
    return true
end

local function findOverlappingResults(...) -- Unoptimized probably?
    local objects = select("#", ...)
    local results = {}
    for i=1, objects do
        local choice_table = select(i, ...)
        for _, object in next, choice_table do
            if containsResults(CS:GetTags(object), ...) then
                table.insert(results, object)
            end
        end
    end
    return results
end

local function buildComponents(object, ComponentBuilder_list)
    for _, ComponentBuilder in next, ComponentBuilder_list do
        ComponentBuilder.build(object)
    end
end

local function hookDestructor(object, callback)
    return object.Destroying:Connect(callback)
end

function world.instanceExist(instance)
    return trackedInstance_table[instance] ~= nil
end

function world.entityExist(id)
    return trackedEntity_table[id] ~= nil
end

function world.incrementId()
    id_number += 1
    return id_number
end

function world.findInstance(id)
    return world.trackedEntity_table[id]
end

function world.findEntity(instance)
    return world.trackedInstance_table[instance]
end

function world.getEntityData(id)
    return world.trackedEntity_table[id]
end

function world.wipe(instance)
    local id = world.trackedEntity_table[instance]
    world.trackedEntity_table[id] = nil
    world.trackedEntity_table[instance] = nil
end

function world.spawn(instance, ComponentBuilder_list: {any})
    local id = world.incrementId()
    if world.instanceExist(instance) == false then
        world.trackedInstance_table[instance] = id
        world.trackedEntity_table[id] = instance
        buildComponents(instance, ComponentBuilder_list)
        hookDestructor()
    end
end

return {
    World = world,
    Loop = loop
}
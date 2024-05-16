--// Collection Service Entity System
local CS = game:GetService("CollectionService")
local loop = {}
local world = {
    id_number = 0,
    entity_table = {} -- ID -> INSTANCE
    trackedInstanceEntity_table = {} -- INSTANCE -> ID
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

function world.instanceExist(instance)
    return trackedInstanceEntity_table[instance] ~= nil
end

function world.entityExist(id)
    return entity_table[id] ~= nil
end

function world.incrementId()
    id_number += 1
    return id_number
end

function world.findInstance(id)
    return world.entity_table[id]
end

function world.findEntity(instance)
    return world.trackedInstanceEntity_table[instance]
end

function world.getEntityData(id)
    return world.entity_table[id]
end

function world.spawnAt(id, instance, kwargs)
    world.entity_table[id] = {kwargs}
    world.trackedInstanceEntity_table[instance]
end

function world.spawn(instance, kwargs)
    if world.entityExist[instance] then return end
    local id = world.incrementId()
    world.spawnAt(id, instance, kwargs)
end

function world.query(...)
    for i=0, select("#", ...) do
        local instances = CS:GetTagged(select(i, ...))
        findOverlappingResults(instances, ...)
    end
end

return {
    world = world,
    loop = loop
}
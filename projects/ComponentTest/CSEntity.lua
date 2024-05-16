--// Collection Service Entity System
local CollectionService = game:GetService("CollectionService")
local loop = {}
local world = {
    id_number = 0,
    entity_table = {} -- ID -> DATA {}
    trackedInstanceEntity_table = {} -- INSTANCE -> ID
}
--// Open/Closed Principle
-- All functions must do only one thing. 
-- If another piece of functionality exist, extend to another function.

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

function world.query()

end

return {
    world = world,
    loop = loop
}
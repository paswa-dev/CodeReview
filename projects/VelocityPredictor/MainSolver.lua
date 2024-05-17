local solverQuad = require "QuadraticSolver"

return function(p1: Vector3, p2: Vector3, s1: Vector3, v2: Vector3)
    local dC = (p2-p1).Magnitude
    local s2 = v2.Magnitude
    local r = s2/s1
    local theta = v2:Dot(p2-p1)
    
    local qA = math.pow(r, 2)
    local qB = 2 * dC * math.cos(theta)
    local qC = -(math.pow(dC, 2))

    local t
    local t0, t1 = solverQuad(qA, qB, qC)
    if t0 and t1 then
        t = math.max(t0, t1)
    if t0 then
        t = t0
    else
        return false
    end

    local p3 = p2 + (v2 * t)
    local direction = (p3-p1)

    return direction
end
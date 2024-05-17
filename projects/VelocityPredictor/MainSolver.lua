return function(p1: Vector3, p2: Vector3, s1: Vector3, v2: Vector3)
    local dC = (p2-p1).Magnitude
    local s2 = v2.Magnitude
    local r = s2/s1
    local theta = v2:Dot(p2-p1)
    
    local qA = math.pow(r, 2)
    local qB = 2 * dC * math.cos(theta)
    local qC = -(math.pow(dC, 2))
    
end
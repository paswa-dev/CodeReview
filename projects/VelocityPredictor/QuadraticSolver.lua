return function solveQuadric(a, b, c)
	local discrim = math.pow(b, 2) - (2 * a * c)
    local neg_b = -b
    local doubleA = (2 * a)
    if discrim > 0 then
        return (neg_b + discrim) / doubleA, (neg_b - discrim) / doubleA
    elseif discrim < 0 then
        return false;
    elseif discrim == 0 then
        return neg_b / doubleA
    end
end
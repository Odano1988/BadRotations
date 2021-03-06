function getDistance(Unit1,Unit2,option)
    local currentDist = 100
    -- If Unit2 is nil we compare player to Unit1
    if Unit2 == nil then
        Unit2 = Unit1
        Unit1 = "player"
    end
    -- Modifier for Balance Affinity range change
    if rangeMod == nil then rangeMod = 0 end
    if br.player ~= nil then
        if br.player.talent.balanceAffinity ~= nil then
            if br.player.talent.balanceAffinity then
                rangeMod = 5
            else
                rangeMod = 0
            end
        end
    end
    -- Check if objects exists and are visible
    if GetObjectExists(Unit1) and GetUnitIsVisible(Unit1) == true
        and GetObjectExists(Unit2) and GetUnitIsVisible(Unit2) == true
    then
    -- Get the distance
        local X1,Y1,Z1 = GetObjectPosition(Unit1)
        local X2,Y2,Z2 = GetObjectPosition(Unit2)
        local TargetCombatReach = UnitCombatReach(Unit2)
        local PlayerCombatReach = UnitCombatReach(Unit1)
        local MeleeCombatReachConstant = 4/3
        if isMoving(Unit1) and isMoving(Unit2) then
            IfSourceAndTargetAreRunning = 8/3
        else
            IfSourceAndTargetAreRunning = 0
        end
        local dist = math.sqrt(((X2-X1)^2) + ((Y2-Y1)^2) + ((Z2-Z1)^2)) - (PlayerCombatReach + TargetCombatReach) - rangeMod
        local dist2 = dist + 0.03 * ((13 - dist) / 0.13)
        local dist3 = dist + 0.05 * ((8 - dist) / 0.15) + 1
        local dist4 = dist + (PlayerCombatReach + TargetCombatReach)
        local meleeRange = max(5, PlayerCombatReach + TargetCombatReach + MeleeCombatReachConstant + IfSourceAndTargetAreRunning)
        if option == "dist" then return dist end
        if option == "dist2" then return dist2 end
        if option == "dist3" then return dist3 end
        if option == "dist4" then return dist4 end
        if GetSpecializationInfo(GetSpecialization()) == 255 then
        	if dist > meleeRange then
        		currentDist = dist
        	else
        		currentDist = 0
        	end
        elseif dist > 13 then
            currentDist = dist
        elseif dist2 > 8 and dist3 > 8 then
            currentDist = dist2
        elseif dist3 > 5 and dist4 > 5 then
            currentDist = dist3
        elseif dist4 > meleeRange then -- Thanks Ssateneth
            currentDist = dist4
        else
            currentDist = 0
        end
    end
    return currentDist
end
function isInRange(spellID,unit)
	return LibStub("SpellRange-1.0").IsSpellInRange(spellID,unit)
end
function getDistanceToObject(Unit1,X2,Y2,Z2)
	if Unit1 == nil then
		Unit1 = "player"
	end
	if GetObjectExists(Unit1) and GetUnitIsVisible(Unit1) then
		local X1,Y1,Z1 = GetObjectPosition(Unit1)
		return math.sqrt(((X2-X1)^2) + ((Y2-Y1)^2) + ((Z2-Z1)^2))
	else
		return 100
	end
end
function inRange(spellID,unit)
	local SpellRange = LibStub("SpellRange-1.0")
	local inRange = SpellRange.IsSpellInRange(spellID,unit)
	if inRange == 1 then
		return true
	else
		return false
	end
end
function getFacingDistance()
    if GetUnitIsVisible("player") and GetUnitIsVisible("target") then
        --local targetDistance = getRealDistance("target")
        local targetDistance = getDistance("target")
        local Y1,X1,Z1 = GetObjectPosition("player");
        local Y2,X2,Z2 = GetObjectPosition("target");
        local Angle1 = GetObjectFacing("player")
        local deltaY = Y2 - Y1
        local deltaX = X2 - X1
        Angle1 = math.deg(math.abs(Angle1-math.pi*2))
        if deltaX > 0 then
            Angle2 = math.deg(math.atan(deltaY/deltaX)+(math.pi/2)+math.pi)
        elseif deltaX <0 then
            Angle2 = math.deg(math.atan(deltaY/deltaX)+(math.pi/2))
        end
        local Dist = round2(math.tan(math.abs(Angle2 - Angle1)*math.pi/180)*targetDistance*10000)/10000
        if ObjectIsFacing("player","target") then
            return Dist
        else
            return -(math.abs(Dist))
        end
    else
        return 1000
    end
end
-- /dump getTotemDistance("target")
function getTotemDistance(Unit1)
  if Unit1 == nil then
    Unit1 = "player"
  end

  if GetUnitIsVisible(Unit1) then
    -- local objectCount = GetObjectCount() or 0
    for i = 1, ObjectCount() do
      if UnitIsUnit(UnitCreator(ObjectWithIndex(i)), "Player") and (UnitName(ObjectWithIndex(i)) == "Searing Totem" or UnitName(ObjectWithIndex(i)) == "Magma Totem") then
        X2,Y2,Z2 = GetObjectPosition(GetObjectIndex(i))
      end
    end
    local X1,Y1,Z1 = GetObjectPosition(Unit1)
    TotemDistance = math.sqrt(((X2-X1)^2)+((Y2-Y1)^2)+((Z2-Z1)^2))
    --Print(TotemDistance)
    return TotemDistance
  else
    return 0
  end
end
-- if isInMelee() then
function isInMelee(Unit)
  if Unit == nil then
    Unit = "target"
  end
  if getDistance(Unit) < 4 then
    return true
  else
    return false
  end
end

function inRange(spellID,unit)
    local spellName = GetSpellInfo(spellID)
    if unit == nil then unit = "target" end
    local inRange = IsSpellInRange(spellName,unit)
    if inRange ~= nil then
        return IsSpellInRange(spellName,unit) == 1
    else
        return false
    end
end
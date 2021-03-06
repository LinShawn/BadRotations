if select(2, UnitClass("player")) == "MAGE" then
	local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
	local function createToggles()
    -- Rotation Button
        RotationModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.flamestrike},
            [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.flamestrike},
            [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.pyroblast},
            [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.iceBlock}
        };
        CreateButton("Rotation",1,0)
    -- Cooldown Button
        CooldownModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.combustion},
            [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.combustion},
            [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.combustion}
        };
       	CreateButton("Cooldown",2,0)
    -- Defensive Button
        DefensiveModes = {
            [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.iceBarrier},
            [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.iceBarrier}
        };
        CreateButton("Defensive",3,0)
    -- Interrupt Button
        InterruptModes = {
            [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.counterspell},
            [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.counterspell}
        };
        CreateButton("Interrupt",4,0)
    end

---------------
--- OPTIONS ---
---------------
	local function createOptions()
        local optionTable

        local function rotationOptions()
            local section
        -- General Options
            section = br.ui:createSection(br.ui.window.profile, "General")
            -- APL
                br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC","|cffFFFFFFAMR"}, 1, "|cffFFFFFFSet APL Mode to use.")
            -- Dummy DPS Test
                br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Pre-Pull Timer
                br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Artifact 
                br.ui:createDropdownWithout(section,"Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
            br.ui:checkSectionState(section)
        -- Cooldown Options
            section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Racial
                br.ui:createCheckbox(section,"Racial")
            -- Trinkets
                br.ui:createCheckbox(section,"Trinkets")
            -- Mirror Image
                br.ui:createCheckbox(section,"Mirror Image")
            br.ui:checkSectionState(section)
        -- Defensive Options
            section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
                br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Heirloom Neck
                br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Gift of The Naaru
                if br.player.race == "Draenei" then
                    br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                end
            -- Frost Nova
                br.ui:createSpinner(section, "Frost Nva",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            br.ui:checkSectionState(section)
        -- Interrupt Options
            section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Couterspell
                br.ui:createCheckbox(section, "Counterspell")
            -- Interrupt Percentage
                br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
            br.ui:checkSectionState(section)
        -- Toggle Key Options
            section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
            -- Single/Multi Toggle
                br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  4)
            -- Cooldown Key Toggle
                br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
            -- Defensive Key Toggle
                br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
                br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Pause Toggle
                br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle,  6)
            br.ui:checkSectionState(section)
        end
        optionTable = {{
            [1] = "Rotation Options",
            [2] = rotationOptions,
        }}
        return optionTable
    end

----------------
--- ROTATION ---
----------------
	local function runRotation()
        if br.timer:useTimer("debugFire", math.random(0.15,0.3)) then
            --print("Running: "..rotationName)

    ---------------
	--- Toggles ---
	---------------
	        UpdateToggle("Rotation",0.25)
	        UpdateToggle("Cooldown",0.25)
	        UpdateToggle("Defensive",0.25)
	        UpdateToggle("Interrupt",0.25)

	--------------
	--- Locals ---
    --------------
            local addsExist                                     = false 
            local addsIn                                        = 999
            local artifact                                      = br.player.artifact
            local buff                                          = br.player.buff
            local cast                                          = br.player.cast
            local castable                                      = br.player.cast.debug
            local combatTime                                    = getCombatTime()
            local cd                                            = br.player.cd
            local charges                                       = br.player.charges
            local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
            local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or ObjectExists("target"), UnitIsPlayer("target")
            local debuff                                        = br.player.debuff
            local enemies                                       = br.player.enemies
            local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
            local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.agilityBig)
            local friendly                                      = friendly or UnitIsFriend("target", "player")
            local gcd                                           = br.player.gcd
            local hasMouse                                      = ObjectExists("mouseover")
            local hasteAmount                                   = GetHaste()/100
            local healPot                                       = getHealthPot()
            local inCombat                                      = br.player.inCombat
            local inInstance                                    = br.player.instance=="party"
            local inRaid                                        = br.player.instance=="raid"
            local lastSpell                                     = lastSpellCast
            local level                                         = br.player.level
            local lootDelay                                     = getOptionValue("LootDelay")
            local lowestHP                                      = br.friend[1].unit
            local mode                                          = br.player.mode
            local moveIn                                        = 999
            local moving                                        = isMoving("player")
            local perk                                          = br.player.perk        
            local php                                           = br.player.health
            local playerMouse                                   = UnitIsPlayer("mouseover")
            local power, powmax, powgen, powerDeficit           = br.player.power, br.player.powerMax, br.player.powerRegen, br.player.powerDeficit
            local pullTimer                                     = br.DBM:getPulltimer()
            local racial                                        = br.player.getRacial()
            local recharge                                      = br.player.recharge
            local solo                                          = br.player.instance=="none"
            local spell                                         = br.player.spell
            local talent                                        = br.player.talent
            local ttd                                           = getTTD
            local ttm                                           = br.player.timeToMax
            local units                                         = br.player.units
            
	   		if leftCombat == nil then leftCombat = GetTime() end
			if profileStop == nil then profileStop = false end
            if talent.kindling then kindle = 1 else kindle = 0 end
            if not talent.kindling then notKindle = 1 else notKindle = 0 end

	--------------------
	--- Action Lists ---
	--------------------
		-- Action List - Extras
			local function actionList_Extras()
			-- Dummy Test
				if isChecked("DPS Testing") then
					if ObjectExists("target") then
						if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
							StopAttack()
							ClearTarget()
							print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
							profileStop = true
						end
					end
				end -- End Dummy Test

			end -- End Action List - Extras
		-- Action List - Defensive
			local function actionList_Defensive()
				if useDefensive() then
			-- Pot/Stoned
                    if isChecked("Pot/Stoned") and php <= getOptionValue("Pot/Stoned") 
                        and inCombat and (hasHealthPot() or hasItem(5512)) 
                    then
                        if canUse(5512) then
                            useItem(5512)
                        elseif canUse(healPot) then
                            useItem(healPot)
                        end
                    end
            -- Heirloom Neck
                    if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
                        if hasEquiped(122668) then
                            if GetItemCooldown(122668)==0 then
                                useItem(122668)
                            end
                        end
                    end
            -- Gift of the Naaru
                    if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and br.player.race == "Draenei" then
                        if castSpell("player",racial,false,false,false) then return end
                    end
            -- Frost Nova
                    if isChecked("Frost Nova") and php <= getOptionValue("Frost Nova") and #enemies.yards12 > 0 then
                        if cast.frostNova() then return end
                    end
	    		end -- End Defensive Toggle
			end -- End Action List - Defensive
		-- Action List - Interrupts
			local function actionList_Interrupts()
				if useInterrupts() then
                    for i=1, #enemies.yards30 do
                        thisUnit = enemies.yards30[i]
                        if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
            -- Counterspell
                            if isChecked("Counterspell") then
                                if cast.counterspell(thisUnit) then return end
                            end
                        end
                    end
                end -- End useInterrupts check
			end -- End Action List - Interrupts
		-- Action List - Cooldowns
			local function actionList_Cooldowns()
				if useCDs() and getDistance(units.dyn40) < 40 then
            -- Potion
                    -- potion,name=deadly_grace
                    -- TODO
            -- Trinkets
                    -- use_item,slot=trinket2,if=buff.chaos_blades.up|!talent.chaos_blades.enabled 
                    if isChecked("Trinkets") then
                        -- if buff.chaosBlades or not talent.chaosBlades then 
                            if canUse(13) then
                                useItem(13)
                            end
                            if canUse(14) then
                                useItem(14)
                            end
                        -- end
                    end
            -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                    -- blood_fury | berserking | arcane_torrent
                    if isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "Blood Elf") then
                        if castSpell("player",racial,false,false,false) then return end
                    end
                end -- End useCDs check
            end -- End Action List - Cooldowns
        -- Action List - PreCombat
            local function actionList_PreCombat()
                if not inCombat and not (IsFlying() or IsMounted()) then
                    if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then

                    end -- End Pre-Pull
                    if isValidUnit("target") and getDistance("target") < 40 then
                -- Mirror Image
                        if isChecked("Mirror Image") then
                            if cast.mirrorImage() then return end
                        end
                -- Pyroblast
                        if br.timer:useTimer("delayPyro", getCastTime(spell.pyroblast)+0.5) then
                            if cast.pyroblast("target") then return end
                        end
                    end
                end -- End No Combat
            end -- End Action List - PreCombat
        -- Action List - Active Talents
            local function actionList_ActiveTalents()
            -- Flame On
                -- flame_on,if=action.fire_blast.charges=0&(cooldown.combustion.remains>40+(talent.kindling.enabled*25)|target.time_to_die.remains<cooldown.combustion.remains)
                if charges.fireBlast == 0 and (cd.combustion > 40 + (kindle * 25) or (ttd("target") < cd.combustion) or (isDummy("target") and cd.combustion > 45)) then
                    if cast.flameOn() then return end
                end
            -- Blast Wave
                -- blast_wave,if=(buff.combustion.down)|(buff.combustion.up&action.fire_blast.charges<1&action.phoenixs_flames.charges<1)
                if (not buff.combustion) or (buff.combustion and charges.fireBlast < 1 and charges.phoenixsFlames < 1) then
                    if cast.blastWave() then return end
                end
            -- Meteor
                -- meteor,if=cooldown.combustion.remains>30|(cooldown.combustion.remains>target.time_to_die)|buff.rune_of_power.up
                if cd.combustion > 30 or (cd.combustion > ttd("target")) or buff.runeOfPower then
                    if cast.meteor() then return end
                end
            -- Cinderstorm
                -- cinderstorm,if=cooldown.combustion.remains<cast_time&(buff.rune_of_power.up|!talent.rune_on_power.enabled)|cooldown.combustion.remains>10*spell_haste&!buff.combustion.up
                if cd.combustion < getCastTime(spell.cinderstorm) and (buff.runeOfPower or not talent.runeOfPower) or cd.combustion > 10 * hasteAmount and not buff.combustion then
                    if cast.cinderstorm() then return end
                end
            -- Dragon's Breath
                -- dragons_breath,if=equipped.132863
                if hasEquiped(132863) then
                    if cast.dragonsBreath() then return end
                end
            -- Living Bomb
                -- living_bomb,if=active_enemies>1&buff.combustion.down
                if ((#enemies.yards10 > 1 and mode.rotation == 1) or mode.rotation == 2) and not buff.combustion then
                    if cast.livingBomb("target") then return end
                end
            end -- End Active Talents Action List
        -- Action List - Combustion Phase
            local function actionList_CombustionPhase()
            -- Rune of Power
                -- rune_of_power,if=buff.combustion.down
                if not buff.combustion then 
                    if cast.runeOfPower() then return end
                end
            -- Call Action List - Active Talents
                -- call_action_list,name=active_talents
                if actionList_ActiveTalents() then return end
            -- Combustion
                -- combustion
                if cast.combustion() then return end
            -- Call Action List - Cooldowns
                if actionList_Cooldowns() then return end
            -- Pyroblast
                -- pyroblast,if=buff.hot_streak.up
                if buff.hotStreak then
                    if cast.pyroblast() then return end
                end
            -- Fire Blast
                -- fire_blast,if=buff.heating_up.up
                if buff.heatingUp then
                    if cast.fireBlast() then return end
                end
            -- Phoenix's Flames
                -- phoenixs_flames
                if buff.heatingUp then
                    if cast.phoenixsFlames() then return end
                end
            -- Scorch
                -- scorch,if=buff.combustion.remains>cast_time
                -- scorch,if=target.health.pct<=25&equipped.132454
                if buff.heatingUp and (buff.remain.combustion > getCastTime(spell.scorch) or (getHP("target") <= 25 and hasEquiped(132454))) then
                    if cast.scorch() then return end
                end
            end -- End Combustion Phase Action List
        -- Action List - ROP Phase
            local function actionList_ROPPhase()
            -- Rune of Power
                -- rune_of_power
                if cast.runeOfPower() then return end
            -- Pyroblast
                -- pyroblast,if=buff.hot_streak.up
                if buff.hotStreak then
                    if cast.pyroblast() then return end
                end
            -- Call Action List - Active Talents
                -- call_action_list,name=active_talents
                if actionList_ActiveTalents() then return end
            -- Pyroblast
                -- pyroblast,if=buff.kaelthas_ultimate_ability.react
                if buff.kaelthasUltimateAbility then
                    if cast.pyroblast() then return end
                end
            -- Fire Blast
                -- fire_blast,if=!prev_off_gcd.fire_blast
                if lastSpell ~= spell.fireBlast then
                    if cast.fireBlast() then return end
                end
            -- Phoenix's Flames
                -- phoenixs_flames,if=!prev_gcd.phoenixs_flames
                if lastSpell ~= spell.phoenixsFlames then
                    if cast.phoenixsFlames() then return end
                end
            -- Scorch
                -- scorch,if=target.health.pct<=25&equipped.132454
                if getHP("target") <= 25 and hasEquiped(132454) then
                    if cast.scorch() then return end
                end
            -- Fireball
                -- fireball
                if cast.fireball() then return end
            end -- End ROP Phase Action List
        -- Action List - Single Target
            local function actionList_Single()
            -- Pyroblast
                -- pyroblast,if=buff.hot_streak.up&buff.hot_streak.remains<action.fireball.execute_time
                if buff.hotStreak and buff.remain.hotStreak < getCastTime(spell.fireball) then
                    if cast.pyroblast() then return end
                end
            -- Phoenix's Flames
                -- /phoenixs_flames,if=charges_fractional>2.7&active_enemies>2
                if charges.frac.phoenixsFlames > 2.7 and ((#enemies.yards10 > 2 and mode.roation == 1) or mode.roation == 2) then
                    if cast.phoenixsFlames() then return end
                end
            -- Flamestrike
                -- flamestrike,if=talent.flame_patch.enabled&active_enemies>2&buff.hot_streak.react
                if ((#enemies.yards10 > 2 and mode.roation == 1) or mode.roation == 2) and buff.hotStreak then
                    if cast.flamestrike() then return end
                end
            -- Pyroblast
                -- pyroblast,if=buff.hot_streak.up&!prev_gcd.pyroblast
                -- pyroblast,if=buff.hot_streak.react&target.health.pct<=25&equipped.132454
                -- pyroblast,if=buff.kaelthas_ultimate_ability.react
                if (buff.hotStreak and lastSpell ~= spell.pyroblast)
                    or (buff.hotStreak and getHP("target") <= 25 and hasEquiped(132454))
                    or buff.kaelthasUltimateAbility 
                then
                    if cast.pyroblast() then return end
                end
            -- Call Action List - Active Talents
                -- call_action_list,name=active_talents
                if actionList_ActiveTalents() then return end
            -- Fire Blast
                -- fire_blast,if=!talent.kindling.enabled&buff.heating_up.up&(!talent.rune_of_power.enabled|charges_fractional>1.4|cooldown.combustion.remains<40)&(3-charges_fractional)*(12*spell_haste)<cooldown.combustion.remains+3|target.time_to_die.remains<4
                -- fire_blast,if=talent.kindling.enabled&buff.heating_up.up&(!talent.rune_of_power.enabled|charges_fractional>1.5|cooldown.combustion.remains<40)&(3-charges_fractional)*(18*spell_haste)<cooldown.combustion.remains+3|target.time_to_die.remains<4
                if (not talent.kindling and buff.heatingUp and (not talent.runeOfPower or charges.frac.fireBlast > 1.4 or cd.combustion < 40) and (3 - charges.frac.fireBlast) * (12 * hasteAmount) < cd.combustion + 3 or ttd("target") < 4)
                    or (talent.kindling and buff.heatingUp and (not talent.runeOfPower or charges.frac.fireBlast > 1.5 or cd.combustion < 40) and (3 - charges.frac.fireBlast) * (18 * hasteAmount) < cd.combustion + 3 or ttd("target") < 4)
                then
                    if cast.fireBlast() then return end
                end
            -- Phoenix's Flames
                -- phoenixs_flames,if=(buff.combustion.up|buff.rune_of_power.up|buff.incanters_flow.stack>3|talent.mirror_image.enabled)&artifact.phoenix_reborn.enabled&(4-charges_fractional)*13<cooldown.combustion.remains+5|target.time_to_die.remains<10
                -- phoenixs_flames,if=(buff.combustion.up|buff.rune_of_power.up)&(4-charges_fractional)*30<cooldown.combustion.remains+5
                if (((buff.combustion or buff.runeOfPower or buff.stack.incantersFlow > 3 or talent.mirrorImage) and artifact.phoenixReborn and (4 - charges.frac.phoenixsFlames) * 13 < cd.combustion + 5 or ttd("target") < 10) 
                    or ((buff.combustion or buff.runeOfPower) and (4 - charges.frac.phoenixsFlames) * 30 < cd.combustion + 5))
                then
                    if cast.phoenixsFlames() then return end
                end
            -- Scorch
                -- scorch,if=target.health.pct<=25&equipped.132454
                if getHP("target") <= 25 and hasEquiped(132454) then
                    if cast.scorch() then return end
                end
            -- Fireball
                -- fireball
                if cast.fireball() then return end
            end  -- End Single Target Action List
    ---------------------
    --- Begin Profile ---
    ---------------------
        -- Profile Stop | Pause
            if not inCombat and not hastar and profileStop==true then
                profileStop = false
            elseif (inCombat and profileStop==true) or pause() or mode.rotation==4 then
                if buff.heatingUp then
                    if cast.fireBlast() then return end
                end
                return true
            else
    -----------------------
    --- Extras Rotation ---
    -----------------------
                if actionList_Extras() then return end
    --------------------------
    --- Defensive Rotation ---
    --------------------------
                if actionList_Defensive() then return end
    ------------------------------
    --- Out of Combat Rotation ---
    ------------------------------
                if actionList_PreCombat() then return end
    --------------------------
    --- In Combat Rotation ---
    --------------------------
                if inCombat and profileStop==false and isValidUnit(units.dyn40) and getDistance(units.dyn40) < 40 then
        ------------------------------
        --- In Combat - Interrupts ---
        ------------------------------
                    if actionList_Interrupts() then return end
        ---------------------------
        --- SimulationCraft APL ---
        ---------------------------
                    if getOptionValue("APL Mode") == 1 then
            -- Mirror Image
                        -- mirror_image,if=buff.combustion.down
                        if isChecked("Mirror Image") and not buff.combustion then
                            if cast.mirrorImage() then return end
                        end
            -- Rune of Power
                        -- rune_of_power,if=cooldown.combustion.remains>40&buff.combustion.down&(cooldown.flame_on.remains<5|cooldown.flame_on.remains>30)&!talent.kindling.enabled|target.time_to_die.remains<11|talent.kindling.enabled&(charges_fractional>1.8|time<40)&cooldown.combustion.remains>40
                        if cd.combustion > 40 and not buff.combustion and (cd.flameOn < 5 or cd.flameOn > 30) and (not talent.kindling or ttd("target") < 11 or (talent.kindling and (charges.frac.fireBlast > 1.8 or combatTime < 40) and cd.combustion > 40)) then
                            if cast.runeOfPower() then return end
                        end
            -- Action List - Combustion Phase
                        -- call_action_list,name=combustion_phase,if=cooldown.combustion.remains<=action.rune_of_power.cast_time+(!talent.kindling.enabled*gcd)|buff.combustion.up
                        if cd.combustion < getCastTime(spell.runeOfPower) + (notKindle * gcd) or buff.combustion then
                            if actionList_CombustionPhase() then return end
                        end
            -- Action List - Rune of Power Phase
                        -- call_action_list,name=rop_phase,if=buff.rune_of_power.up&buff.combustion.down
                        if buff.runeOfPower and not buff.combustion then
                            if actionList_ROPPhase() then return end
                        end
            -- Action List - Single
                        -- call_action_list,name=single_target
                        if actionList_Single() then return end
            -- Scorch
                        if moving then
                            if cast.scorch() then return end
                        end
                    end -- End SimC APL
        ----------------------
        --- AskMrRobot APL ---
        ----------------------
                    if getOptionValue("APL Mode") == 2 then

                    end
				end --End In Combat
			end --End Rotation Logic
        end -- End Timer
    end -- End runRotation
    tinsert(cFire.rotations, {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })
end --End Class Check
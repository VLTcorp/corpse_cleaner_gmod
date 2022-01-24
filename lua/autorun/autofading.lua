
local autofading = CreateConVar("ccc_autofading", "1" )
local kolizion = CreateConVar("ccc_nocollide", "1" )
local npcverrif = CreateConVar("ccc_all_ragdoll", "" )
local autofadingdur = CreateConVar("ccc_autofading_time", "120" )

--le code du bistro
if SERVER then 

    hook.Add("OnEntityCreated", "clean_ragdoll_vlt" , function (ent)        
        if ent:IsRagdoll() and (  IsValid(ent:GetOwner()) or npcverrif:GetBool() ) then
            if kolizion:GetBool() then
                ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
            end
            if autofading:GetBool() then                
                ent:Fire("FadeAndRemove", "", autofadingdur:GetFloat())
            end
        end
    end)

    hook.Add("CreateEntityRagdoll", "clean_corpses_vlt" , function (owner,ragdoll)        
        if npcverrif:GetBool() then
            if kolizion:GetBool() then
                ragdoll:SetCollisionGroup(COLLISION_GROUP_WEAPON)
            end
            if autofading:GetBool() then                
                ragdoll:Fire("FadeAndRemove", "", autofadingdur:GetFloat())
            end
        end
    end)

else --code du consomateur
    hook.Add( "PopulateToolMenu", "CustomMenuSettings", function()
        spawnmenu.AddToolMenuOption( "Options", "Corpse Cleaner", "settings", "Corpse Cleaner", "", "", function( panel )
            panel:ClearControls()
            panel:CheckBox("Auto fading",autofading:GetName() )
            panel:NumSlider("Fading time", autofadingdur:GetName() , 0, 900 )
            panel:CheckBox("Corpse no collide",kolizion:GetName() )
            panel:CheckBox("Apply for all ragdolls",npcverrif:GetName())      
        end )
    end )
    
end
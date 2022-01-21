
local autofading = CreateConVar("cc_autofading", "1" )
local kolizion = CreateConVar("cc_nocollide", "1" )
local npcverrif = CreateConVar("cc_only_npc_ragdoll", "0" )
local autofadingdur = CreateConVar("cc_autofading_time", "120" )

--le code du bistro
if SERVER then 

    hook.Add("OnEntityCreated", "otophadingue" , function (ent)        
        if ent:IsRagdoll() and (  IsValid(ent:GetOwner()) or npcverrif:GetBool() ) then
            if kolizion:GetBool() then
                ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
            end
            if autofading:GetBool() then                
                ent:Fire("FadeAndRemove", "", autofadingdur:GetFloat())
            end
        end
    end)

else --code du consomateur
   
    
    hook.Add( "PopulateToolMenu", "CustomMenuSettings", function()
        spawnmenu.AddToolMenuOption( "Options", "Corpse Cleaner", "settings", "Corpse Cleaner", "", "", function( panel )
            panel:ClearControls()
            panel:CheckBox("auto fading",autofading:GetName() )
            panel:NumSlider( "Fading time", autofadingdur:GetName() , 0, 900 )
            panel:CheckBox("corpse collide",kolizion:GetName() )
            panel:CheckBox("apply only for the npc ragdoll",npcverrif:GetName())      
        end )
    end )


end


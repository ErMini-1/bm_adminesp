ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('es:addGroupCommand', 'menu', 'admin', function(source)
    TriggerClientEvent('bm_spectate:openMenu', source)
end)

TriggerEvent('es:addGroupCommand', 'ping', 'user', function(source)
    TriggerClientEvent('chatMessage', source, 'PING', {255, 255, 0}, "Tienes "..GetPlayerPing(source).."ms de ping")
end)

RegisterServerEvent('bm_adminSystemv2:banUser')
AddEventHandler('bm_adminSystemv2:banUser', function(jugador, duracion, razon)
    local license,identifier,liveid,xblid,discord,playerip
	local target    = tonumber(jugador)
	local duree     = tonumber(duracion)
	local reason    = razon

	if reason == "" then
        reason = "Has sido baneado del servidor"
    end
    if target and target > 0 then
        local ping = GetPlayerPing(target)
    
        if duree and duree < 365 then
            local user = ESX.GetPlayerFromId(target)
            local sourceplayername = GetPlayerName(source)
            local targetplayername = GetPlayerName(target)
                for k,v in ipairs(GetPlayerIdentifiers(target))do
                    if string.sub(v, 1, string.len("license:")) == "license:" then
                        license = v
                    elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
                        identifier = v
                    elseif string.sub(v, 1, string.len("live:")) == "live:" then
                        liveid = v
                    elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
                        xblid  = v
                    elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                        discord = v
                    elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
                        playerip = v
                    end
                end
        
            if user.getGroup() ~= 'Developer' or user.getGroup() ~= "Dueño" then
                if duree > 0 then
                    TriggerEvent('baneos:banPlayer', source,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,0) --Timed ban here
                    DropPlayer(target, "Has sido baneado del servidor motivo: " .. reason)
                else
                    TriggerEvent('baneos:banPlayer', source,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,1) --Perm ban here
                    DropPlayer(target, "Has sido baneado permanentemente del servidor motivo: " .. reason)
                end
            else
                TriggerEvent('bansql:sendMessage', source, "No puedes banear a alguien de tanto nivel")
            end
        
        else
            TriggerEvent('bansql:sendMessage', source, "Tiempo invalido")
        end	
    else
        TriggerEvent('bansql:sendMessage', source, "ID Invalida")
    end
end)
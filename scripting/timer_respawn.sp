#include <sourcemod>
#include <sdktools>
#include <timer-mapzones>

#undef REQUIRE_EXTENSIONS
#include <cstrike>
#include <tf2>
#include <tf2_stocks>
#define REQUIRE_EXTENSIONS

#undef REQUIRE_PLUGIN
#include <updater>

#define UPDATE_URL		"http://bitbucket.toastdev.de/sourcemod-plugins/raw/master/LRWar.txt"

public Plugin:myinfo = 
{
	name = "Timer: Respawn",
	author = "Toast",
	description = "Auto respawn until someone finishs map",
	version = "0.0.1",
	url = "bitbucket.toastdev.de"
}

new bool:g_bMapEnded;

public OnPluginStart()
{

	HookEvent("player_death", Event_PlayerDeath_Callback);

	if (LibraryExists("updater"))
    {
        Updater_AddPlugin(UPDATE_URL);
    }
}

public OnLibraryAdded(const String:name[])
{
    if (StrEqual(name, "updater"))
    {
        Updater_AddPlugin(UPDATE_URL)
    }
}

public Event_PlayerDeath_Callback(Handle:event, const String:name[], bool:dontBroadcast)
{
	new p_iUserid = GetEventInt(event, "userid");
	new p_iClient = GetClientOfUserId(p_iUserid);

	if(!g_bMapEnded && IsClientInGame(p_iClient) && IsPlayerAlive(p_iClient)){
		RespawnPlayer(p_iClient);
	}

}

public OnClientStartTouchZoneType(client, MapZoneType:p_iType)
{
	if(p_iType == 0 && !g_bMapEnded && IsClientInGame(client))
	{
		g_bMapEnded = true;
	}
}

/** Stock from respawn.sp by bobbobagan - Removed logging and DOD support**/
public RespawnPlayer(target)
{
	decl String:game[40];
	GetGameFolderName(game, sizeof(game));

	if (StrEqual(game, "cstrike") || StrEqual(game, "csgo"))
	{
		CS_RespawnPlayer(target);
	}
	else if (StrEqual(game, "tf"))
	{
		TF2_RespawnPlayer(target);
	}
}
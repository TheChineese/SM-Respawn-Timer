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

#define UPDATE_URL		"http://bitbucket.toastdev.de/sourcemod-plugins/raw/master/TimerRespawn.txt"

public Plugin myinfo = 
{
	name = "Timer: Respawn",
	author = "Toast",
	description = "Auto respawn until someone finishs map",
	version = "0.0.2",
	url = "bitbucket.toastdev.de"
}

bool g_bMapEnded = false;
bool g_bDebug = true;

public OnPluginStart()
{

	if(g_bDebug)
	{
		PrintToServer("[Timer Respawn] Hooking Death Event");
	}

	HookEvent("player_death", Event_PlayerDeath_Callback);

	if (LibraryExists("updater"))
    {
        Updater_AddPlugin(UPDATE_URL);
    }
}

public OnLibraryAdded(char[] name)
{
    if (StrEqual(name, "updater"))
    {
        Updater_AddPlugin(UPDATE_URL)
    }
}

public Action Event_PlayerDeath_Callback(Handle event, char[] name, bool dontBroadcast)
{
	int p_iUserid = GetEventInt(event, "userid");
	int p_iClient = GetClientOfUserId(p_iUserid);

	if(g_bDebug)
	{
		PrintToServer("[Timer Respawn] Someone died");
	}
	if(!g_bMapEnded && IsClientInGame(p_iClient) && IsPlayerAlive(p_iClient)){
		if(g_bDebug)
		{
			PrintToServer("[Timer Respawn] Respawning him");
		}
		RespawnPlayer(p_iClient);
	}

}

public OnClientStartTouchZoneType(client, MapZoneType:p_iType)
{
	if(g_bDebug)
	{
		PrintToServer("[Timer Respawn] Somone touched timer zone type: %i", p_iType);
	}
	if(p_iType == 0 && !g_bMapEnded && IsClientInGame(client))
	{
		if(g_bDebug)
		{
			PrintToServer("[Timer Respawn] End Zone Touched! Map Ended!");
		}
		g_bMapEnded = true;
	}
}

/** Stock from respawn.sp by bobbobagan - Removed logging and DOD support**/
public RespawnPlayer(target)
{
	char game[40];
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
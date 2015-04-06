#include <sourcemod>
#include <sdktools>
#include <timer-mapzones>

#undef REQUIRE_EXTENSIONS
#include <cstrike>
#include <tf2>
#include <tf2_stocks>
#define REQUIRE_EXTENSIONS

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name = "Timer: Respawn",
	author = "Toast",
	description = "Auto respawn until someone finishs map",
	version = "0.0.3",
	url = "bitbucket.toastdev.de"
}

bool g_bMapEnded = false;
bool g_bDebug = true;

public void OnPluginStart()
{

	if(g_bDebug)
	{
		PrintToChatAll("[Timer Respawn] Hooking Death Event");
	}

	HookEvent("player_death", Event_PlayerDeath_Callback);

}


public Action Event_PlayerDeath_Callback(Handle event, char[] name, bool dontBroadcast)
{
	int p_iUserid = GetEventInt(event, "userid");
	int p_iClient = GetClientOfUserId(p_iUserid);

	if(g_bDebug)
	{
		PrintToChatAll("[Timer Respawn] Someone died. User: %N ", p_iClient);
	}
	if(!g_bMapEnded && IsClientInGame(p_iClient)){
		if(g_bDebug)
		{
			PrintToChatAll("[Timer Respawn] Respawning him");
		}
		RespawnPlayer(p_iClient);
	}

}

public int OnClientStartTouchZoneType(int client, MapZoneType p_cType)
{
	if(g_bDebug)
	{
		PrintToChatAll("[Timer Respawn] Somone touched timer zone!");
	}
	if(p_cType == ZtEnd && !g_bMapEnded && IsClientInGame(client))
	{
		if(g_bDebug)
		{
			PrintToChatAll("[Timer Respawn] End Zone Touched! Map Ended!");
		}
		g_bMapEnded = true;
	}
}

/** Stock from respawn.sp by bobbobagan - Removed logging and DOD support**/
public void RespawnPlayer(int target)
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
	else if(g_bDebug)
	{
		PrintToChatAll("[Timer Respawn] Respawn failed!");
	}
}
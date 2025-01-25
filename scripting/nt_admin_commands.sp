#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

bool g_wantsRestart;

public Plugin myinfo = {
	name = "NT admin commands",
	description = "Allows admins to do some rcon commands without having rcon access",
	author = "bauxite",
	version = "0.1.0",
	url = "",
};

public void OnPluginStart()
{
	RegAdminCmd("sm_restart", CommandRestart, ADMFLAG_GENERIC);
}

public void OnMapStart()
{
	g_wantsRestart = false;
}

public Action CommandRestart(int client, int args)
{
	if(!g_wantsRestart)
	{
		g_wantsRestart = true;
		CreateTimer(10.0, RestartReset, _, TIMER_FLAG_NO_MAPCHANGE);
		ReplyToCommand(client, "[Admin commands] Use the command again in 10s to restart");
		return Plugin_Continue;
	}
	
	ServerCommand("_restart");
	
	return Plugin_Continue;
}

public Action RestartReset(Handle timer)
{
	g_wantsRestart = false;
	return Plugin_Stop;
}

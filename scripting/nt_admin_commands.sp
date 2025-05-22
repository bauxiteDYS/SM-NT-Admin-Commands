#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

char g_tag[] = "[Admin Commands]";
ConVar g_cvCamera = null;
bool g_wantsRestart;

public Plugin myinfo = {
	name = "NT admin commands",
	description = "Extra functionality for admins and server operators",
	author = "bauxite",
	version = "0.1.2",
	url = "",
};

public void OnPluginStart()
{
	RegAdminCmd("sm_restart", CommandRestart, ADMFLAG_GENERIC, "Restart the server, use with caution");
	RegAdminCmd("sm_camera", Cmd_Camera, ADMFLAG_GENERIC, "Toggle Death Camera");
	
	g_cvCamera = FindConVar("mp_forcecamera");
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
		ReplyToCommand(client, "%s Use the command again in 10s to restart", g_tag);
		return Plugin_Continue;
	}
	
	ServerCommand("_restart");
	
	return Plugin_Handled;
}

public Action RestartReset(Handle timer)
{
	g_wantsRestart = false;
	
	return Plugin_Stop;
}

public Action Cmd_Camera(int client, int args)
{
	if(g_cvCamera == null)
	{
		ReplyToCommand(client, "%s Could not find camera CVAR", g_tag);
		
		return Plugin_Handled;
	}
	
	bool state = g_cvCamera.BoolValue;
	
	g_cvCamera.BoolValue = !state;
	
	ReplyToCommand(client, "%s Death camera was %s", g_tag, state ? "Enabled":"Disabled");
	
	return Plugin_Handled;
}

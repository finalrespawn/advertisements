#include <sourcemod>
#include <colours>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = {
	name = "Advertisements",
	author = "Final Respawn",
	description = "Simple and effective advertisements",
	version = "1.0",
	url = "http://finalrespawn.com"
};

Handle g_Advertisements = null;
char g_Message[64][256];
int g_MessageCount, g_MessagePos;

public void OnPluginStart()
{
	GetAdvertisements();
}

public void OnMapStart()
{
	g_Advertisements = CreateTimer(float(GetRandomInt(30, 90)), Timer_Advertisements);
}

public void OnMapEnd()
{
	if (g_Advertisements != null)
	{
		KillTimer(g_Advertisements);
		g_Advertisements = null;
	}
}

public void GetAdvertisements()
{
	char ConfigPath[256];
	BuildPath(Path_SM, ConfigPath, 256, "configs/advertisements.txt");
	
	Handle hFile = OpenFile(ConfigPath, "r");
	
	if (hFile == null)
	{
		SetFailState("[Advertisements] Configuration file not found. Please check configs/advertisements.txt.");
	}
	
	while (ReadFileLine(hFile, g_Message[g_MessageCount], 256))
	{
		g_MessageCount++;
	}
	
	CloseHandle(hFile);
}

public Action Timer_Advertisements(Handle timer)
{
	CPrintToChatAll(g_Message[g_MessagePos]);
	g_MessagePos++;
	
	if (g_MessagePos >= g_MessageCount)
	{
		g_MessagePos = 0;
	}
	
	g_Advertisements = CreateTimer(float(GetRandomInt(30, 90)), Timer_Advertisements);
}
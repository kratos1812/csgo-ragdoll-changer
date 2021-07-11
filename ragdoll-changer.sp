#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

#pragma newdecls required

public Plugin myinfo = 
{
	name = "RagDoll Changer",
	author = "kRatoss"
};

ConVar g_cvXForceMultiplier;
ConVar g_cvYForceMultiplier;
ConVar g_cvZForceMultiplier;

ConVar g_cvXVelocityMultiplier;
ConVar g_cvYVelocityMultiplier;
ConVar g_cvZVelocityMultiplier;

public void OnPluginStart()
{
	HookEvent("player_death", __ON_PLAYER_DEATH__, EventHookMode_Pre);
	
	g_cvXForceMultiplier = CreateConVar("sm_ragdolls_x_force_multiplier", "8.0", "Multiply the force of the ragdoll on the X axis by this value");
	g_cvYForceMultiplier = CreateConVar("sm_ragdolls_y_force_multiplier", "4.0", "Multiply the force of the ragdoll on the Y axis by this value");
	g_cvZForceMultiplier = CreateConVar("sm_ragdolls_z_force_multiplier", "8.0", "Multiply the force of the ragdoll on the Z axis by this value");
	
	g_cvXVelocityMultiplier = CreateConVar("sm_ragdolls_x_velocity_multiplier", "8.0", "Multiply the velocity of the ragdoll on the X axis by this value");
	g_cvYVelocityMultiplier = CreateConVar("sm_ragdolls_y_velocity_multiplier", "4.0", "Multiply the velocity of the ragdoll on the Y axis by this value");
	g_cvZVelocityMultiplier = CreateConVar("sm_ragdolls_z_velocity_multiplier", "8.0", "Multiply the velocity of the ragdoll on the Z axis by this value");
	
	AutoExecConfig(true);
}

public Action __ON_PLAYER_DEATH__(Event pEvent, const char[] sName, bool bDontBroadcast)
{
	static int iClient;
	static int iEntity;
	
	static float fForce[3];
	static float fVelocity[3];
	
	iClient = GetClientOfUserId(pEvent.GetInt("userid"));
	
	if(iClient > 0 && IsClientInGame(iClient))
	{
		iEntity = GetEntPropEnt(iClient, Prop_Send, "m_hRagdoll");
		
		if(iEntity != -1 && IsValidEntity(iEntity) && IsValidEdict(iEntity))
		{
			GetEntPropVector(iEntity, Prop_Send, "m_vecForce", fForce);
			GetEntPropVector(iEntity, Prop_Send, "m_vecRagdollVelocity", fVelocity);
			
			fForce[0] *= g_cvXForceMultiplier.FloatValue;
			fForce[1] *= g_cvYForceMultiplier.FloatValue;
			fForce[2] *= g_cvZForceMultiplier.FloatValue;
			
			fVelocity[0] *= g_cvXVelocityMultiplier.FloatValue;
			fVelocity[1] *= g_cvYVelocityMultiplier.FloatValue;
			fVelocity[2] *= g_cvZVelocityMultiplier.FloatValue;
			
			SetEntPropVector(iEntity, Prop_Send, "m_vecForce", fForce);
			SetEntPropVector(iEntity, Prop_Send, "m_vecRagdollVelocity", fVelocity);
		}
	}
}
#include "ShaderConstants.fxh"

struct VS_Input
{
    float3 position : POSITION;
    float4 color : COLOR;
#ifdef INSTANCEDSTEREO
	uint instanceID : SV_InstanceID;
#endif

};


struct PS_Input
{
    float4 position : SV_Position;
    float4 color : COLOR;
#ifdef GEOMETRY_INSTANCEDSTEREO
	uint instanceID : SV_InstanceID;
#endif
#ifdef VERTEXSHADER_INSTANCEDSTEREO
	uint renTarget_id : SV_RenderTargetArrayIndex;
#endif
};

static const float fogNear = 4.0;

static const float3 inverseLightDirection = float3( 0.62, 0.78, 0.0 );
static const float ambient = 1.0;

ROOT_SIGNATURE
void main(in VS_Input VSInput, out PS_Input PSInput)
{
#ifdef INSTANCEDSTEREO
	int i = VSInput.instanceID;
	PSInput.position = mul( WORLDVIEWPROJ_STEREO[i], float4( VSInput.position.x, 1.0, VSInput.position.z, 1 ) );
	float3 worldPos = mul(WORLD_STEREO, float4(VSInput.position, 1));
#else
	PSInput.position = mul(WORLDVIEWPROJ, float4(VSInput.position, 1));
	float3 worldPos = mul(WORLD, float4(VSInput.position, 1));
#endif
#ifdef GEOMETRY_INSTANCEDSTEREO
	PSInput.instanceID = VSInput.instanceID;
#endif 
#ifdef VERTEXSHADER_INSTANCEDSTEREO
	PSInput.renTarget_id = VSInput.instanceID;
#endif
    PSInput.color = VSInput.color * CURRENT_COLOR;

	float depth = length(worldPos) / RENDER_DISTANCE;

    float fog = max( depth - fogNear, 0.0 );

    PSInput.color.a *= 0.5 - fog;

    PSInput.color.rgb *= 3.0;
}

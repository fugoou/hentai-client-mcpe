#include "ShaderConstants.fxh"

struct PS_Input
{
	float4 position : SV_Position;
};

struct PS_Output
{
	float4 color : SV_Target;

	#ifdef FORCE_DEPTH_ZERO
		float depth : SV_Depth;
	#endif
};

ROOT_SIGNATURE
void main(in PS_Input PSInput, out PS_Output PSOutput)
{
	PSOutput.color = float4(0.622,0.034,1.000,1.000);

	#ifdef FORCE_DEPTH_ZERO
		PSOutput.depth = 0.0;
	#endif
}
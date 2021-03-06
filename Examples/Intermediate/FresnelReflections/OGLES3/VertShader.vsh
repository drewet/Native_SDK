#version 300 es

#define VERTEX_ARRAY	0
#define NORMAL_ARRAY	1
#define TEXCOORD_ARRAY	2

layout (location = VERTEX_ARRAY) in highp vec4	inVertex;
layout (location = NORMAL_ARRAY) in highp vec3	inNormal;
layout (location = TEXCOORD_ARRAY) in highp vec2 inTexCoord;

uniform highp mat4   MVPMatrix;
uniform highp vec3   EyePosition;
uniform highp float  RIRSquare;

out mediump vec2   ReflectCoord;
out mediump vec2   TexCoord;
out lowp    float  ReflectRatio;

void main()
{
	// Transform position
	gl_Position = MVPMatrix * inVertex;
	
	// Calculate direction from vertex to eye (model space)
	highp vec3 eyeDir = normalize(EyePosition - inVertex.xyz);
	
	// The reflection intensity depends on the angle between eye direction and
	// surface normal.
	// The relative index of refraction (RIR) is a material parameter
	highp float c = abs(dot(eyeDir, inNormal));
	highp float g = sqrt(RIRSquare + c * c - 1.0);
	highp float f1 = (g - c) / (g + c);
	highp float f2 = (c * (g + c) - 1.0) / (c * (g - c) + 1.0);
	ReflectRatio = 0.5 * f1 * f1 * (1.0 + f2 * f2);
	
	// map reflection vector to 2D
	ReflectCoord = normalize(reflect(eyeDir, inNormal)).xy * 0.5;
	
	TexCoord = inTexCoord;
}

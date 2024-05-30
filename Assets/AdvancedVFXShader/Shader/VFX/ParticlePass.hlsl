// Copyright 2022 谭杰鹏. All Rights Reserved //https://github.com/JiepengTan 
// https://space.bilibili.com/481436151
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Packing.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonMaterial.hlsl"

#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "VFXCore.hlsl"
TEXTURE2D(_MainTex);                SAMPLER(sampler_MainTex);
TEXTURE2D(_MaskMap);                SAMPLER(sampler_MaskMap);
TEXTURE2D(_GlowMap);            SAMPLER(sampler_GlowMap);
TEXTURE2D(_GlobalDistortMap);           SAMPLER(sampler_GlobalDistortMap);
TEXTURE2D(_GlowMaskMap);        SAMPLER(sampler_GlowMaskMap);
TEXTURE2D(_MainDistortMap);       SAMPLER(sampler_MainDistortMap);
TEXTURE2D(_MaskDistortMap);       SAMPLER(sampler_MaskDistortMap);
TEXTURE2D(_GlowDistortMap);       SAMPLER(sampler_GlowDistortMap);
TEXTURE2D(_DissolveDistortMap);       SAMPLER(sampler_DissolveDistortMap);

TEXTURE2D(_DissolveMap);       SAMPLER(sampler_DissolveMap);
TEXTURE2D(_DissolveMaskMap);       SAMPLER(sampler_DissolveMaskMap);
// Pre-multiplied alpha helper
#if defined(_ALPHAPREMULTIPLY_ON)  //if( blend: One OneMinusSrcAlpha)
    #define ALBEDO_MUL albedo
#else
    #define ALBEDO_MUL albedo.a
#endif

// 相机虚化	
#if defined(FADING_ON) 
    #define _USING_CAMERA_FADING
#endif
// 软粒子
#if defined(SOFTPARTICLES_ON) 
    #define _USING_SOFTPARTICLES
#endif   
#if defined(_USING_ERASE_LINEAR) ||defined(_USING_ERASE_CIRCLE) || defined(_USING_ERASE_ANGLE)
    #define _USING_ERASE_FEATURE
#else
    #undef _USING_ERASE_FEATURE
#endif
#if defined(_USING_CUSTOM_DATA1) || defined(_USING_CUSTOM_DATA2) || defined(_USING_CUSTOM_DATA3) || defined(_USING_CUSTOM_DATA4)
    #define _USING_CUSTOM_DATA0
#endif

#if defined(_USING_CUSTOM_DATA1) 
	#define _USING_CD_DATA1
#endif
#if defined(_USING_CUSTOM_DATA2) 
	#define _USING_CD_DATA1
	#define _USING_CD_DATA2
#endif
#if defined(_USING_CUSTOM_DATA3) 
	#define _USING_CD_DATA1
	#define _USING_CD_DATA2
	#define _USING_CD_DATA3
#endif
#if defined(_USING_CUSTOM_DATA4) 
	#define _USING_CD_DATA1
	#define _USING_CD_DATA2
	#define _USING_CD_DATA3
	#define _USING_CD_DATA4
#endif


#if !defined(_USING_GLOBAL_UV_OPT)
	#undef _USING_GLOBAL_TWIRL
	#undef _USING_GLOBAL_POLAR_COORD
	#undef _USING_GLOBAL_UV_DISTORT
#endif

#if !defined(_USING_MAIN_UV_OPT)
	#undef _USING_MAIN_TWIRL
	#undef _USING_MAIN_POLAR_COORD
	#undef _USING_MAIN_UV_DISTORT
#endif

#if !defined(_USING_MASK_UV_OPT)
	#undef _USING_MASK_TWIRL
	#undef _USING_MASK_POLAR_COORD
	#undef _USING_MASK_UV_DISTORT
#endif

#if !defined(_USING_GLOW_UV_OPT)
	#undef _USING_GLOW_TWIRL
	#undef _USING_GLOW_POLAR_COORD
	#undef _USING_GLOW_UV_DISTORT
#endif

#if !defined(_USING_DISSOLVE_UV_OPT)
	#undef _USING_DISSOLVE_TWIRL
	#undef _USING_DISSOLVE_POLAR_COORD
	#undef _USING_DISSOLVE_UV_DISTORT
#endif



#if defined(_USING_CD1DD_DISSOLVE_THRESHOLD) || defined(_USING_CD2DD_DISSOLVE_THRESHOLD) || defined(_USING_CD3DD_DISSOLVE_THRESHOLD) || defined(_USING_CD4DD_DISSOLVE_THRESHOLD)
    #define _USING_CD0DD_DISSOLVE_THRESHOLD
#endif
#if defined(_USING_CD1DD_ERASE_PROGRESS) || defined(_USING_CD2DD_ERASE_PROGRESS) || defined(_USING_CD3DD_ERASE_PROGRESS) || defined(_USING_CD4DD_ERASE_PROGRESS)
    #define _USING_CD0DD_ERASE_PROGRESS
#endif
#if defined(_USING_CD1DD_GLOW_THRESHOLD) || defined(_USING_CD2DD_GLOW_THRESHOLD) || defined(_USING_CD3DD_GLOW_THRESHOLD) || defined(_USING_CD4DD_GLOW_THRESHOLD)
    #define _USING_CD0DD_GLOW_THRESHOLD
#endif
#if defined(_USING_CD1DD_DISTORT_INTENSITY) || defined(_USING_CD2DD_DISTORT_INTENSITY) || defined(_USING_CD3DD_DISTORT_INTENSITY) || defined(_USING_CD4DD_DISTORT_INTENSITY)
    #define _USING_CD0DD_DISTORT_INTENSITY
#endif
#if defined(_USING_CD1DD_MAIN_OFFSET) || defined(_USING_CD2DD_MAIN_OFFSET) || defined(_USING_CD3DD_MAIN_OFFSET) || defined(_USING_CD4DD_MAIN_OFFSET)
    #define _USING_CD0DD_MAIN_OFFSET
#endif
#if defined(_USING_CD1DD_GLOW_OFFSET) || defined(_USING_CD2DD_GLOW_OFFSET) || defined(_USING_CD3DD_GLOW_OFFSET) || defined(_USING_CD4DD_GLOW_OFFSET)
    #define _USING_CD0DD_GLOW_OFFSET
#endif

#if defined(_USING_GLOBAL_UV_DISTORT)
    #define __DECLARE_INTENSITY_FACTOR_DISTORT(prefix) half prefix##DistortGlobalFactor;
#else 
    #define __DECLARE_INTENSITY_FACTOR_DISTORT(prefix) 
#endif 

#if defined(_USING_GLOBAL_TWIRL)
    #define __DECLARE_INTENSITY_FACTOR_TWIST(prefix) half prefix##TwirlGlobalFactor;
#else 
    #define __DECLARE_INTENSITY_FACTOR_TWIST(prefix) 
#endif 

#if defined(_USING_GLOBAL_POLAR_COORD)
    #define __DECLARE_INTENSITY_FACTOR_POLAR(prefix) half prefix##PolarGlobalFactor;
#else 
    #define __DECLARE_INTENSITY_FACTOR_POLAR(prefix) 
#endif 

#define __DECLARE_INTENSITY_FACTOR(prefix) \
    __DECLARE_INTENSITY_FACTOR_DISTORT(prefix) \
    __DECLARE_INTENSITY_FACTOR_TWIST(prefix) \
    __DECLARE_INTENSITY_FACTOR_POLAR(prefix) 


#define __DECLARE_TWIRL(prefix) \
	half4 prefix##TwirlCenter;\
	half prefix##TwirlIntensity;

#define __DECLARE_POLAR(prefix) \
	half4 prefix##PolarCenter;\
	half prefix##PolarRadialFactor;\
	half prefix##PolarLengthFactor;\
	half prefix##PolarIntensity;

#define __DECLARE_DISTORT(prefix) \
	half4 prefix##DistortMap_ST;\
	half4 prefix##DistortUVPanSpeed;\
	half prefix##DistortUVRotateSpeed;\
	half prefix##DistortIntensity;

CBUFFER_START(UnityPerMaterial)
// global intensity factor
//#if defined(_USING_GLOBAL_UV_OPT)
	__DECLARE_INTENSITY_FACTOR(_Global);
	__DECLARE_INTENSITY_FACTOR(_Main);
	__DECLARE_INTENSITY_FACTOR(_Mask);
	__DECLARE_INTENSITY_FACTOR(_Glow);
	__DECLARE_INTENSITY_FACTOR(_Dissolve);
//#endif

// _Global
#if defined(_USING_GLOBAL_TWIRL)
	__DECLARE_TWIRL(_Global)
#endif
#if defined(_USING_GLOBAL_POLAR_COORD)
	__DECLARE_POLAR(_Global)
#endif
#if defined(_USING_GLOBAL_UV_DISTORT)
	__DECLARE_DISTORT(_Global)
#endif

// _MAIN
#if defined(_USING_MAIN_TWIRL)
	__DECLARE_TWIRL(_Main)
#endif
#if defined(_USING_MAIN_POLAR_COORD)
	__DECLARE_POLAR(_Main)
#endif
#if defined(_USING_MAIN_UV_DISTORT)
	__DECLARE_DISTORT(_Main)
#endif
// _MASK
#if defined(_USING_MASK_TWIRL)
	__DECLARE_TWIRL(_Mask)
#endif
#if defined(_USING_MASK_POLAR_COORD)
	__DECLARE_POLAR(_Mask)
#endif
#if defined(_USING_MASK_UV_DISTORT)
	__DECLARE_DISTORT(_Mask)
#endif
// _GLOW
#if defined(_USING_GLOW_TWIRL)
	__DECLARE_TWIRL(_Glow)
#endif
#if defined(_USING_GLOW_POLAR_COORD)
	__DECLARE_POLAR(_Glow)
#endif
#if defined(_USING_GLOW_UV_DISTORT)
	__DECLARE_DISTORT(_Glow)
#endif
// _DISSOLVE
#if defined(_USING_DISSOLVE_TWIRL)
	__DECLARE_TWIRL(_Dissolve)
#endif
#if defined(_USING_DISSOLVE_POLAR_COORD)
	__DECLARE_POLAR(_Dissolve)
#endif
#if defined(_USING_DISSOLVE_UV_DISTORT)
	__DECLARE_DISTORT(_Dissolve)
#endif


    // main 
	half4 _Color;
	float4 _MainTex_ST;
	half _MainUVRotation;
	half2 _MainUVPanSpeed;
	

	// 序列帧
#if defined(_USING_TEXTURE_SHEET)
	float2 _TextureSheetSize;
	half _TextureSheetSpeed;
	half _TextureSheetLeftFirst;
	half _TextureSheetTopFirst;
	half _TextureSheetIsLoop;
	half _TextureSheetProgress;
#endif

	// Mask
#if defined(_USING_MASKMAP)
	float4 _MaskMap_ST;
	half2 _MaskUVPanSpeed;
	half _MaskUVRotation;
#endif
	// Erase
#if defined(_USING_ERASE_FEATURE)
	half  _EraseSoftenFactor;
	half _EraseUVRotation;
	half _EraseProgress;
#endif
	
	//Glow 
#if defined(_USING_GLOW)
	half4 _GlowMap_ST;
	half4 _GlowMaskMap_ST;
	half _GlowUVRotation;
	half4 _GlowUVPanSpeed;
	half _GlowAlphaEnhanceFactor;
	half _GlowSoftenFactor;
	half4 _GlowColor;
	half _GlowThreshold;
#endif
	
	//Dissolve
#if defined(_USING_DISSOLVE)
	half4 _DissolveMap_ST;
	half _DissolveUVRotation;
	half2 _DissolveUVPanSpeed;

	half4 _DissolveMaskMap_ST;
	half _DissolveMaskUVRotation;

	half _DissolveEdgeRange;
	half3 _DissolveEdgeColor;
	half _DissolveThreshold;
#endif
	
	//Fresnel
#if defined(_USING_FRESNEL)
	half4 _FresnelColor;
	half4 _FresnelTransitionColor;
	half _FresnelTransitionPower;
	half _FresnelPower;
	half _FresnelRevertFactor;
#endif
	//Air Distort
#if defined(_USING_AIR_DISTORT)
	half  _AirDistortIntensity;
	half4 _AirDistortColor;
#endif
		
	//Fog
#if defined(_USING_FOG)
	half _FinalFogIntensity;
#endif
	
#if defined(_USING_ALPHA_CUTOUT)
	half _AlphaCutout;
#endif
	//Particle
#if defined(_USING_SOFTPARTICLES)
	half  _SoftParticlesNearFadeDistance;
	half  _SoftParticlesFarFadeDistance;
#endif
#if defined(_USING_CAMERA_FADING)
	half  _CameraNearFadeDistance;
	half  _CameraFarFadeDistance;
#endif
	
CBUFFER_END

#define SOFT_PARTICLE_NEAR_FADE _SoftParticlesNearFadeDistance   
#define SOFT_PARTICLE_INV_FADE_DISTANCE (1.0f / (_SoftParticlesFarFadeDistance - _SoftParticlesNearFadeDistance)) 

#define CAMERA_NEAR_FADE  _CameraNearFadeDistance
#define CAMERA_INV_FADE_DISTANCE  (1.0f / (_CameraFarFadeDistance - _CameraNearFadeDistance))   

#if defined(_USING_SOFTPARTICLES) || defined(_USING_CAMERA_FADING) || defined(_USING_AIR_DISTORT)
#define _NEED_PROJECT_POSITION
#endif
struct appdata_particles
{
	float4 vertex : POSITION;
	half4  color : COLOR;
#if defined(_USING_CUSTOM_DATA0)
	float4 texcoords : TEXCOORD0; // xy=>uv  zw=> cusDataDissolve_Cutout_Glow_GlobalDistort.xy 
	
  #if defined(_USING_CD_DATA3) 
	float2 cusDataDissolve_Cutout_Glow_GlobalDistort  :  TEXCOORD2; // cusDataDissolve_Cutout_Glow_GlobalDistort.zw
  #endif

#else
	float2 texcoords : TEXCOORD0;
#endif

#if defined(_USING_FRESNEL)
	float3 normalOS : NORMAL;
#endif

	UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct v2f
{
	float4 clipPos : SV_POSITION;

	half4  color                     : COLOR;
	float4 uvMainMask                  : TEXCOORD0;  // 主帖图和Mask贴图共用 
	float4 positionWS                : TEXCOORD1;

#if defined (_USING_GLOW) || defined(_USING_ERASE_FEATURE)
	float4 uvGlowErase           : TEXCOORD2;  // 流光和Noise共用
#endif


#if defined(_NEED_PROJECT_POSITION) 
	float4 projectedPosition        : TEXCOORD4;
#endif

#if defined(_USING_CUSTOM_DATA0)
	float4 cusDataDissolve_Cutout_Glow_GlobalDistort        : TEXCOORD5; // x 溶解 y擦除 z流光阈值 w UV扭曲
	float2 cusDataMainOffset_GlowOffset       : TEXCOORD6; // x 主贴图 offset系数  y流光贴图 offset系数
#endif

#if defined(_USING_FRESNEL)
	float3 normalWS : TEXCOORD7;
#endif
		
	UNITY_VERTEX_INPUT_INSTANCE_ID
	UNITY_VERTEX_OUTPUT_STEREO
};

void SetCD1(inout v2f output,float val) {
#if defined(_USING_CD1DD_DISSOLVE_THRESHOLD)
    output.cusDataDissolve_Cutout_Glow_GlobalDistort.x = val;
#elif defined(_USING_CD1DD_ERASE_PROGRESS)
    output.cusDataDissolve_Cutout_Glow_GlobalDistort.y = val;
#elif defined(_USING_CD1DD_GLOW_THRESHOLD)
    output.cusDataDissolve_Cutout_Glow_GlobalDistort.z = val;
#elif defined(_USING_CD1DD_DISTORT_INTENSITY)
    output.cusDataDissolve_Cutout_Glow_GlobalDistort.w = val;
#elif defined(_USING_CD1DD_MAIN_OFFSET)
    output.cusDataMainOffset_GlowOffset.x = val;
#elif defined(_USING_CD1DD_GLOW_OFFSET)
    output.cusDataMainOffset_GlowOffset.y = val;
#endif
}
void SetCD2(inout v2f output,float val) {
#if defined(_USING_CD2DD_DISSOLVE_THRESHOLD)
    output.cusDataDissolve_Cutout_Glow_GlobalDistort.x = val;
#elif defined(_USING_CD2DD_ERASE_PROGRESS)
    output.cusDataDissolve_Cutout_Glow_GlobalDistort.y = val;
#elif defined(_USING_CD2DD_GLOW_THRESHOLD)
    output.cusDataDissolve_Cutout_Glow_GlobalDistort.z = val;
#elif defined(_USING_CD2DD_DISTORT_INTENSITY)
    output.cusDataDissolve_Cutout_Glow_GlobalDistort.w = val;
#elif defined(_USING_CD2DD_MAIN_OFFSET)
    output.cusDataMainOffset_GlowOffset.x = val;
#elif defined(_USING_CD2DD_GLOW_OFFSET)
    output.cusDataMainOffset_GlowOffset.y = val;
#endif
}
void SetCD3(inout v2f output,float val) {
#if defined(_USING_CD3DD_DISSOLVE_THRESHOLD)
    output.cusDataDissolve_Cutout_Glow_GlobalDistort.x = val;
#elif defined(_USING_CD3DD_ERASE_PROGRESS)
    output.cusDataDissolve_Cutout_Glow_GlobalDistort.y = val;
#elif defined(_USING_CD3DD_GLOW_THRESHOLD)
    output.cusDataDissolve_Cutout_Glow_GlobalDistort.z = val;
#elif defined(_USING_CD3DD_DISTORT_INTENSITY)
    output.cusDataDissolve_Cutout_Glow_GlobalDistort.w = val;
#elif defined(_USING_CD3DD_MAIN_OFFSET)
    output.cusDataMainOffset_GlowOffset.x = val;
#elif defined(_USING_CD3DD_GLOW_OFFSET)
    output.cusDataMainOffset_GlowOffset.y = val;
#endif
}

void SetCD4(inout v2f output,float val) {
#if defined(_USING_CD4DD_DISSOLVE_THRESHOLD)
    output.cusDataDissolve_Cutout_Glow_GlobalDistort.x = val;
#elif defined(_USING_CD4DD_ERASE_PROGRESS)
    output.cusDataDissolve_Cutout_Glow_GlobalDistort.y = val;
#elif defined(_USING_CD4DD_GLOW_THRESHOLD)
    output.cusDataDissolve_Cutout_Glow_GlobalDistort.z = val;
#elif defined(_USING_CD4DD_DISTORT_INTENSITY)
    output.cusDataDissolve_Cutout_Glow_GlobalDistort.w = val;
#elif defined(_USING_CD4DD_MAIN_OFFSET)
    output.cusDataMainOffset_GlowOffset.x = val;
#elif defined(_USING_CD4DD_GLOW_OFFSET)
    output.cusDataMainOffset_GlowOffset.y = val;
#endif
}

v2f vertParticle(appdata_particles appData)
{
	v2f output= (v2f)0;

	UNITY_SETUP_INSTANCE_ID(appData);
	UNITY_TRANSFER_INSTANCE_ID(appData, output);
	UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

	VertexPositionInputs vertexInput = GetVertexPositionInputs(appData.vertex.xyz);
	output.positionWS.xyz = vertexInput.positionWS;
	output.positionWS.w = ComputeFogFactor(vertexInput.positionCS.z);
	output.clipPos = vertexInput.positionCS;
	output.color = appData.color;
	
	#if defined(_USING_FRESNEL)
	output.normalWS.xyz = TransformObjectToWorldNormal(appData.normalOS.xyz);
	#endif

	output.uvMainMask.xy = TRANSFORM_TEX( appData.texcoords.xy, _MainTex);  //主帖图UV重复和偏移 
	output.uvMainMask.xy = DoRotate2D(output.uvMainMask.xy, _MainUVRotation);  //主贴图旋转
	output.uvMainMask.zw = half2(0, 0);

	#ifdef _USING_MASKMAP
	output.uvMainMask.zw = TRANSFORM_TEX(appData.texcoords.xy, _MaskMap);  
	output.uvMainMask.zw = DoRotate2D(output.uvMainMask.zw, _MaskUVRotation);    
	#endif

	#if defined (_USING_GLOW) 
	output.uvGlowErase.xy = TRANSFORM_TEX(appData.texcoords.xy, _GlowMap);  
	output.uvGlowErase.xy = DoRotate2D(output.uvGlowErase.xy, _GlowUVRotation);
	#endif
	
	#if defined(_USING_ERASE_FEATURE) 
	output.uvGlowErase.zw = DoRotate2D(appData.texcoords.xy,  _EraseUVRotation);
	#endif

	#if defined(_NEED_PROJECT_POSITION) 
	output.projectedPosition = ComputeScreenPos(vertexInput.positionCS);
	#endif

// Custom Data
#if defined(_USING_CD_DATA1)
	SetCD1(output, appData.texcoords.z);
#endif
#if defined(_USING_CD_DATA2)
	SetCD2(output, appData.texcoords.w);
#endif
#if defined(_USING_CD_DATA3)
	SetCD3(output, appData.cusDataDissolve_Cutout_Glow_GlobalDistort.x);
#endif
#if defined(_USING_CD_DATA4)
	SetCD4(output, appData.cusDataDissolve_Cutout_Glow_GlobalDistort.y);
#endif
	
	return output;
} 

#define __DO_GLOBAL_TWIRL(targetUV,prefix) targetUV = DoTwirl(targetUV, _GlobalTwirlCenter.xy, _GlobalTwirlCenter.zw, _GlobalTwirlIntensity * prefix##TwirlGlobalFactor );
#define __DO_GLOBAL_POLARCOORD(targetUV,prefix) targetUV = DoPolarinates(targetUV, _GlobalPolarCenter.xy, _GlobalPolarRadialFactor, _GlobalPolarLengthFactor, _GlobalPolarIntensity * prefix##PolarGlobalFactor );

#define __DO_TWIRL(targetUV,prefix) targetUV = DoTwirl(targetUV, prefix##Center.xy, prefix##Center.zw, prefix##Intensity );
#define __DO_POLARCOORD(targetUV,prefix) targetUV = DoPolarinates(targetUV, prefix##Center.xy, prefix##RadialFactor, prefix##LengthFactor, prefix##Intensity );

#if defined(_USING_GLOBAL_UV_OPT)
  #if defined(_USING_GLOBAL_POLAR_COORD) && defined(_USING_GLOBAL_TWIRL)
    #define DealGlobalUV(targetUV,prefix) __DO_GLOBAL_TWIRL(targetUV,prefix)  __DO_GLOBAL_POLARCOORD(targetUV,prefix)
  #elif defined(_USING_GLOBAL_TWIRL)
    #define DealGlobalUV(targetUV,prefix) __DO_GLOBAL_TWIRL(targetUV,prefix)  
  #elif defined(_USING_GLOBAL_POLAR_COORD)
    #define DealGlobalUV(targetUV,prefix) __DO_GLOBAL_POLARCOORD(targetUV,prefix)
  #else 
    #define DealGlobalUV(targetUV,prefix)
  #endif
#else 
    #define DealGlobalUV(targetUV,prefix)
#endif

#if defined(_USING_MAIN_POLAR_COORD) && defined(_USING_MAIN_TWIRL)
    #define DealMainUV(targetUV) __DO_TWIRL(targetUV,_MainTwirl)  __DO_POLARCOORD(targetUV,_MainPolar)
#elif defined(_USING_MAIN_TWIRL)
    #define DealMainUV(targetUV) __DO_TWIRL(targetUV,_MainTwirl)  
#elif defined(_USING_MAIN_POLAR_COORD)
    #define DealMainUV(targetUV) __DO_POLARCOORD(targetUV,_MainPolar)
#else 
    #define DealMainUV(targetUV)
#endif

#if defined(_USING_DISSOLVE_POLAR_COORD) && defined(_USING_DISSOLVE_TWIRL)
    #define DealDissolveUV(targetUV) __DO_TWIRL(targetUV,_DissolveTwirl)  __DO_POLARCOORD(targetUV,_DissolvePolar)
#elif defined(_USING_DISSOLVE_TWIRL)
    #define DealDissolveUV(targetUV) __DO_TWIRL(targetUV,_DissolveTwirl)  
#elif defined(_USING_DISSOLVE_POLAR_COORD)
    #define DealDissolveUV(targetUV) __DO_POLARCOORD(targetUV,_DissolvePolar)
#else 
    #define DealDissolveUV(targetUV)
#endif

#if defined(_USING_MASK_POLAR_COORD) && defined(_USING_MASK_TWIRL)
    #define DealMaskUV(targetUV) __DO_TWIRL(targetUV,_MaskTwirl)  __DO_POLARCOORD(targetUV,_MaskPolar)
#elif defined(_USING_MASK_TWIRL)
    #define DealMaskUV(targetUV) __DO_TWIRL(targetUV,_MaskTwirl)  
#elif defined(_USING_MASK_POLAR_COORD)
    #define DealMaskUV(targetUV) __DO_POLARCOORD(targetUV,_MaskPolar)
#else 
    #define DealMaskUV(targetUV)
#endif

#if defined(_USING_GLOW_POLAR_COORD) && defined(_USING_GLOW_TWIRL)
    #define DealGlowUV(targetUV) __DO_TWIRL(targetUV,_GlowTwirl)  __DO_POLARCOORD(targetUV,_GlowPolar)
#elif defined(_USING_GLOW_TWIRL)
    #define DealGlowUV(targetUV) __DO_TWIRL(targetUV,_GlowTwirl)  
#elif defined(_USING_GLOW_POLAR_COORD)
    #define DealGlowUV(targetUV) __DO_POLARCOORD(targetUV,_GlowPolar)
#else 
    #define DealGlowUV(targetUV)
#endif

#define DealUVDistort(rawUV, tag)\
	float2 glowNoiseUV = TRANSFORM_TEX(rawUV, tag##DistortMap);  \
  	finalDistortVal = globalNoiseValue * tag##DistortIntensity*\
	   CalcNoiseValue(glowNoiseUV,TEXTURE2D_ARGS(tag##DistortMap, sampler##tag##DistortMap),\
	   tag##DistortUVRotateSpeed,tag##DistortUVPanSpeed,tag##DistortIntensity);\
	
	


float CalcNoiseValue( float2 noiseUV, TEXTURE2D_PARAM( _Texture, sampler_Texture),float rotateSpeed,float2 uvSpeed,float noiseIntensity){
	noiseUV = DoRotate2D(noiseUV, rotateSpeed * 360 *_Time.y);     
	noiseUV += uvSpeed* _Time.y;
    half4 color = SAMPLE_TEXTURE2D(_Texture, sampler_Texture, noiseUV );
	
	return color.x * color.a * noiseIntensity ;
}
void _DoAirDistort(inout float3 result,inout float alpha,float4 projectedPosition){
#if defined (_USING_AIR_DISTORT)
    float3 albedo = result;
    half3 screenUV = projectedPosition.xyz / projectedPosition.w;
    float factor  = _AirDistortIntensity  * alpha;
    half2 offsetUV = lerp(screenUV.xy, screenUV.xy+(albedo.xy ), factor);
    result.rgb = DoGrabTexture(offsetUV);
    result = lerp(result, result * _AirDistortColor, factor);
    alpha = albedo.r * _AirDistortColor.a; 
#endif
}
void _DoDissolve(inout float3 result,inout float alpha,float2 rawUV,float customProgress,float globalNoiseValue){
#if defined(_USING_DISSOLVE)  
	// Apply Custom Data Control
	float dissolveProgress = _DissolveThreshold;
  #if defined (_USING_CD0DD_DISSOLVE_THRESHOLD)
	dissolveProgress += customProgress;
  #endif
    float finalDistortVal = 0;
    float2 distortUV = rawUV;
	distortUV = TRANSFORM_TEX(distortUV, _DissolveMap);
	// Apply global UV Operation
	DealGlobalUV(distortUV,_Dissolve); 
 #if defined(_USING_GLOBAL_UV_DISTORT)
	distortUV += globalNoiseValue * _DissolveDistortGlobalFactor;
 #endif

	// Apply child UV Operation
#if defined(_USING_DISSOLVE_UV_OPT)   
	distortUV = DoRotate2D(distortUV, _DissolveUVRotation);
	DealDissolveUV(distortUV); 
	distortUV = distortUV + _DissolveUVPanSpeed.xy * _Time.y; 
  #if defined(_USING_DISSOLVE_UV_DISTORT)
	DealUVDistort(rawUV,  _Dissolve);
	distortUV += finalDistortVal;
  #endif
	distortUV = distortUV + _DissolveUVPanSpeed.xy * _Time.y; 
#endif

	float4 dissolveTexVal = SAMPLE_TEXTURE2D(_DissolveMap, sampler_DissolveMap, distortUV);
	float dissolveValue = dissolveTexVal.r*dissolveTexVal.a;

	half dissolveMask = 1;
	// Apply Dissolve Mask
#if defined(_USING_DISSOLVE_MASK)  
	float2 maskUV = TRANSFORM_TEX(rawUV, _DissolveMaskMap);
	maskUV = DoRotate2D(maskUV, _DissolveMaskUVRotation);
	dissolveMask = SAMPLE_TEXTURE2D(_DissolveMaskMap, sampler_DissolveMaskMap, maskUV).r;
	dissolveValue = dissolveValue * dissolveMask;
#endif

	float4 disCol = DoDissolve(dissolveProgress, dissolveValue* alpha, _DissolveEdgeRange, _DissolveEdgeColor, result);
	result = disCol.rgb;
	alpha *= disCol.a;
#endif
}

void _DoGlow(inout float3 result,inout float alpha,float2 rawUV,float2 uvGlowErase, float customGlowOffset,float customGlowProgress,float globalNoiseValue)
{
    float finalDistortVal = 0;
#if defined (_USING_GLOW)
	float glowProgress = _GlowThreshold;
	float2 glowUV = uvGlowErase;   
 #if defined(_USING_GLOW_UV_OPT)
	// 流光扭曲 UV 操作
	DealGlobalUV(glowUV,_Glow);    
  #if defined (_USING_CD0DD_GLOW_OFFSET)
	glowUV += customGlowOffset * _GlowMap_ST.zw;
  #endif   
	// custom data
  #if defined (_USING_CD0DD_GLOW_THRESHOLD)
	glowProgress += customGlowProgress;
  #endif 
	DealGlowUV(glowUV);
	glowUV = glowUV + _GlowUVPanSpeed *_Time.y + finalDistortVal;
  #if defined(_USING_GLOW_UV_DISTORT)
	DealUVDistort(rawUV, _Glow);
  #endif
 #endif // UV_OPT

 #if defined(_USING_GLOBAL_UV_DISTORT)
	finalDistortVal += globalNoiseValue * _GlowDistortGlobalFactor;
 #endif
	
	// calc glow 
    half4 glowTexVal = SAMPLE_TEXTURE2D(_GlowMap, sampler_GlowMap, glowUV + float2(finalDistortVal,finalDistortVal)); 
    glowTexVal.rgb *= glowTexVal.a; // pre mul
	
	half3 glowCol = ColorRange(glowTexVal.rgb, glowProgress, _GlowSoftenFactor) * _GlowColor.rgb;
    glowCol *= _GlowColor.a;

	// apply mask								
    float2 glowMaskUV = rawUV * _GlowMaskMap_ST.xy + _GlowMaskMap_ST.zw;
    float4 glowMask =  SAMPLE_TEXTURE2D(_GlowMaskMap, sampler_GlowMaskMap, glowMaskUV).rgba; 
    glowCol *= glowMask.r*glowMask.a; 
	alpha = saturate(alpha + dot(float3(0.3, 0.4, 0.3), glowCol ) *  _GlowAlphaEnhanceFactor); 
	glowCol *= alpha;
	result += glowCol;  
#endif 
}

void _DoErase(inout float3 result,inout float alpha,float2 uvGlowErase,inout float eraseVal,float customEraseProgress){
#if defined(_USING_ERASE_FEATURE)
	// A通道擦除部分
	float eraseProgress = _EraseProgress;
  #if defined (_USING_CD0DD_ERASE_PROGRESS)
    eraseProgress += customEraseProgress ;
  #endif
	eraseVal = DoErase(eraseProgress, uvGlowErase, _EraseSoftenFactor, alpha, _EraseUVRotation);
	alpha *= eraseVal;
#endif
}
void _DoCameraOpt(inout float3 result,inout float alpha,float4 projectedPosition){

#if defined(_USING_SOFTPARTICLES)
	alpha *= DoSoftParticles(SOFT_PARTICLE_NEAR_FADE, SOFT_PARTICLE_INV_FADE_DISTANCE, projectedPosition);
#endif

#if defined(_USING_CAMERA_FADING)
	alpha *= DoCameraFade(CAMERA_NEAR_FADE, CAMERA_INV_FADE_DISTANCE, projectedPosition);
#endif

}
float _DoMask(float2 rawUV){
#if defined(_USING_MASKMAP)
	float globalNoiseValue = 1;
    float finalDistortVal = 0; 
	float2 distortUV = rawUV; 
 #if defined(_USING_MASK_UV_OPT)
	DealMaskUV(distortUV); 
	distortUV = rawUV + _MaskUVPanSpeed.xy * _Time.y; 
  #if defined(_USING_MASK_UV_DISTORT)
	DealUVDistort(distortUV,  _Mask);
  #endif
 #endif
	float4 maskCol = SAMPLE_TEXTURE2D(_MaskMap, sampler_MaskMap, distortUV + finalDistortVal);
	return maskCol.r * maskCol.a;   // pre mul
#else 
	return 1;
#endif
	 
}
void _DoMain(inout float2 rawUV){
	DealGlobalUV(rawUV,_Main); 
#if defined(_USING_MAIN_UV_OPT)
	float globalNoiseValue = 1;
    float finalDistortVal = 0; 
	DealMainUV(rawUV); 
	#if defined(_USING_MAIN_UV_DISTORT)
		DealUVDistort(rawUV, _Main);
		rawUV += finalDistortVal;
	#endif 
	rawUV = rawUV + _MainUVPanSpeed.xy * _Time.y; 
#endif
}

half4 fragParticle(v2f input) : SV_Target
{
    float debugVal =0;
	UNITY_SETUP_INSTANCE_ID(input);
	
	// keep rawUV
	float2 rawUV = input.uvMainMask.xy; 
	float2 mainUV = rawUV; 

	//0. sample Custom Data
	float2 cusDataMainOffset_GlowOffset = 0;
	float4 cusDataDissolve_Cutout_Glow_GlobalDistort = 0;
	#if defined(_USING_CUSTOM_DATA0)
	cusDataDissolve_Cutout_Glow_GlobalDistort =  input.cusDataDissolve_Cutout_Glow_GlobalDistort;
	cusDataMainOffset_GlowOffset =  input.cusDataMainOffset_GlowOffset;
	#endif 
	
	// 1. texture sheet
#if defined(_USING_TEXTURE_SHEET)
    mainUV = DoTextureSheet( mainUV, _TextureSheetSpeed,_TextureSheetSize,_TextureSheetTopFirst,_TextureSheetLeftFirst,_TextureSheetIsLoop,_TextureSheetProgress);
#endif
	// 2. CustomData MainOffset
#if defined (_USING_CD0DD_MAIN_OFFSET)
	mainUV += cusDataMainOffset_GlowOffset.x * _MainTex_ST.zw;
#endif

	// 3. CustomData NoiseIntensity
	float customIntensity = 1;
  #if defined (_USING_CD0DD_DISTORT_INTENSITY)
	customIntensity += cusDataDissolve_Cutout_Glow_GlobalDistort.w-1;
	//return input.cusDataDissolve_Cutout_Glow_GlobalDistort.w;
  #endif

	// 4. UV Distort
	half globalNoiseValue = 1 * customIntensity;
	half uvDistort = 0;
#if defined(_USING_GLOBAL_UV_DISTORT) 
	float2 noiseUV = TRANSFORM_TEX(rawUV, _GlobalDistortMap);  
	DealGlobalUV(noiseUV,_Global);  
	float noiseFactor = _GlobalDistortIntensity;
	globalNoiseValue = customIntensity* CalcNoiseValue(noiseUV,TEXTURE2D_ARGS(_GlobalDistortMap, sampler_GlobalDistortMap),_GlobalDistortUVRotateSpeed,_GlobalDistortUVPanSpeed,noiseFactor);
	uvDistort = globalNoiseValue * _MainDistortGlobalFactor;
#endif

	_DoMain(mainUV);
	mainUV += uvDistort; //主贴图纹理扭曲

    half maskVal = 1;
	//Mask部分(对整体生效)
#if defined(_USING_MASKMAP)
	maskVal = _DoMask(input.uvMainMask.zw);
#endif

	// 序列帧融合
	float3 blendUv = float3(0, 0, 0);
	half4 albedo = DoBlendTexture(TEXTURE2D_ARGS(_MainTex, sampler_MainTex), mainUV, blendUv) * _Color; 
	
	half alpha = albedo.a;
	half3 result = albedo.rgb;
	alpha *= maskVal;  
    float4 projectedPosition = float4(0,0,0,0);
#if defined(_NEED_PROJECT_POSITION)
    projectedPosition = input.projectedPosition;
#endif

	
	_DoDissolve(result, alpha, rawUV, cusDataDissolve_Cutout_Glow_GlobalDistort.x,globalNoiseValue);
	
#if defined(_USING_GLOW)  
    _DoGlow(result,alpha,rawUV, input.uvGlowErase.xy, cusDataMainOffset_GlowOffset.y,cusDataDissolve_Cutout_Glow_GlobalDistort.z,globalNoiseValue);
#endif

	float eraseVal =1;
#if defined(_USING_ERASE_FEATURE)  
    _DoErase(result,alpha,input.uvGlowErase.zw,eraseVal,cusDataDissolve_Cutout_Glow_GlobalDistort.y);
#endif
	result *= input.color.rgb;   
	alpha *= input.color.a;

#if defined(_USING_AIR_DISTORT)
	_DoAirDistort(result, alpha, projectedPosition);
#endif
	_DoCameraOpt(result,alpha,projectedPosition);

#if defined(_USING_FRESNEL)
	half3 viewDirWS = SafeNormalize(GetCameraPositionWS() - input.positionWS.xyz);
	half fresnelVal  = DoFresnel(input.normalWS, viewDirWS, _FresnelPower,_FresnelRevertFactor); 
	float4 fresnelCol = lerp(_FresnelTransitionColor, _FresnelColor, pow(fresnelVal,_FresnelTransitionPower)) * fresnelVal;
	result += fresnelCol.rgb * eraseVal * input.color.a ;
	alpha *= lerp(fresnelVal, 1, fresnelCol.a);
#endif

#if defined(_USING_FOG)
	result = lerp(MixFog(result, input.positionWS.w), result, _FinalFogIntensity);
#endif

#if defined(_USING_ALPHA_CUTOUT)
    clip(alpha - _AlphaCutout);
#endif
	return half4(result, alpha);
} 

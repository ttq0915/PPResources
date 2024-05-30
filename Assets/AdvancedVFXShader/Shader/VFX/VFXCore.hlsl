// Copyright 2022 谭杰鹏. All Rights Reserved //https://github.com/JiepengTan 
// https://space.bilibili.com/481436151

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Packing.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonMaterial.hlsl"

#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

TEXTURE2D(_CameraDepthTexture); SAMPLER(sampler_CameraDepthTexture);  
TEXTURE2D(_CameraOpaqueTexture); SAMPLER(sampler_CameraOpaqueTexture);
			
float2 DoTextureSheet(float2 uv ,float speed,float2 texRowCol,float isTopDown, float isLeftRight,float isLoop, float curProgress){
#if defined(_USING_TEXTURE_SHEET)
    float curIdx = floor(_Time.y * speed);
	curIdx = lerp(floor(texRowCol.x*texRowCol.y * curProgress), curIdx, isLoop);
    float row =  floor(curIdx / texRowCol.y);
    float col =  floor(curIdx % texRowCol.y);
    row = lerp(row, texRowCol.x-1 - row, isTopDown);
    col = lerp(texRowCol.y-1 - col, col, isLeftRight);
    
    uv.x = (uv.x + col) / texRowCol.y;
    uv.y = (uv.y + row) / texRowCol.x;
    return uv;
#else 
    return uv;
#endif
}

float DoSoftParticles(float near, float far, float4 projection)
{
    float fade = 1;
    if (near > 0.0 || far > 0.0)
    {
        float sceneZ = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, sampler_CameraDepthTexture, projection.xy / projection.w), _ZBufferParams);
        float thisZ = LinearEyeDepth(projection.z / projection.w, _ZBufferParams);
        fade = saturate(far * ((sceneZ - near) - thisZ));
    }
    return fade;
}

half DoCameraFade(float near, float far, float4 projection)
{
    float thisZ = LinearEyeDepth(projection.z / projection.w, _ZBufferParams);
    return saturate((thisZ - near) * far);
}

half3 AlphaModulate1(half3 albedo, half alpha)
{
#if defined(_ALPHAMODULATE_ON)
    return lerp(half3(1.0h, 1.0h, 1.0h), albedo, alpha);
#else
    return albedo * alpha;
#endif
}

#define _Deg2Rad 0.01745329 //PI/180.
float2 DoRotate2D(float2 uv, float deg){
    deg *= _Deg2Rad;
    float s = sin(deg); 
    float c = cos(deg);  
    uv -= 0.5;
    return mul(float2x2(c,-s,s,c),uv) + 0.5;  
}

// Sample a texture and do blending for texture sheet animation if needed
half4 DoBlendTexture(TEXTURE2D_PARAM(_Texture, sampler_Texture), float2 uv, float3 blendUv)
{
    //TODO 增加序列帧融合
    half4 color = SAMPLE_TEXTURE2D(_Texture, sampler_Texture, uv);
    return color;
}
// 采样Grab Texture
//half3 DoGrabTexture(float2 uv)
//{
//    return SAMPLE_TEXTURE2D_LOD(_CameraOpaqueTexture, sampler_CameraOpaqueTexture, uv, 0);
//}

// 采样噪波
half DoSampleNoise(half4 uvSpeed, TEXTURE2D_PARAM( _Texture, sampler_Texture),float2 uv,  half3 wordPos)
{
    //uv  = lerp (uv, wordPos.xy, offset2WorldSpeed1.z);   //噪波采样沿世界坐标运动
    uv = float2(uvSpeed.x * _Time.y + uv.x, uvSpeed.y * _Time.y + uv.y);   
    half4 color = SAMPLE_TEXTURE2D(_Texture, sampler_Texture, uv );
    color.x *= color.a;
    return color.x;
}

float Remap(float oa,float ob,float na,float nb,float val){
	return (val-oa)/(ob-oa) * (nb-na) + na;
}
//溶解部分
float4 DoDissolve(half clipVal, half noiseValue, half edgeLength, half3 edgeColor, half3 rawColor)
{
    clip(noiseValue - clipVal);
    
    float lerpVal =saturate(Remap(0, edgeLength,0,1,noiseValue-clipVal));
    float3 col = lerp(edgeColor,rawColor, saturate(lerpVal*2-1) );
    float alpha = saturate(lerpVal*2);
    return float4(col,alpha);
}


// 替换颜色
half3 ColorRange(float3 color, float threshold, float fuzziness)
{
    return color* saturate((length(color) - threshold) / max(fuzziness, 0.001)); 
}


half DoErase(half eraseProgress, float2 uv, float edgeFade, half alpha, half direction)
{
    half val = 0;
    edgeFade = min(1, edgeFade + 0.001);   
#if defined(_USING_ERASE_LINEAR)
    val = smoothstep(0, edgeFade, saturate(uv.x)- eraseProgress);  
#elif defined(_USING_ERASE_CIRCLE)
    half aa1 = saturate(distance(0.5,uv.xy)/0.70711);
    aa1 = lerp((aa1),(1 -aa1),direction /360);
    val = smoothstep(0, edgeFade, aa1 - eraseProgress);
#elif defined(_USING_ERASE_ANGLE)
    float2 diff = uv -0.5;
    float dt = diff.y / max(0.001,length(diff));
    float angle = 1-abs(atan2(diff.x, diff.y) / PI );
    val = smoothstep(0, edgeFade, angle- (1-eraseProgress)); 
    //half aa1 = saturate(distance(0.5,uv.xy)/0.70711);
    //val = smoothstep(0, edgeFade, saturate(alpha - eraseProgress));
#endif
    return val;
}
float2 DoTwirlPolar(float2 uv, float strength, float radialScale, float lenScale,float lerpVal)
{
    float2 delta = uv - 0.5;
    float deg = strength * length(delta);
    float c = cos(deg);
    float s = sin(deg);
    uv = mul(float2x2(c,-s,s,c),delta);
    float len = length(uv) * lenScale;
    float angle = atan2(uv.x, uv.y) / PI * radialScale;
    return lerp(uv + 0.5, float2(len, angle), lerpVal ) ;
}


float2 DoTwirl(float2 uv, float2 center, float2 offset,float strength)
{
    float2 delta = uv - center;
    float deg = strength * length(delta) ;
    float c = cos(deg);
    float s = sin(deg);
    uv = mul(float2x2(c,-s,s,c),delta);
    return uv + center + offset;
}
float2 DoPolarinates(float2 uv, float2 center, float radialScale, float lenScale, half lerpVal)
{
    float2 delta = uv - center;
    float len = length(delta) * lenScale;
    float angle = atan2(delta.x, delta.y) / PI * radialScale ;
    return lerp(uv, float2(len, angle), lerpVal );
} 


//Fresnel 
half4 DoFresnel(float3 normal, float3 viewDir, float power, float revertFactor)
{
    half aa =  saturate(dot(normalize(normal), (viewDir)));
    aa = lerp( aa,(1 - aa),revertFactor);
    return pow(1-aa, power);
}


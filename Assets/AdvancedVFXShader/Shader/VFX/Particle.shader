Shader "GamesTan/VFX/Particle"
{
	Properties
	{
	    [Toggle] _UseGlobalUVOpt("操控UV", Float) = 0.0
        //[Header(Twirl)]
		[Toggle(_USING_GLOBAL_TWIRL)] _UseGlobalTwirl("全局漩涡扭曲", Float) = 0.0
		_GlobalTwirlCenter("漩涡中心UV",vector) = (0.5,0.5,0,0)
		_GlobalTwirlIntensity("漩涡强度",Range(-50,50)) = 0.5
		_GlobalTwirlGlobalFactor("全局漩涡强度系数",Range(0,1)) = 1
	
        //[Header(Polar)]
		[Toggle(_USING_GLOBAL_POLAR_COORD)] _UseGlobalPolar("全局极坐标", Float) = 0.0
		_GlobalPolarCenter("极坐标中心点",vector) = (0.5,0.5,0,0)
		_GlobalPolarRadialFactor("极坐标角度缩放",float) = 1
		_GlobalPolarLengthFactor("极坐标长度缩放",float) = 1
        _GlobalPolarIntensity("极坐标强度",Range(0,1)) = 1
		_GlobalPolarGlobalFactor("全局极坐标强度系数",Range(0,1)) = 1
		 

        //[Header(Noise)]
	    [Toggle(_USING_GLOBAL_UV_DISTORT)] _UseGlobalDistort("全局UV扭曲", Float) = 0.0
	    _GlobalDistortMap("UV扭曲贴图", 2D) = "white" {}
		_GlobalDistortUVPanSpeed("UV扭曲变化速度", vector) = (0.5,0.5,0,0)
		_GlobalDistortUVRotateSpeed("UV扭曲旋转速度",Range(-2,2)) = 0.0
		_GlobalDistortIntensity("UV扭曲强度",Range(0,10)) =0.5
		_GlobalDistortGlobalFactor("全局扭曲强度系数",Range(0,1)) = 1


	    [Toggle] _UseMainUVOpt("操控UV", Float) = 0.0
		[Header(UVDistort)]
	    _UseMainDistort("UV扭曲", Float) = 0.0
	    _MainDistortMap("UV扭曲贴图", 2D) = "white" {}
		_MainDistortUVPanSpeed("UV扭曲变化速度", vector) = (0.5,0.5,0,0)
		_MainDistortUVRotateSpeed("UV扭曲旋转速度",Range(-2,2)) = 0.0
		_MainDistortIntensity("UV扭曲强度",Range(0,10)) =0.5
		_MainDistortGlobalFactor("全局扭曲强度系数",Range(0,1)) = 1

		_UseMainTwirl("漩涡扭曲", Float) = 0.0
		_MainTwirlCenter("漩涡中心UV",vector) = (0.5,0.5,0,0)
		_MainTwirlIntensity("漩涡强度",Range(-50,50)) = 0.5
		_MainTwirlGlobalFactor("全局漩涡强度系数",Range(0,1)) = 1
	
		_UseMainPolar("极坐标", Float) = 0.0
		_MainPolarCenter("极坐标中心点",vector) = (0.5,0.5,0,0)
		_MainPolarRadialFactor("极坐标角度缩放",float) = 1
		_MainPolarLengthFactor("极坐标长度缩放",float) = 1
        _MainPolarIntensity("极坐标强度",Range(0,1)) = 1
		_MainPolarGlobalFactor("全局极坐标强度系数",Range(0,1)) = 1
		

	    [Toggle]_UseMaskUVOpt("操控UV", Float) = 0.0
		[Header(UVDistort)]
	    _UseMaskDistort("UV扭曲", Float) = 0.0
	    _MaskDistortMap("UV扭曲贴图", 2D) = "white" {}
		_MaskDistortUVPanSpeed("UV扭曲变化速度", vector) = (0.5,0.5,0,0)
		_MaskDistortUVRotateSpeed("UV扭曲旋转速度",Range(-2,2)) = 0.0
		_MaskDistortIntensity("UV扭曲强度",Range(0,10)) =0.5
		_MaskDistortGlobalFactor("全局扭曲强度系数",Range(0,1)) = 1

		_UseMaskTwirl("漩涡扭曲", Float) = 0.0
		_MaskTwirlCenter("漩涡中心UV",vector) = (0.5,0.5,0,0)
		_MaskTwirlIntensity("漩涡强度",Range(-50,50)) = 0.5
		_MaskTwirlGlobalFactor("全局漩涡强度系数",Range(0,1)) = 1
	
		_UseMaskPolar("极坐标", Float) = 0.0
		_MaskPolarCenter("极坐标中心点",vector) = (0.5,0.5,0,0)
		_MaskPolarRadialFactor("极坐标角度缩放",float) = 1
		_MaskPolarLengthFactor("极坐标长度缩放",float) = 1
        _MaskPolarIntensity("极坐标强度",Range(0,1)) = 1
		_MaskPolarGlobalFactor("全局极坐标强度系数",Range(0,1)) = 1
		
	    _UseMainUVOpt("操控UV", Float) = 0.0

	    [Toggle]_UseGlowUVOpt("操控UV", Float) = 0.0
		[Header(UVDistort)]
	    _UseGlowDistort("UV扭曲", Float) = 0.0
	    _GlowDistortMap("UV扭曲贴图", 2D) = "white" {}
		_GlowDistortUVPanSpeed("UV扭曲变化速度", vector) = (0.5,0.5,0,0)
		_GlowDistortUVRotateSpeed("UV扭曲旋转速度",Range(-2,2)) = 0.0
		_GlowDistortIntensity("UV扭曲强度",Range(0,10)) =0.5
		_GlowDistortGlobalFactor("全局扭曲强度系数",Range(0,1)) = 1
		
		_UseGlowTwirl("漩涡扭曲", Float) = 0.0
		_GlowTwirlCenter("漩涡中心UV",vector) = (0.5,0.5,0,0)
		_GlowTwirlIntensity("漩涡强度",Range(-50,50)) = 0.5
		_GlowTwirlGlobalFactor("全局漩涡强度系数",Range(0,1)) = 1
	
		_UseGlowPolar("极坐标", Float) = 0.0
		_GlowPolarCenter("极坐标中心点",vector) = (0.5,0.5,0,0)
		_GlowPolarRadialFactor("极坐标角度缩放",float) = 1
		_GlowPolarLengthFactor("极坐标长度缩放",float) = 1
        _GlowPolarIntensity("极坐标强度",Range(0,1)) = 1
		_GlowPolarGlobalFactor("全局极坐标强度系数",Range(0,1)) = 1
		
	
	    [Toggle]_UseDissolveUVOpt("操控UV", Float) = 0.0
		[Header(UVDistort)]
	    _UseDissolveDistort("UV扭曲", Float) = 0.0
	    _DissolveDistortMap("UV扭曲贴图", 2D) = "white" {}
		_DissolveDistortUVPanSpeed("UV扭曲变化速度", vector) = (0.5,0.5,0,0)
		_DissolveDistortUVRotateSpeed("UV扭曲旋转速度",Range(-2,2)) = 0.0
		_DissolveDistortIntensity("UV扭曲强度",Range(0,10)) =0.5
		_DissolveDistortGlobalFactor("全局扭曲强度系数",Range(0,1)) = 1

		
		_UseDissolveTwirl("漩涡扭曲", Float) = 0.0
		_DissolveTwirlCenter("漩涡中心UV",vector) = (0.5,0.5,0,0)
		_DissolveTwirlIntensity("漩涡强度",Range(-50,50)) = 0.5
		_DissolveTwirlGlobalFactor("全局漩涡强度系数",Range(0,1)) = 1
	
		_UseDissolvePolar("极坐标", Float) = 0.0
		_DissolvePolarCenter("极坐标中心点",vector) = (0.5,0.5,0,0)
		_DissolvePolarRadialFactor("极坐标角度缩放",float) = 1
		_DissolvePolarLengthFactor("极坐标长度缩放",float) = 1
        _DissolvePolarIntensity("极坐标强度",Range(0,1)) = 1
		_DissolvePolarGlobalFactor("全局极坐标强度系数",Range(0,1)) = 1
		



		[HDR]_Color("Color", Color) = (1,1,1,1)
		_MainTex("主帖图", 2D) = "white" {}
	    _MainUVPanSpeed("走UV速度", vector) = (0,0,0,0)
		_MainUVRotation("UV旋转",Range(0,360)) = 0

        //[Header(Mask)]
		[Toggle(_USING_MASKMAP)] _UseMaskMap("遮罩", Float) = 0.0
		_MaskMap("遮罩贴图", 2D) = "white" {}
	    _MaskUVPanSpeed("走UV速度", vector) = (0,0,0,0)
		_MaskUVRotation("UV旋转",Range(0,360)) = 0.0
		

		
		[Toggle(_USING_TEXTURE_SHEET)] _UseTextureSheet("序列帧", Float) = 0.0
	    _TextureSheetSize("序列帧 行 列", vector) = (4,4,0,0)
	    _TextureSheetSpeed("序列帧播放速度(x帧/每秒)", int) = 15
	    [Toggle]_TextureSheetLeftFirst("序列帧 从左到右", int) = 1 
	    [Toggle]_TextureSheetTopFirst("序列帧 从上到下", int) = 1
	    [Toggle]_TextureSheetIsLoop("序列帧 是否循环播放", int) = 1
	    _TextureSheetProgress("序列帧 是否循环播放", Range(0,0.999)) = 1




        //[Header(Erase)]
		_UseErase("擦除", Float) = 0.0 /*[KeywordEnum(None, Linear, Mirror, Mask)] */
		_EraseSoftenFactor("擦除边缘柔化",Range(0,1)) = 0.05
		_EraseUVRotation("擦除方向",Range(0,360)) = 0
		_EraseProgress("擦除进度",Range(0,1)) = 0

		
        //[Header(Glow)]
		[Toggle(_USING_GLOW)] _UseGlow("流光", Float) = 0.0
		_GlowMap("流光贴图", 2D) = "white" {}
	    _GlowUVPanSpeed("走UV速度", vector) = (0,0,0,0)
		_GlowUVRotation("UV旋转",Range(0,360)) = 0.0

		_GlowAlphaEnhanceFactor("流光Alpha强化系数",Range(0,0.5)) = 0
		_GlowSoftenFactor("流光柔化系数",Range(0,1)) = 0
		[HDR]_GlowColor("流光颜色",Color) = (1,0.88,1,1)
		_GlowThreshold("流光阈值",Range(0,3)) = 0
		[Header(GlowMask)]
		_GlowMaskMap("流光遮罩贴图", 2D) = "white" {}
		 

        //[Header(Dissolve)]
		[Toggle(_USING_DISSOLVE)] _UseDissolve("溶解 ", Float) = 0.0
		_DissolveMap("溶解图", 2D) = "white" {}
		_DissolveUVRotation("UV旋转",Range(0,360)) = 0
	    _DissolveUVPanSpeed("走UV速度", vector) = (0,0,0,0)
		
		[Toggle(_USING_DISSOLVE_MASK)] _UseDissolveMask("溶解遮罩", Float) = 0.0
		_DissolveMaskMap("溶解遮罩图", 2D) = "white" {}
		_DissolveMaskUVRotation("UV旋转",Range(0,360)) = 0
		
		[HDR]_DissolveEdgeColor("溶解颜色", Color) = (3,3,1,1)
		_DissolveEdgeRange("溶解边缘范围", Range(0,1)) = 0.1
		_DissolveThreshold("溶解进度",Range(0,1)) = 0.2	
			
		
        //[Header(Distort)]
		[Toggle(_USING_AIR_DISTORT)] _UseAirDistort("热扭曲 (使用主帖图)", Float) = 0.0
		[HDR]_AirDistortColor("热扭曲颜色",Color) = (1,1,1,1)
		_AirDistortIntensity("热扭曲强度", Range(0,1)) = 0.5
			 
			
        //[Header(Fresnel)]
		[Toggle(_USING_FRESNEL)] _UseFresnel("菲涅尔", Float) = 0.0   
		[HDR]_FresnelColor("菲涅尔颜色" ,COLOR) =(1,1,1,1)
		[HDR]_FresnelTransitionColor("菲涅尔过渡颜色" ,COLOR) =(1,1,1,1)
		[HDR]_FresnelTransitionPower("菲涅尔过渡系数" ,Range(0.01,10)) =1
		
		_FresnelPower("菲涅尔强度",Range(0.01,10)) = 1
		_FresnelRevertFactor("菲涅尔反转系数",  Range(0,1)) = 1
		
		_AlphaCutout("AlphaCutout",  Range(0,1)) = 0.5

        [Header(Fog)]
		_FinalFogIntensity("Fog intensity",Range(0,1))  = 0
        [Header(Particle)]
		[Toggle(_USING_SOFTPARTICLES)] _UseSoftParticle("开启SoftParticle", Float) = 0.0
		_SoftParticlesNearFadeDistance("Soft Particles Near Fade", Float) = 0.0
		_SoftParticlesFarFadeDistance("Soft Particles Far Fade", Range(0.001,15)) = 1.0
		
		[Toggle(_USING_CAMERA_FADING)] _UseCameraFade("开启CameraFade", Float) = 0.0
		_CameraNearFadeDistance("Camera Near Fade", Float) = 1.0
		_CameraFarFadeDistance("Camera Far Fade", Range(0.001,15)) = 2.0
		
		_UseCustomData("开启 CustomData", Float)    = 0   
		_UseCustomData1("CustomData1 用途", Float) = 0   
		_UseCustomData2("CustomData2 用途", Float) = 0   
		_UseCustomData3("CustomData3 用途", Float) = 0   
		_UseCustomData4("CustomData4 用途", Float) = 0   
		
		[Toggle(_USING_FLIPBOOK_BLENDING)] _UseFlipbookBlending("_UseFlipbookBlending", Float) = 0.0   
		
		// -------------------------------------
		// Hidden properties - Generic  通用的隐藏属性
		[Header(BlendMode)]
		[Toggle] _ZWrite("ZWrite", Float) = 0.0
		[HideInInspector] _Blend("混合模式", Float) = 0.0
        [HideInInspector] _BlendOp ("__blendop", Float) = 0.0
		[HideInInspector] _SrcBlend("__src", Float) = 1.0
		[HideInInspector] _DstBlend("__dst", Float) = 0.0
		[HideInInspector] _ZTest("ZTest", Float) = 4.0
		[HideInInspector] _Cull("Culling", Float) = 0
        [HideInInspector] _StencilComp("模板测试", Float) = 0.0

	}

	SubShader
	{
		Tags{"RenderType" = "Opaque" "IgnoreProjector" = "True" "PreviewType" = "Plane" "PerformanceChecks" = "False" "RenderPipeline" = "UniversalPipeline""Queue" = "Transparent+100"}

		// ------------------------------------------------------------------
		//  Forward pass.   
		Pass
		{
			Name "ForwardLit"
			BlendOp[_BlendOp]   
			Blend [_SrcBlend][_DstBlend]
			ZWrite [_ZWrite]
        	ZTest [_ZTest]
        	Cull [_Cull]

			HLSLPROGRAM
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x
			#pragma target 3.0

			// -------------------------------------
			// Material Keywords
			

			#pragma shader_feature __ _USING_TEXTURE_SHEET	// 序列帧
			#pragma shader_feature __ _USING_MASKMAP	 	// 遮罩
			#pragma shader_feature __ _USING_GLOW    	// 流光
			#pragma shader_feature __ _USING_DISSOLVE    	// 溶解
			#pragma shader_feature __ _USING_DISSOLVE_MASK  // 溶解
			#pragma shader_feature __ _USING_FRESNEL     	// 菲涅尔
			#pragma shader_feature __ _USING_AIR_DISTORT  		// 扭曲
			#pragma shader_feature __ _USING_ERASE_NONE _USING_ERASE_LINEAR _USING_ERASE_CIRCLE _USING_ERASE_ANGLE    //线性擦除  径向擦除  MASK擦除
			

			// 极坐标等属性操作
			// 全局
			#pragma shader_feature __ _USING_GLOBAL_UV_OPT       	// UV 操作
			#pragma shader_feature __ _USING_GLOBAL_TWIRL       	// 漩涡
			#pragma shader_feature __ _USING_GLOBAL_POLAR_COORD 	// 极坐标
			#pragma shader_feature __ _USING_GLOBAL_UV_DISTORT      // UV 扭曲

			#pragma shader_feature __ _USING_MAIN_UV_OPT
			#pragma shader_feature __ _USING_MAIN_TWIRL
			#pragma shader_feature __ _USING_MAIN_POLAR_COORD
			#pragma shader_feature __ _USING_MAIN_UV_DISTORT

			#pragma shader_feature __ _USING_MASK_UV_OPT
			#pragma shader_feature __ _USING_MASK_TWIRL
			#pragma shader_feature __ _USING_MASK_POLAR_COORD
			#pragma shader_feature __ _USING_MASK_UV_DISTORT

			#pragma shader_feature __ _USING_DISSOLVE_UV_OPT
			#pragma shader_feature __ _USING_DISSOLVE_TWIRL
			#pragma shader_feature __ _USING_DISSOLVE_POLAR_COORD
			#pragma shader_feature __ _USING_DISSOLVE_UV_DISTORT

			#pragma shader_feature __ _USING_GLOW_UV_OPT
			#pragma shader_feature __ _USING_GLOW_TWIRL
			#pragma shader_feature __ _USING_GLOW_POLAR_COORD 
			#pragma shader_feature __ _USING_GLOW_UV_DISTORT



			// 自定义特效数据
			#pragma shader_feature __ _USING_CUSTOM_DATA1 _USING_CUSTOM_DATA2 _USING_CUSTOM_DATA3 _USING_CUSTOM_DATA4	
			// Custom Data  1 溶解 2擦除 3流光阈值 4 UV扭曲  5 主贴图 offset系数  6流光贴图 offset系数
			#pragma shader_feature __ _USING_CD1DD_DISSOLVE_THRESHOLD _USING_CD1DD_ERASE_PROGRESS _USING_CD1DD_GLOW_THRESHOLD _USING_CD1DD_DISTORT_INTENSITY _USING_CD1DD_MAIN_OFFSET _USING_CD1DD_GLOW_OFFSET	
			#pragma shader_feature __ _USING_CD2DD_DISSOLVE_THRESHOLD _USING_CD2DD_ERASE_PROGRESS _USING_CD2DD_GLOW_THRESHOLD _USING_CD2DD_DISTORT_INTENSITY _USING_CD2DD_MAIN_OFFSET _USING_CD2DD_GLOW_OFFSET		
			#pragma shader_feature __ _USING_CD3DD_DISSOLVE_THRESHOLD _USING_CD3DD_ERASE_PROGRESS _USING_CD3DD_GLOW_THRESHOLD _USING_CD3DD_DISTORT_INTENSITY _USING_CD3DD_MAIN_OFFSET _USING_CD3DD_GLOW_OFFSET	
			#pragma shader_feature __ _USING_CD4DD_DISSOLVE_THRESHOLD _USING_CD4DD_ERASE_PROGRESS _USING_CD4DD_GLOW_THRESHOLD _USING_CD4DD_DISTORT_INTENSITY _USING_CD4DD_MAIN_OFFSET _USING_CD4DD_GLOW_OFFSET




			// Particle Keywords
			#pragma shader_feature __ _USING_SOFTPARTICLES	 	 // 软粒子
			#pragma shader_feature __ _USING_CAMERA_FADING		 // 相机虚化		 
			#pragma shader_feature __ _USING_FLIPBOOK_BLENDING	 // 相机虚化		 
			#pragma shader_feature __ _USING_ALPHA_CUTOUT	 // 相机虚化		

			// Unity defined keywords 
			#define FOG_EXP2 1
			
			#include "ParticlePass.hlsl"

			#pragma vertex vertParticle
			#pragma fragment fragParticle

			ENDHLSL
		}// end pass
	}// end sub shader
	CustomEditor "GamesTan.ArtTools.AdvancedVFXShader.ParticleShaderGUI"
}

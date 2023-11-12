Shader "Custom/Intersection"
{
    Properties
    {
        _Color("Color", Color) = (1, 1, 1, 1)
        _IntersectionColor("Intersection Color", Color) = (0, 0, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Transparent" "RenderPipeline"="UniversalPipeline" }
        
        Pass
        {
            Name "IntersectionUnlit"
            Tags { "LightMode"="SRPDefaultUnlit" }
            
            Cull Back
            Blend One Zero
            ZTest LEqual
            ZWrite On
            
            HLSLPROGRAM
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"

            #pragma vertex vert
            #pragma fragment frag

            float4 _Color;
            float4 _IntersectionColor;

            struct Attributes
            {
                float4 positionOS : POSITION;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float3 positionWS : TEXCOORD0;
            };

            Varyings vert(Attributes input)
            {
                Varyings output;
                output.positionHCS = TransformObjectToHClip(input.positionOS.xyz);
                output.positionWS = TransformObjectToWorld(input.positionOS.xyz);
                return output;
            }

            float4 frag(Varyings input) : SV_Target
            {
                float2 screenUV = GetNormalizedScreenSpaceUV(input.positionHCS);

                float depthTexture = SampleSceneDepth(screenUV);
                float linearDepthTexture = LinearEyeDepth(depthTexture, _ZBufferParams);
                float linearDepthObject = LinearEyeDepth(input.positionWS, UNITY_MATRIX_V);

                float lerpValue = pow(1 - saturate(linearDepthTexture - linearDepthObject), 15);

                float4 colObject = _Color;
                float4 colIntersection = _IntersectionColor;
                return lerp(colObject, colIntersection, lerpValue);
            }

            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
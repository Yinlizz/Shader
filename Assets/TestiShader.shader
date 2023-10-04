Shader "Custom/TestiShader"
{
    Properties
    {
        _Color("Color", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline"="UniversalPipeline" "Queue"="Geometry" }

        Pass
        {
            Name "OmaPass"
            Tags
            {
                "LightMode"="UniversalForward"
            }
            
            HLSLPROGRAM
            #pragma vertex Vert
            #pragma fragment Frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            
            struct Attributes
            {
                float3 positionsOS : POSITION;
                float3 normalOS : NORMAL;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float3 positionWS : TEXCOORD0;
                float3 normalWS : TEXCOORD1;
            };

            CBUFFER_START(UnityPerMaterial)
            float4 _Color;
            CBUFFER_END
            
            Varyings Vert(const Attributes input)
            {
                Varyings output;

                output.positionHCS = TransformObjectToHClip(input.positionsOS);
                output.positionWS = TransformObjectToWorld(input.positionsOS);
                output.normalWS = mul((float3x3)unity_WorldToObject, input.normalOS);
                
                return output;
            }

            float4 Frag(const Varyings input) : SV_TARGET
            {
                float lightIntensity = dot(input.normalWS, normalize(float3(1, 1, 1)));
                return _Color * lightIntensity;
                //return _Color * clamp(input.positionWS.x, 0, 1);
                //return _Color * input.positionWS.x
            }
            ENDHLSL
        }
    }
    FallBack "Diffuse"
}
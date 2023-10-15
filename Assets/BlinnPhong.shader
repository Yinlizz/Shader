Shader "Custom/BlinnPhong"
{
    Properties
    {
        _Color("Color", Color) = (1, 1, 1, 1)
        _Shininess("Shininess", Range(1, 256)) = 32
    }
    
    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "Queue" = "Geometry" }
        
        Pass 
        {
            Name "Forward Lit"
            Tags { "LightMode" = "UniversalForward" }
            
            HLSLPROGRAM
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            
            struct VertexInput
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
            };

            struct VertexOutput
            {
                float4 positionHCS : SV_POSITION;
                float3 positionWS : TEXCOORD0;
                float3 normalWS : TEXCOORD1;
            };

            float4 _Color;
            float _Shininess;

            #pragma vertex Vertex
            #pragma fragment Fragment

            VertexOutput Vertex(VertexInput input)
            {
                VertexOutput output;
                
                output.positionWS = TransformObjectToWorld(input.positionOS).xyz;
                output.normalWS = normalize(TransformObjectToWorldNormal(input.normalOS));
                output.positionHCS = TransformObjectToHClip(input.positionOS);

                return output;
            }

            float4 BlinnPhong(VertexOutput input) : SV_TARGET
            {
                Light mainLight = GetMainLight();
                float3 viewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
                
                float3 ambient = 0.1 * mainLight.color;
                
                float3 diffuse = saturate(dot(input.normalWS, mainLight.direction)) * mainLight.color;
                
                float3 halfDir = normalize(mainLight.direction + viewDirection);
                float3 specular = pow(saturate(dot(input.normalWS, halfDir)), _Shininess) * mainLight.color;

                return float4((ambient + diffuse + specular) * _Color.rgb, 1);
            }

            float4 Fragment(VertexOutput input) : SV_TARGET
            {
                return BlinnPhong(input);
            }

            ENDHLSL
        }
    }
}
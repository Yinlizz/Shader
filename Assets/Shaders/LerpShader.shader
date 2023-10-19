Shader "Custom/LerpShader" 
{
    Properties {
        _Texture1 ("Texture 1", 2D) = "white" {}
        _Texture2 ("Texture 2", 2D) = "white" {}
        _LerpValue ("Lerp Value", Range(0,1)) = 0.5
    }

    SubShader {
        // DepthOnly-passi
        Pass {
            Name "Depth"
            Tags { "LightMode" = "DepthOnly" }
            
            Cull Back
            ZTest LEqual
            ZWrite On
            ColorMask R
            
            HLSLPROGRAM
            #pragma vertex DepthVert
            #pragma fragment DepthFrag
            #include "DepthPass.hlsl"
            ENDHLSL
        }

        // DepthNormalsOnly-passi
        Pass {
            Name "Normals"
            Tags { "LightMode" = "DepthNormalsOnly" }
            
            Cull Back
            ZTest LEqual
            ZWrite On
            
            HLSLPROGRAM
            #pragma vertex DepthNormalsVert
            #pragma fragment DepthNormalsFrag
            #include "DepthNormalsPass.hlsl"
            ENDHLSL
        }

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _Texture1;
            sampler2D _Texture2;
            float _LerpValue;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            half4 frag (v2f i) : SV_Target {
                half4 color1 = tex2D(_Texture1, i.uv);
                half4 color2 = tex2D(_Texture2, i.uv);
                return lerp(color1, color2, _LerpValue);
            }
            ENDCG
        }
    }
}
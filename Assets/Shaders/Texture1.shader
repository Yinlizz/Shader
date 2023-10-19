Shader "Custom/Texture1" {
    Properties {
        _MainTex ("Main Texture", 2D) = "white" {}
        _Tiling ("Tiling", Vector) = (1,1,0,0)
        _Offset ("Offset", Vector) = (0,0,0,0)
        _TimeSpeed ("Time Speed", Vector) = (1,1,0,0)
    }

    SubShader {
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

            sampler2D _MainTex;
            float4 _Tiling;
            float4 _Offset;
            float4 _TimeSpeed;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                
                float2 tiling = _Tiling.xy;
                float2 offset = _Offset.xy + _Time.xy * _TimeSpeed.xy;

                o.uv = v.uv * tiling + offset;
                return o;
            }

            half4 frag (v2f i) : SV_Target {
                return tex2D(_MainTex, i.uv);
            }
            ENDCG
        }

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
    }
}
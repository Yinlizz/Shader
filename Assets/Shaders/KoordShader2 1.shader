Shader "Custom/KoordShader2"
{
    Properties
    {
        _Color("Color", Color) = (1, 1, 1, 1)
        _OffsetX("X Offset", Range(-1, 1)) = 0
        _OffsetY("Y Offset (World Space)", Range(-1, 1)) = 0
        _OffsetYViewSpace("Y Offset (View Space)", Range(-1, 1)) = 0
        _UseLocalCoordinates("Use Local Coordinates", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            Tags { "LightMode" = "UniversalForward" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 pos : POSITION;
            };

            float4 _Color;
            float _OffsetX;
            float _OffsetY;
            float _OffsetYViewSpace;
            float _UseLocalCoordinates;

            v2f vert(appdata v)
            {
                v2f o;
                float yOffset;
                if (_UseLocalCoordinates > 0) {
                    yOffset = _OffsetY + _OffsetYViewSpace * UnityObjectToViewPos(v.vertex).y;
                    v.vertex.x += _OffsetX;
                    v.vertex.y += yOffset;
                }
                else {
                    yOffset = 1.0 + _OffsetY + _OffsetYViewSpace * UnityObjectToViewPos(v.vertex).y;
                    v.vertex.x += 1.0 + _OffsetX;
                    v.vertex.y += yOffset;
                }
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            half4 frag(v2f i) : COLOR
            {
                return _Color;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
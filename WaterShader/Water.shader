Shader "Unlit/Water"
{
    Properties
    {
        _MainTex("Water", 2D) = "white" {}
        _Waves("Waves", Float) = 1.0
        _Speed("Speed", Float) = 0.2
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float _Speed;
            float _Waves;
            float4 _MainTex_ST;


            v2f vert(appdata v)
            {
                v.vertex.y += cos(v.uv.x * _Waves + _Time.y) * _Speed;
                v.vertex.y += sin(v.uv.y * _Waves / 2.0 + _Time.y) * _Speed;

                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);

            // apply fog
            UNITY_APPLY_FOG(i.fogCoord, col);
            return col;
        }
        ENDCG
    }
    }
}

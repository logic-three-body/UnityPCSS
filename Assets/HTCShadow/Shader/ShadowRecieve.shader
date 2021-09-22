Shader "HTCShadow/ShadowObject"
{
    Properties
    {
        _MainTex("Texture",2D)="white"{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        pass
        {
            CGPROGRAM
  			    #pragma vertex vert
			    #pragma fragment frag 
                #include "UnityCG.cginc"

                sampler2D _MainTex;
                float4 _MainTex_ST;

            
            struct v2f
            {
                float4 pos:SV_POSITION;
                float2 uv:TEXCOORD0;
                float4 projPos:TEXCOORD1;
                float2 depth:TEXCOORD2;
                float4 worldPos:TEXCOORD3;
            };

            float4x4 LightSpaceMatrix;//transform matrix to light space so that we can compare the depth
            sampler2D Light_DepthTexture;//depth map from light source

            v2f vert(appdata_full v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldPos=mul(unity_ObjectToWorld,v.vertex);
                o.projPos=mul(LightSpaceMatrix,o.worldPos);
                o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);
                return o;
            }

            fixed frag(v2f i):SV_Target
            {
                fixed MainColor = tex2D(_MainTex,i.uv);

                float current_depth = i.depth.x/i.depth.y;
                fixed depthRGBA = tex2Dproj(Light_DepthTexture,i.projPos);
                float light_cloest_depth = DecodeFloatRGBA(depthRGBA);
                float shadow = 0.0;
                shadow = current_depth > light_cloest_depth?1.0:0.0;//if current_depth < orginal depth in shadow map from light,then it should in the shadow part

                return (1-shadow)*MainColor;
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}

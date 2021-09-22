Shader "HTCShadow/ShadowMap"
{
//refer:https://www.cnblogs.com/lijiajia/p/7231605.html
//This shader's role is to capture the depth map from light source or light camera which we name it shadow map
    Properties
    {
        _MainTex("Texture",2D)="white"{}
    }
    SubShader
    {
        Tags{"RenderType"="Opaque"}
        
        pass
        {
            CGPROGRAM
                
                #pragma vertex vert
                #pragma fragment frag

                #include "UnityCG.cginc"

                struct vertex_data
                {
                    float4 vertex : POSITION;
                    float2 uv : TEXCOORD0;
                };

                struct v2f
                {
                    float uv : TEXCOORD0;
                    float4 vertex : SV_POSITION;
                    float2 depth : TEXCOORD1;
                };

                sampler2D _MainTex;
                float4 _MainTex_ST;

                v2f vert(vertex_data v)
                {
                    v2f o;
                    o.vertex=UnityObjectToClipPos(v.vertex);
                    o.uv=TRANSFORM_TEX(v.uv,_MainTex);
                    o.depth=o.vertex.zw;//For the Perspective division , 《Unity Gem》(入门精要) 13.1 and 4.6.8
                    return o;
                }

                fixed4 frag(v2f i):SV_Target
                {
                    float depth=i.depth.x/i.depth.y;//the same as z/w ,check the vert shader
                    //depth = depth*0.5+0.5;
                    //float depth=i.depth.x;//the same as z/w ,check the vert shader
                    fixed color = EncodeFloatRGBA(depth);//This function convert float value to RGBA color
                    return color;
                }


            ENDCG
        }
    }
    FallBack "Diffuse"
}

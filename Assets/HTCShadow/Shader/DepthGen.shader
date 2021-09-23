Shader "HTCShadow/DepthGen"
{
    Properties
    {

    }
    SubShader
    {
       pass
       {
        CGPROGRAM
            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag

            uniform sampler2D _CameraDepthTexture;//depth tex


        ENDCG
       }
    }
    FallBack "Diffuse"
}

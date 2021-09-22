using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightCamera : MonoBehaviour
{
    // Start is called before the first frame update
    Camera _LightCam;
    RenderTexture _RT;
    public Shader _shader;
    public Matrix4x4 sm = new Matrix4x4();

    public Transform lightTrans;//get light position

    void Start()
    {
        _LightCam = new GameObject().AddComponent<Camera>();
        _LightCam.name = "LightDepthCamera";
        _LightCam.depth = 2;
        _LightCam.clearFlags = CameraClearFlags.SolidColor;
        _LightCam.backgroundColor = new Color(1, 1, 1, 0);
        _LightCam.cullingMask = LayerMask.GetMask("Everything");
        _LightCam.aspect = 1;
        _LightCam.transform.position = this.transform.position;
        _LightCam.transform.rotation = this.transform.rotation;
        _LightCam.transform.parent = this.transform;

        _LightCam.orthographic = true;
        _LightCam.orthographicSize = 10;

        sm.m00 = 0.5f;
        sm.m11 = 0.5f;
        sm.m22 = 0.5f;
        sm.m03 = 0.5f;
        sm.m13 = 0.5f;
        sm.m23 = 0.5f;
        sm.m33 = 1;

        _RT = new RenderTexture(1024, 1024, 0);
        _RT.wrapMode = TextureWrapMode.Clamp;
        _LightCam.targetTexture = _RT;
        _LightCam.SetReplacementShader(_shader, "RenderType");
    }

    // Update is called once per frame
    void Update()
    {
        lightTrans.transform.eulerAngles = new Vector3(37.2f, -46.109f, -90.489f);
        _LightCam.Render();
        Matrix4x4 tm = GL.GetGPUProjectionMatrix(_LightCam.projectionMatrix,false)*_LightCam.worldToCameraMatrix;

        tm = sm * tm;

        Shader.SetGlobalMatrix("LightSpaceMatrix", tm);
        Shader.SetGlobalTexture("Light_DepthTexture", _RT);

    }
}

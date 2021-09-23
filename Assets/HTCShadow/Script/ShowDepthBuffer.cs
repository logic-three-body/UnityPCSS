using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShowDepthBuffer : MonoBehaviour
{
    // Start is called before the first frame update
    public Shader _shader;

    void Start()
    {
        var cam = GetComponent<Camera>();
        cam.depthTextureMode = DepthTextureMode.Depth;
        cam.clearFlags = CameraClearFlags.Skybox;
        cam.backgroundColor = Color.white;
        cam.renderingPath = RenderingPath.Forward;
        cam.SetReplacementShader(_shader, "RenderType");
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}

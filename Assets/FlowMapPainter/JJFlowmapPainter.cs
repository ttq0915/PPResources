using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(MeshCollider))]
public class JJFlowmapPainter : MonoBehaviour
{
   
    // 公共字段，用户可以在Inspector中选择
    public MeshType meshType;
    public DrawingType drawingType;
    
    public Texture2D flowMapTexture;
    public Texture2D MaskMapTexture;

    public LayerMask layerMask;

    public Color BrushColor;
    // 定义枚举类型
    public enum MeshType
    {
        SkinnedMesh,
        Mesh
    }
    public enum DrawingType
    {
        MaskMap,
        FlowMap
    }

   
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}

using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

[RequireComponent(typeof(SkinnedMeshRenderer))]
public class SkinnedMeshRendererTool : MonoBehaviour
{
    public SkinnedMeshRenderer skinnedMeshRenderer;

    [SerializeField]
    [HideInInspector]
    private bool meshFoldoutStatus = false;
    [SerializeField]
    [HideInInspector]
    private bool materialFoldoutStatus = false;
    [SerializeField]
    public bool auto = true;

    public string directoryInfo;

    [SerializeField]
    public Mesh[] meshList;
    [SerializeField]
    public Material[] materialList;
    [HideInInspector]
    public Mesh lastMesh;
    [HideInInspector]
    [SerializeField]
    public List<Material> allMaterialList = new List<Material>();

    public void GetAllMaterials()
    {
        if (!Directory.Exists(directoryInfo))
        {
            Debug.Log("路径不存在");
            return;
        }
        var directory = new DirectoryInfo(directoryInfo);

        var files = directory.GetFiles("*", SearchOption.AllDirectories);
        int length = files.Length;
        for (int i = 0; i < length; i++)
        {
            var file = files[i];

            if (!file.Extension.Contains("mat"))
                continue;
            var asset = AssetDatabase.LoadAssetAtPath<Material>("Assets\\" + file.FullName.Replace(Application.dataPath.Replace("/", "\\") + "\\", ""));
            if (asset != null)
                allMaterialList.Add(asset);
        }
    }

    private void Reset()
    {
        skinnedMeshRenderer = GetComponent<SkinnedMeshRenderer>();
    }

    public void SetMesh(Mesh mesh)
    {
        skinnedMeshRenderer.sharedMesh = mesh;
    }

    public void SetMaterial(Material mat)
    {
        skinnedMeshRenderer.material = mat;
    }
}
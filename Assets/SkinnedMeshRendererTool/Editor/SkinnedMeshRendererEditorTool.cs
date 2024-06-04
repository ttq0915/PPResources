using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(SkinnedMeshRendererTool))]
public class SkinnedMeshRendererEditorTool : Editor
{
    SerializedProperty materialFoldoutStatus;
    SerializedProperty meshFoldoutStatus;

    SerializedProperty meshList;
    SerializedProperty materialList;

    private void OnEnable()
    {
        materialFoldoutStatus = serializedObject.FindProperty("materialFoldoutStatus");
        meshFoldoutStatus = serializedObject.FindProperty("meshFoldoutStatus");

        meshList = serializedObject.FindProperty("meshList");
        materialList = serializedObject.FindProperty("materialList");
    }

    public override void OnInspectorGUI()
    {
        SkinnedMeshRendererTool tool = (SkinnedMeshRendererTool)target;

        // 自动导入按钮
        tool.auto = EditorGUILayout.Toggle("自动导入材质", tool.auto);
        // 自动导入地址
        EditorGUI.BeginDisabledGroup(!tool.auto);
        EditorGUILayout.BeginHorizontal();
        tool.directoryInfo = EditorGUILayout.TextField("自动导入材质地址", tool.directoryInfo);
        if (GUILayout.Button("浏览", GUILayout.Width(50f)))
        {
            tool.directoryInfo = EditorUtility.OpenFolderPanel("选择需要自动导入的文件夹", Application.dataPath, "");
        }
        EditorGUILayout.EndHorizontal();
        // 刷新本地资源按钮
        if (GUILayout.Button("刷新本地资源"))
        {
            Debug.Log($"刷新本地资源！");
            tool.allMaterialList.Clear();
            tool.GetAllMaterials();
        }
        EditorGUI.EndDisabledGroup();
        // 网格列表
        EditorGUILayout.PropertyField(meshList, true);
        // 材质列表
        EditorGUI.BeginDisabledGroup(tool.auto);
        EditorGUILayout.PropertyField(materialList, true);
        EditorGUI.EndDisabledGroup();

        meshFoldoutStatus.boolValue = EditorGUILayout.Foldout(meshFoldoutStatus.boolValue, "网格", true);
        if (meshFoldoutStatus.boolValue)
        {
            if (tool.meshList != null)
            {
                for (int i = 0; i < tool.meshList.Length; i++)
                {
                    EditorGUILayout.BeginHorizontal();
                    tool.meshList[i] = (Mesh)EditorGUILayout.ObjectField($"网格 {i}", tool.meshList[i], typeof(Mesh), false);
                    if (GUILayout.Button("装载"))
                    {
                        Debug.Log($"网格 {tool.meshList[i].name} 装载！");
                        tool.SetMesh(tool.meshList[i]);
                    }
                    EditorGUILayout.EndHorizontal();
                }
            }
        }

        int num = 0;
        materialFoldoutStatus.boolValue = EditorGUILayout.Foldout(materialFoldoutStatus.boolValue, "材质", true);
        if (!tool.auto)
        {
            if (materialFoldoutStatus.boolValue)
            {
                if (tool.materialList != null)
                {
                    for (int i = 0; i < tool.materialList.Length; i++)
                    {
                        if (tool.materialList[i].name.Contains(tool.skinnedMeshRenderer.sharedMesh.name))
                        {
                            num++;
                            EditorGUILayout.BeginHorizontal();
                            tool.materialList[i] = (Material)EditorGUILayout.ObjectField($"材质 {num}", tool.materialList[i], typeof(Material), false);
                            if (tool.lastMesh != tool.skinnedMeshRenderer.sharedMesh)
                            {
                                tool.SetMaterial(tool.materialList[i]);
                                tool.lastMesh = tool.skinnedMeshRenderer.sharedMesh;
                            }
                            if (GUILayout.Button("装载"))
                            {
                                Debug.Log($"材质 {tool.materialList[i].name} 装载！");
                                tool.SetMaterial(tool.materialList[i]);
                            }
                            EditorGUILayout.EndHorizontal();
                        }
                    }
                }
            }
        }
        else
        {
            if (materialFoldoutStatus.boolValue)
            {
                if (tool.allMaterialList != null)
                {
                    for (int i = 0; i < tool.allMaterialList.Count; i++)
                    {
                        if (tool.allMaterialList[i].name.Contains(tool.skinnedMeshRenderer.sharedMesh.name))
                        {
                            num++;
                            EditorGUILayout.BeginHorizontal();
                            tool.allMaterialList[i] = (Material)EditorGUILayout.ObjectField($"材质 {num}", tool.allMaterialList[i], typeof(Material), false);
                            if (tool.lastMesh != tool.skinnedMeshRenderer.sharedMesh)
                            {
                                tool.SetMaterial(tool.allMaterialList[i]);
                                tool.lastMesh = tool.skinnedMeshRenderer.sharedMesh;
                            }
                            if (GUILayout.Button("装载"))
                            {
                                Debug.Log($"材质 {tool.allMaterialList[i].name} 装载！");
                                tool.SetMaterial(tool.allMaterialList[i]);
                            }
                            EditorGUILayout.EndHorizontal();
                        }
                    }
                }
            }
        }

        serializedObject.ApplyModifiedProperties();
    }
}

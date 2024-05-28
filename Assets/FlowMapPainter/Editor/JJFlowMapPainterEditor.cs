using UnityEngine;
using UnityEditor;
using System.IO;
using System.Collections;

[CustomEditor(typeof(JJFlowmapPainter))]
[CanEditMultipleObjects]
public class JJFlowmapPainterEditor : Editor
{
    string ContolTexName = "";
    bool isPaint;

    float brushSize = 16f;
    float brushStronger = 0.5f;

    Texture[] brushTex;
    Texture[] texLayer;

    int selBrush = 0;
    int selTex = 0;
    
    
    Texture2D MaskTex;
    Texture2D FlowMapTex;
    int brushSizeInPourcent;
    
    //flow
    public Vector2 furDir = new Vector2(0, 1);
    // 在类中添加一个私有变量来存储前一帧的UV坐标
    private Vector2 previousUV = Vector2.zero;
    
    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();

        if (Cheak())
        {
            GUIStyle boolBtnOn = new GUIStyle(GUI.skin.GetStyle("Button"));
            GUILayout.BeginHorizontal();
                 GUILayout.FlexibleSpace();
                     isPaint = GUILayout.Toggle(isPaint, EditorGUIUtility.IconContent("EditCollider"), boolBtnOn, GUILayout.Width(35), GUILayout.Height(25));
                  GUILayout.FlexibleSpace();
            GUILayout.EndHorizontal();
            
            brushSize = (int)EditorGUILayout.Slider("Brush Size", brushSize, 1, 36);
            brushStronger = EditorGUILayout.Slider("Brush Stronger", brushStronger, 0, 1f);

            layerTex(); //获取贴图
            IniBrush(); //获取笔刷
            GUILayout.BeginHorizontal();
               GUILayout.FlexibleSpace();
                   GUILayout.BeginHorizontal("box", GUILayout.Width(340));
                      selTex = GUILayout.SelectionGrid(selTex, texLayer, 4, "gridlist", GUILayout.Width(340), GUILayout.Height(86));
                   GUILayout.EndHorizontal();
               GUILayout.FlexibleSpace();
            GUILayout.EndHorizontal();

            GUILayout.BeginHorizontal();
              GUILayout.FlexibleSpace();
                  GUILayout.BeginHorizontal("box", GUILayout.Width(318));
                      selBrush = GUILayout.SelectionGrid(selBrush, brushTex, 9, "gridlist", GUILayout.Width(340), GUILayout.Height(70));
                  GUILayout.EndHorizontal();
               GUILayout.FlexibleSpace();
            GUILayout.EndHorizontal();
            
            // 添加一个按钮来保存 MaskMap
            if (GUILayout.Button("Save MaskMap"))
            {
                SaveTexture(MaskTex);
            }
            // 添加一个按钮来保存 MaskMap
            if (GUILayout.Button("Save FlowMap"))
            {
                SaveTexture(FlowMapTex);
            }
        }
    }
    
    void OnSceneGUI()
    {
        if (isPaint)
        {
            JJFlowmapPainter painter = Selection.activeTransform.gameObject.GetComponent<JJFlowmapPainter>();
            if (painter.drawingType == JJFlowmapPainter.DrawingType.MaskMap )
            {
                // Debug.Log("1111");
               
                MaskTex = painter.MaskMapTexture;
                Painter(MaskTex,0);
            }
            else
            {
                FlowMapTex = painter.flowMapTexture;
                Painter(FlowMapTex,1);
            }
        }
    }

    //检查
    bool Cheak()
    {
        bool Cheak = false;

        if (Selection.activeTransform == null)
        {
            EditorGUILayout.HelpBox("没有选中任何对象！", MessageType.Warning);
            return false;
        }

        JJFlowmapPainter painter = Selection.activeTransform.gameObject.GetComponent<JJFlowmapPainter>();
        if (painter == null)
        {
            EditorGUILayout.HelpBox("选中的GameObject上没有JJFlowmapPainter组件！", MessageType.Warning);
            return false;
        }

        if (painter.flowMapTexture == null)
        {
            EditorGUILayout.HelpBox("当前模型未设置FlowMap，绘制功能不可用！", MessageType.Error);
            // 其他代码...
            return false;
        }
        else
        {
            Cheak = true;
        }

        return Cheak;
    }


    //获取笔刷
    void IniBrush()
    {
        string T4MEditorFolder = "Assets/JJWorkShow/ToolDevelop/FlowMapPainter/Editor/";
        ArrayList BrushList = new ArrayList();
        Texture BrushesTL;
        int BrushNum = 0;
        //从Brush0.png这个文件名开始对Assets/MeshPaint/Editor/Brushes文件夹进行搜索，把搜到的图片加入到ArrayList里
        do
        {
            BrushesTL = (Texture)AssetDatabase.LoadAssetAtPath(T4MEditorFolder + "Brushes/Brush" + BrushNum + ".png",
                typeof(Texture));

            if (BrushesTL)
            {
                BrushList.Add(BrushesTL);
            }

            BrushNum++;
        } while (BrushesTL);

        brushTex = BrushList.ToArray(typeof(Texture)) as Texture[]; //把ArrayList转为Texture[]
    }

    //获取材质球中的贴图
    void layerTex()
    {
        Transform Select = Selection.activeTransform;

        texLayer = new Texture[2];
        texLayer[0] = Select.gameObject.GetComponent<JJFlowmapPainter>().MaskMapTexture as Texture;
        texLayer[1] = Select.gameObject.GetComponent<JJFlowmapPainter>().flowMapTexture as Texture;
    }
    
    void Painter(Texture2D my_texture,int type)
    {
        Transform CurrentSelect = Selection.activeTransform;
        float orthographicSize;
        if ( Selection.activeTransform.gameObject.GetComponent<JJFlowmapPainter>().meshType == JJFlowmapPainter.MeshType.Mesh )
        {
            MeshFilter temp = CurrentSelect.GetComponent<MeshFilter>();//获取当前模型的MeshFilter
            orthographicSize = (brushSize * CurrentSelect.localScale.x) * (temp.sharedMesh.bounds.size.x / 200);//笔刷在模型上的正交大小
        }
        else
        {
            SkinnedMeshRenderer temp = CurrentSelect.GetComponent<SkinnedMeshRenderer>();//获取当前模型的MeshFilter
            orthographicSize = (brushSize * CurrentSelect.localScale.x) * (temp.sharedMesh.bounds.size.x / 200);//笔刷在模型上的正交大小
        }
        

        brushSizeInPourcent = (int)Mathf.Round((brushSize * my_texture.width) / 100);//笔刷在模型上的大小
        bool ToggleF = false;
        Event e = Event.current;
        HandleUtility.AddDefaultControl(0);
        RaycastHit raycastHit = new RaycastHit();
        Ray terrain = HandleUtility.GUIPointToWorldRay(e.mousePosition);//从鼠标位置发射一条射线
        if (Physics.Raycast(terrain, out raycastHit, Mathf.Infinity,  Selection.activeTransform.gameObject.GetComponent<JJFlowmapPainter>().layerMask))//射线检测名为"ground"的层
        {
            Handles.color = new Color(1f, 1f, 0f, 1f);//颜色
            Handles.DrawWireDisc(raycastHit.point, raycastHit.normal, orthographicSize);//根据笔刷大小在鼠标位置显示一个圆

            //鼠标点击或按下并拖动进行绘制
            if ((e.type == EventType.MouseDrag && e.alt == false && e.control == false && e.shift == false && e.button == 0) || (e.type == EventType.MouseDown && e.shift == false && e.alt == false && e.control == false && e.button == 0 && ToggleF == false))
            {
                // //选择绘制的通道
                // Color targetColor = Selection.activeTransform.gameObject.GetComponent<JJFlowmapPainter>().BrushColor;
                // switch (selTex)
                // {
                //     case 0:
                //         targetColor = new Color(1f, 0f, 0f, 0f);
                //         break;
                //     case 1:
                //         targetColor = new Color(0f, 1f, 0f, 0f);
                //         break;
                //     case 2:
                //         targetColor = new Color(0f, 0f, 1f, 0f);
                //         break;
                //     case 3:
                //         targetColor = new Color(0f, 0f, 0f, 1f);
                //         break;
                //
                // }
                
                //选择绘制的通道
                Color targetColor = new Color(1f, 0f, 0f, 0f);  
                if(type == 1)
                {
                    Vector2 currentUV = raycastHit.textureCoord;
                    currentUV.x *= my_texture.width;
                    currentUV.y *= my_texture.height;

                    if (previousUV != Vector2.zero)
                    {
                        // 计算滑动方向
                        Vector2 direction = currentUV - previousUV;
                        furDir = direction.normalized;

                        targetColor = new Color(-furDir.x * 0.5f + 0.5f, -furDir.y * 0.5f + 0.5f, 0);
                    }

                    previousUV = currentUV;
                }
                else
                {
                    //选择绘制的通道
                   targetColor = Selection.activeTransform.gameObject.GetComponent<JJFlowmapPainter>().BrushColor;
                }

           
                        
                    
                

                Vector2 pixelUV = raycastHit.textureCoord;

                //计算笔刷所覆盖的区域
                int PuX = Mathf.FloorToInt(pixelUV.x * my_texture.width);
                int PuY = Mathf.FloorToInt(pixelUV.y * my_texture.height);
                int x = Mathf.Clamp(PuX - brushSizeInPourcent / 2, 0, my_texture.width - 1);
                int y = Mathf.Clamp(PuY - brushSizeInPourcent / 2, 0, my_texture.height - 1);
                int width = Mathf.Clamp((PuX + brushSizeInPourcent / 2), 0, my_texture.width) - x;
                int height = Mathf.Clamp((PuY + brushSizeInPourcent / 2), 0, my_texture.height) - y;

                Color[] terrainBay = my_texture.GetPixels(x, y, width, height, 0);//获取Control贴图被笔刷所覆盖的区域的颜色

                Texture2D TBrush = brushTex[selBrush] as Texture2D;//获取笔刷性状贴图
                float[] brushAlpha = new float[brushSizeInPourcent * brushSizeInPourcent];//笔刷透明度

                //根据笔刷贴图计算笔刷的透明度
                for (int i = 0; i < brushSizeInPourcent; i++)
                {
                    for (int j = 0; j < brushSizeInPourcent; j++)
                    {
                        brushAlpha[j * brushSizeInPourcent + i] = TBrush.GetPixelBilinear(((float)i) / brushSizeInPourcent, ((float)j) / brushSizeInPourcent).a;
                    }
                }

                //计算绘制后的颜色
                for (int i = 0; i < height; i++)
                {
                    for (int j = 0; j < width; j++)
                    {
                        int index = (i * width) + j;
                        float Stronger = brushAlpha[Mathf.Clamp((y + i) - (PuY - brushSizeInPourcent / 2), 0, brushSizeInPourcent - 1) * brushSizeInPourcent + Mathf.Clamp((x + j) - (PuX - brushSizeInPourcent / 2), 0, brushSizeInPourcent - 1)] * brushStronger;

                        terrainBay[index] = Color.Lerp(terrainBay[index], targetColor, Stronger);
                    }
                }
                Undo.RegisterCompleteObjectUndo(my_texture, "meshPaint");//保存历史记录以便撤销

                my_texture.SetPixels(x, y, width, height, terrainBay, 0);//把绘制后的Control贴图保存起来
                my_texture.Apply();
                ToggleF = true;
                e.Use(); // 标记事件为已使用
            }

            // if (e.type == EventType.MouseUp && e.alt == false && e.button == 0 )
            // {
            //     SaveTexture();//绘制结束保存Control贴图
            //     ToggleF = false;
            //     e.Use(); // 标记事件为已使用
            // }
            
            if (Input.GetMouseButtonUp(0))
            {
                previousUV = Vector2.zero;
            }
            
            
        }
    }
    public void SaveTexture(Texture2D tex)
    {
        if (tex == null)
        {
            Debug.LogError("Tex is null, cannot save texture.");
            return;
        }

        string path = AssetDatabase.GetAssetPath(tex);
        byte[] bytes = tex.EncodeToPNG();
        File.WriteAllBytes(path, bytes);
        Debug.Log("Texture saved at " + path);

        // 使用延迟调用进行资源导入
        EditorApplication.delayCall += () => {
            AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);
            Debug.Log("Asset database updated.");
        };
    }

}
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class biaoqingqipao : MonoBehaviour
{
    private Animator animator;
    // Start is called before the first frame update
    void Start()
    {
        animator = this.GetComponent<Animator>();
    }

    // Update is called once per frame
    void Update()
    {

        if (Input.GetKeyDown(KeyCode.W))
        {
            animator.SetLayerWeight(1, 1);
        }
    }
}

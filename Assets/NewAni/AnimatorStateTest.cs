using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class AnimatorStateTest : MonoBehaviour
{
    public Animator animator;

    public AnimatorStateInfo StateInfo;
    // Start is called before the first frame update
    void Start()
    {
        animator = GetComponent<Animator>();
        StateInfo = animator.GetCurrentAnimatorStateInfo(animator.GetLayerIndex("BaseLayer"));
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}

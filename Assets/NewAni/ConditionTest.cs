
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class ConditionTest : MonoBehaviour
{
    Animator animator;
    // Start is called before the first frame update
    void Start()
    {
        animator = GetComponent<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Keyboard.current.eKey.isPressed)
        {
            animator.SetTrigger("Trigger3");
        }
        if (Keyboard.current.fKey.isPressed)
        {
            animator.SetInteger("New Int",10); 
        }
        if (Keyboard.current.sKey.isPressed)
        {
            animator.SetBool("New Bool",true);
        }
        if (Keyboard.current.wKey.isPressed)
        {
            animator.SetTrigger("Trigger2");
        }
        if (Keyboard.current.qKey.isPressed)
        {
            animator.SetTrigger("Trigger1");
        }
        if (Keyboard.current.rKey.isPressed)
        {
            animator.SetTrigger("Trigger4");
        }
    }
}

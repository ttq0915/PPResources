
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerMoveTest : MonoBehaviour
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
        
    }

    public void PlayerMove(InputAction.CallbackContext callbackContext)
    {
        Vector2 movement = callbackContext.ReadValue<Vector2>();
        Debug.Log(movement);
    }
}

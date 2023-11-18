

using UnityEngine;

// It defines a Move class that controls the movement of a game object within a scene.
public class Move : MonoBehaviour
{
    public float moveSpeed = 0.1f;

    private Vector3 velocity = Vector3.zero;
    private Camera mainCamera;

    // Use this for initialization
    void Start()
    {
        mainCamera = Camera.main;
    }

    void Update()
    {
        float horizontalInput = Input.GetAxis("Horizontal");
        float verticalInput = Input.GetAxis("Vertical");

        Vector3 inputDir = new Vector3(horizontalInput, 0, verticalInput).normalized;

        // increase movespeed smoothly
        velocity += inputDir * moveSpeed * Time.deltaTime;

        // control maximum movespeed
        velocity = Vector3.ClampMagnitude(velocity, moveSpeed);

        transform.forward = velocity.normalized;

        // Get screen boundary
        Vector3 screenPosition = mainCamera.WorldToViewportPoint(transform.position);
        screenPosition.x = Mathf.Clamp01(screenPosition.x);
        screenPosition.y = Mathf.Clamp01(screenPosition.y);

        // The clamped screenPosition is converted back to world space coordinates using ViewportToWorldPoint.
        Vector3 clampedPosition = mainCamera.ViewportToWorldPoint(screenPosition);

        // effectively moving the GameObject within the screen's bounds
        transform.position = clampedPosition;
    }


void OnCollisionEnter(){
		//Destroy (gameObject);
	}

}

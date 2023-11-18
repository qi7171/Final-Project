using UnityEngine;
using System.Collections;

public class Cubes : MonoBehaviour
{
    public GameObject[] cubeVariants; // Store a variety of objects
    private float delay = 0.1f;  //This value will be used to determine the delay before spawning the first cube and the time interval between spawns.

    // Use this for initialization
    void Start()
    {
        InvokeRepeating("Spawn", delay, delay);
    }

    //The Spawn method is defined to handle the creation of new cube GameObjects.
    void Spawn()
    {
        //Three float variables randomX, randomY, and randomZ are assigned random values within specified ranges. These will be used to determine the position at which a cube will be spawned.
        float randomX = Random.Range(-4, 8);
        float randomY = Random.Range(-4, 7);
        float randomZ = Random.Range(-4, 4);

        Vector3 spawnPosition = new Vector3(randomX, randomY, randomZ); //This specifies where in the 3D space the new cube will appear.

        Quaternion randomRotation = Quaternion.Euler(0, Random.Range(0, 360), 0);

        // select an object randomly from cubeVariants
        GameObject selectedCube = cubeVariants[Random.Range(0, cubeVariants.Length)];

        // instantiate object
        GameObject newCube = Instantiate(selectedCube, spawnPosition, randomRotation);

        if (newCube != null)
        {


        }
    }
}

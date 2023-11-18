using UnityEngine;
using OscSimpl;

public class UnityToProcessing : MonoBehaviour
{
    public string targetIPAddress = "127.0.0.1"; // Processing IP Address
    public int targetPort = 12345; // Processing port

    private OscOut oscSender;

    void Start()
    {
        // Create the OscOut instance and open the connection
        oscSender = gameObject.AddComponent<OscOut>();
        oscSender.Open(targetPort, targetIPAddress);
    }

    void Update()
    {
        // get object position
        Vector3 objectPosition = transform.position;

        // send position message to Processing
        SendPositionMessage(objectPosition);
    }

    void OnDestroy()
    {
        // close connection
        oscSender.Close();
    }

    // send position message
    private void SendPositionMessage(Vector3 position)
    {
        OscMessage message = new OscMessage("/unity/object/position");
        message.Add(position.x);
        message.Add(position.y);
        message.Add(position.z);
        oscSender.Send(message);
    }
}

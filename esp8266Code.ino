#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>

/* WiFi Credentials */
const char* ssid     = "Tanvir ahmed (chy)";
const char* password = "123456hhHH";

/* Web Server runs on port 80 */
ESP8266WebServer server(80);

/* Built-in LED pin */
#define LED_PIN LED_BUILTIN

/* Handler for /on */
void handleOn()
{
    digitalWrite(LED_PIN, LOW);   // LED ON (active LOW)
    server.send(200, "text/plain", "LED ON");
}

/* Handler for /off */
void handleOff()
{
    digitalWrite(LED_PIN, HIGH);  // LED OFF
    server.send(200, "text/plain", "LED OFF");
}

/* Handler for unknown URLs */
void handleNotFound()
{
    server.send(404, "text/plain", "Not Found");
}

void setup()
{
    Serial.begin(115200);
    pinMode(LED_PIN, OUTPUT);
    digitalWrite(LED_PIN, HIGH);  // LED OFF initially

    /* Connect to WiFi */
    WiFi.begin(ssid, password);
    Serial.print("Connecting to WiFi");

    while (WiFi.status() != WL_CONNECTED)
    {
        delay(500);
        Serial.print(".");
    }

    Serial.println("\nWiFi connected");
    Serial.print("ESP8266 IP Address: ");
    Serial.println(WiFi.localIP());

    /* Define URL routes */
    server.on("/on", handleOn);
    server.on("/off", handleOff);
    server.onNotFound(handleNotFound);

    /* Start server */
    server.begin();
    Serial.println("HTTP server started");
}

void loop()
{
    server.handleClient();
}

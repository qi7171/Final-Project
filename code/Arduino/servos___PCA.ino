
#include <Wire.h>
#include <Adafruit_PWMServoDriver.h>

Adafruit_PWMServoDriver pwm = Adafruit_PWMServoDriver();
#define SERVO_FREQ 50

bool startSignalReceived = false;
int servoMovementState = 0;  // 0: Wait for Start, 1: Set to 0°, 2: Set to 120°

void setup() {
    Serial.begin(9600);
    pwm.begin();
    pwm.setOscillatorFrequency(27000000);
    pwm.setPWMFreq(SERVO_FREQ);
    delay(10);
}

uint16_t angleToPulseWidth(float angle) {
    const float pulseWidthPerDegree = 5.56;
    return (uint16_t)(1000 + angle * pulseWidthPerDegree); 
}

void moveServosToAngle(float angle) {
    for (uint8_t i = 0; i < 16; i++) {
        pwm.writeMicroseconds(i, angleToPulseWidth(angle));
    }
}

void loop() {
    if (Serial.available()) {
        char command = Serial.read();
        if (command == 'S') {
            startSignalReceived = true;
            servoMovementState = 1;
        }
        else if (command == 'E') {
            startSignalReceived = false;
            servoMovementState = 0;
        }
    }

    if (startSignalReceived) {
        switch(servoMovementState) {
            case 1:
                moveServosToAngle(0); 
                delay(1000);
                servoMovementState = 2;
                break;

            case 2:
                moveServosToAngle(120);
                delay(1000);
                servoMovementState = 1;
                break;
        }
    }
}

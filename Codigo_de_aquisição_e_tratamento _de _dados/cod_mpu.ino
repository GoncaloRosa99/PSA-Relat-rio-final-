#include <Wire.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>

#define NMAX 5000               // Número máximo de amostras
#define DURATION_MS 30000       // 30 s de aquisição
#define DELAY_MS 10             // 100 Hz

Adafruit_MPU6050 mpu;

float acX[NMAX], acY[NMAX], acZ[NMAX];
unsigned long t[NMAX];

void setup() {
  Serial.begin(115200);
  while (!Serial);

  if (!mpu.begin()) {
    Serial.println("Falha ao iniciar o MPU6050!");
    while (1) delay(10);
  }

  mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
  mpu.setFilterBandwidth(MPU6050_BAND_21_HZ);

  Serial.println("Sensor inicializado. A começar a leitura...");
}

void loop() {
  sensors_event_t a, g, temp;
  unsigned long t0 = millis();
  int i = 0;

  while ((millis() - t0) < DURATION_MS && i < NMAX) {
    mpu.getEvent(&a, &g, &temp);

    // Transformação dos eixos
    acX[i] = a.acceleration.y;                // X_desejado = Y_sensor
    acY[i] = -a.acceleration.z;               // Y_desejado = -Z_sensor
    acZ[i] = -a.acceleration.x - 9.60;        // Z_desejado = -X_sensor - 9.60 (retirar gravidade)

    t[i] = millis() - t0;                     // tempo relativo a t0

    // Enviar dados para Serial Monitor
    Serial.print("Sample ");
    Serial.print(i);
    Serial.print(": X=");
    Serial.print(acX[i], 2);  // 2 casas decimais
    Serial.print(" Y=");
    Serial.print(acY[i], 2);
    Serial.print(" Z=");
    Serial.print(acZ[i], 2);
    Serial.print(" t=");
    Serial.println(t[i]);

    delay(DELAY_MS);
    i++;
  }

  Serial.print("Leitura completa! Foram adquiridas ");
  Serial.print(i);
  Serial.println(" amostras.");
  while (1);
}

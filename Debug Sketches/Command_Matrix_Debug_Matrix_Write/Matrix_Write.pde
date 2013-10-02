#define NUMBER_OF_COLUMNS 8
#define NUMBER_OF_ROWS 8

#define COLUMN_THRESHOLD 50

#define ROW_TIMEOUT 2000
#define ROW_THRESHOLD 1

#define shiftInputPin 36
#define shiftDisablePin 37
#define shiftStoragePin 38
#define shiftClockPin 39

#define stylusLightPin 41
#define stylusButtonPin 40

byte framebuffer[8] = // IRL, points will be shifted into these bytes.
 {                    // Framebuffer literals are mirrored across the Y axis.
 B10101010,
 B01010101,
 B10101010,
 B01010101,
 B10101010,
 B01010101,
 B10101010,
 B01010101
 };

/*
byte framebuffer[8] = 
{
  B11110000,
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  B00000000
};
*/

byte rowPins[] = {
  33, 29, 28, 27, 26, 30, 31, 32};
byte columnPins[] = {
  A6, A7, A8, A9, A10, A11, A2, A3};

void setup()
{
  pinMode(shiftInputPin, OUTPUT);
  pinMode(shiftDisablePin, OUTPUT);
  pinMode(shiftClockPin, OUTPUT);
  pinMode(shiftStoragePin, OUTPUT);

  pinMode(stylusLightPin, OUTPUT);
  digitalWrite(stylusLightPin, LOW);
  pinMode(stylusButtonPin, INPUT);

  resetTheRegister();

  Serial.begin(9600);
}

void loop()
{  
  // Set rows hi-z - the register is sinking LED current
  for (int i = 0; i < NUMBER_OF_ROWS; i++)
  {
    pinMode(rowPins[i], INPUT);
  }

  // Set columns as outputs so they can sink
  for (int i = 0; i < NUMBER_OF_COLUMNS; i++)
  {
    pinMode(columnPins[i], OUTPUT);
  }

  digitalWrite(shiftInputPin, LOW); // This is a common-cathode matrix, so a row is active low

  digitalWrite(shiftDisablePin, HIGH);

  //delayMicroseconds(50);
  digitalWrite(shiftClockPin, HIGH);
  //delayMicroseconds(50);
  digitalWrite(shiftClockPin, LOW);
  digitalWrite(shiftStoragePin, HIGH);
  //delayMicroseconds(50);
  digitalWrite(shiftStoragePin, LOW);

  digitalWrite(shiftInputPin, HIGH);

  for (int i = 0; i < NUMBER_OF_ROWS; i++)
  {
    byte column = framebuffer[i];

    for (int i = 0; i < NUMBER_OF_COLUMNS; i++)
    {
      digitalWrite(columnPins[i], 
      ((column >> i) & 1));
    }

    digitalWrite(shiftDisablePin, LOW);

    delayMicroseconds(50);

    digitalWrite(shiftDisablePin, HIGH);

    if (i < NUMBER_OF_COLUMNS)
    {
      shift();
    }
  }
}

void resetTheRegister()
{
  digitalWrite(shiftInputPin, LOW);
  for (int i = 0; i < 8; i++) 
  {
    //delayMicroseconds(50);
    digitalWrite(shiftClockPin, HIGH);
    //delayMicroseconds(50);
    digitalWrite(shiftClockPin, LOW);
  }
  digitalWrite(shiftStoragePin, HIGH);
  //delayMicroseconds(50);
  digitalWrite(shiftStoragePin, LOW);
  digitalWrite(shiftDisablePin, LOW);
}

void shift()
{
  //delayMicroseconds(50);
  digitalWrite(shiftClockPin, HIGH);
  //delayMicroseconds(50);
  digitalWrite(shiftClockPin, LOW);
  digitalWrite(shiftStoragePin, HIGH);
  //delayMicroseconds(50);
  digitalWrite(shiftStoragePin, LOW);
}




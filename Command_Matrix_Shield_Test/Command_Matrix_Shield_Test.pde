#define NUMBER_OF_COLUMNS 8
#define NUMBER_OF_ROWS 8

#define COLUMN_THRESHOLD 50

#define ROW_TIMEOUT 15000
#define ROW_THRESHOLD 1

#define shiftInputPin 36
#define shiftDisablePin 37
#define shiftStoragePin 38
#define shiftClockPin 39

#define stylusLightPin 41
#define stylusButtonPin 40

byte rowPins[] = {
  33, 29, 28, 27, 26, 30, 31, 32};
byte columnPins[] = {
  A6, A7, A8, A9, A10, A11, A2, A3};

int columnZeroes[8];

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

//byte framebuffer[8];

void setup()
{
  pinMode(shiftInputPin, OUTPUT);
  pinMode(shiftDisablePin, OUTPUT);
  pinMode(shiftClockPin, OUTPUT);
  pinMode(shiftStoragePin, OUTPUT);

  pinMode(stylusLightPin, OUTPUT);
  pinMode(stylusButtonPin, INPUT);

  Serial.begin(9600);

  resetTheRegister(false);
}

void loop()
{
  digitalWrite(stylusLightPin, digitalRead(stylusButtonPin));

  digitalWrite(shiftDisablePin, HIGH);

  int litRow = -1;
  int litColumn = -1;
  int highestColumnValue = 0;
  int highestRowValue = 0;

  /* COLUMNS */
  for (int i = 0; i < NUMBER_OF_ROWS; i++)
  { 
    digitalWrite(rowPins[i], LOW);
    pinMode(rowPins[i], OUTPUT);
  }

  for (int i = 0; i < NUMBER_OF_COLUMNS; i++) 
  {
    digitalWrite(columnPins[i], LOW);
    pinMode(columnPins[i], OUTPUT);
  }

  for (int i = 0; i < NUMBER_OF_COLUMNS; i++) pinMode(columnPins[i], INPUT);

  delayMicroseconds(1000);

  int columnValues[NUMBER_OF_COLUMNS];

  int activeReading = 0;
  for (int i = 0; i < NUMBER_OF_COLUMNS; i++)
  {
    columnValues[i] = analogRead(columnPins[i]);

    if (columnValues[i] > highestColumnValue)
    {
      highestColumnValue = columnValues[i];
      litColumn = i;
    }
  }

  if (highestColumnValue < COLUMN_THRESHOLD) litColumn = -1;

  /* ROWS */

  // Apply reverse voltage, charge up the pin and led capacitance

  for (int i = 0; i < NUMBER_OF_ROWS; i++)
  {
    pinMode(rowPins[i], INPUT);
  }

  // Set output enable low, putting 5V into the LED's

  for (int i = 0; i < NUMBER_OF_COLUMNS; i++)
  {
    pinMode(columnPins[i], OUTPUT);
    digitalWrite(columnPins[i], LOW);
  }

  resetTheRegister(true);

  delay(1);

  // Isolate the pin 2 end of the diode

  digitalWrite(shiftDisablePin, HIGH);

  /*
      for (int i = 0; i < NUMBER_OF_ROWS; i++)
   {
   digitalWrite(rowPins[i], LOW);
   }
   */

  int rowValues[8] = {
    0, 0, 0, 0, 0, 0, 0, 0  }; 

  int time = ROW_TIMEOUT;
  boolean endTheLoop = false;
  while (time > 0)
  {
    time--;

    for (int i = 0; i < NUMBER_OF_ROWS; i++)
    {
      //if (digitalRead(rowPins[i]) == LOW)
      if (digitalRead(rowPins[i]) == LOW && rowValues[i] == 0)
      {
        rowValues[i] = time;
        highestRowValue = time;
        litRow = i;
        endTheLoop = true;
        break;
      }
    }

    if (endTheLoop) break;
  }

  if (highestRowValue < ROW_THRESHOLD) litRow = -1;

  /* SERIAL */
  if (litRow != -1 && litColumn != -1)
  {
    Serial.print(litColumn);
    Serial.print(" , ");
    Serial.println(litRow);
  }
  
  /*
  for (int i = 0; i < NUMBER_OF_COLUMNS; i++)
  {
    Serial.print(columnValues[i], DEC);
    Serial.print('\t');
  }
  Serial.println();
*/

/*
  for (int i = 0; i < 8; i++)
   {
   Serial.print(rowValues[i]);
   Serial.print(' ');
   }
   Serial.println();
  */ 

  /* DISPLAY */

  // Assumes the register is pre-initialized all high

  digitalWrite(shiftInputPin, LOW); // This is a common-cathode matrix, so a row is active low

  digitalWrite(shiftDisablePin, HIGH);

  digitalWrite(shiftClockPin, HIGH);
  digitalWrite(shiftClockPin, LOW);
  
  digitalWrite(shiftStoragePin, HIGH);
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

    delayMicroseconds(1000);

    digitalWrite(shiftDisablePin, HIGH);

    if (i < NUMBER_OF_COLUMNS)
    {
      shift();
    }
  }
}

void calibrateColumns()
{
  for (int i = 0; i < NUMBER_OF_ROWS; i++) pinMode(rowPins[i], OUTPUT);

  for (int i = 0; i < 32; i++)
  {
    for (int i = 0; i < NUMBER_OF_COLUMNS; i++) pinMode(columnPins[i], OUTPUT);

    for (int i = 0; i < NUMBER_OF_COLUMNS; i++) pinMode(columnPins[i], INPUT);

    delayMicroseconds(10);

    for (int i = 0; i < NUMBER_OF_COLUMNS; i++)
    {
      columnZeroes[i] += analogRead(columnPins[i]);
    }
  }
  
  Serial.println("Calibration:");
  for (int i = 0; i < NUMBER_OF_COLUMNS; i++) 
  {
    columnZeroes[i] >>= 5;
    Serial.print(columnZeroes[i]);
    Serial.print('\t');
  }
  Serial.println();
}

void resetTheRegister(boolean state)
{
  digitalWrite(shiftInputPin, state);
  for (int i = 0; i < 8; i++) 
  {
    digitalWrite(shiftClockPin, HIGH);
    digitalWrite(shiftClockPin, LOW);
  }
  digitalWrite(shiftStoragePin, HIGH);
  digitalWrite(shiftStoragePin, LOW);
  
  digitalWrite(shiftDisablePin, LOW);
}

void shift()
{
  digitalWrite(shiftClockPin, HIGH);
  digitalWrite(shiftClockPin, LOW);
  
  digitalWrite(shiftStoragePin, HIGH);
  digitalWrite(shiftStoragePin, LOW);
}




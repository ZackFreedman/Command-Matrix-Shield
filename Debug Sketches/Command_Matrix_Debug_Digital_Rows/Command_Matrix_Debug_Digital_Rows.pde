void setup()
{  
  pinMode(A0, OUTPUT);
  pinMode(A1, OUTPUT);
  digitalWrite(A0, LOW);
  digitalWrite(A1, LOW);
  
  Serial.begin(9600);
}

void loop()
{
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
  digitalWrite(2, HIGH);
  digitalWrite(3, HIGH);
  delayMicroseconds(100);
  
  pinMode(2, INPUT);
  pinMode(3, INPUT);
  digitalWrite(2, LOW);
  digitalWrite(3, LOW);
  delayMicroseconds(100);
  
  int time = 600;
  int value2 = 0;
  int value3 = 0;
  while (time > 0)
  {
    time--;
    
    if (value2 == 0 && digitalRead(2) == LOW) value2 = time;
    if (value3 == 0 && digitalRead(3) == LOW) value3 = time;
    
    if (value2 != 0 && value3 != 0) break;
  }
  
  if (value2 <= 0 && value3 <= 0) Serial.println("N/A");
  else Serial.println(value2 > value3 ? "Row 0" : "Row 1");
  
  /*
  Serial.print(value2);
  Serial.print('\t');
  Serial.println(value3);
  */
  
  delay(10);
}


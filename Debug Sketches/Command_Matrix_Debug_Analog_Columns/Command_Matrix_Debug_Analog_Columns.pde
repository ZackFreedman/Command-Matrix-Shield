void setup()
{
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
  digitalWrite(2, LOW);
  digitalWrite(3, LOW);
  
  Serial.begin(9600);
}

void loop()
{
  pinMode(A0, OUTPUT);
  pinMode(A1, OUTPUT);
  digitalWrite(A0, LOW);
  digitalWrite(A1, LOW);
  //delayMicroseconds(1000);
  
  pinMode(A0, INPUT);
  pinMode(A1, INPUT);
  delayMicroseconds(1000);
  
  int analog0 = analogRead(A0);
  int analog1 = analogRead(A1);
  
  if (analog0 < 50 && analog1 < 50) Serial.println("N/A");
  else Serial.println(analog0 > analog1 ? "Col 0" : "Col 1");
  
  delay(10);
}

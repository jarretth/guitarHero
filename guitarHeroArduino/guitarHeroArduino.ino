#include <PS2X_lib.h>  //for v1.6

PS2X ps2x;

int error = 0; 
byte type = 0;
byte vibrate = 0;
int strumming = 0;

void cfg()
{
   error = ps2x.config_gamepad(11,8,13,7, true, false);   //setup pins and settings:  GamePad(clock, command, attention, data, Pressures?, Rumble?) check for error
   if(error == 1)
     Serial.println("--ERROR: No controller found");
   type = ps2x.readType();  
}

void setup(){
 Serial.begin(57600);
 cfg();
}

void loop() {
  char command[32];
  int frets[5];
  int pressed = 0;
  if(error == 1)
  {
    cfg();
    return;
  }
  ps2x.read_gamepad();
  pressed += frets[0] = ps2x.Button(GREEN_FRET);
  pressed += frets[1] = ps2x.Button(RED_FRET);
  pressed += frets[2] = ps2x.Button(YELLOW_FRET);
  pressed += frets[3] = ps2x.Button(BLUE_FRET);
  pressed += frets[4] = ps2x.Button(ORANGE_FRET);
  if(pressed && (ps2x.ButtonPressed(UP_STRUM) || ps2x.ButtonPressed(DOWN_STRUM)))
  {
    sprintf(command, "STRUM[%d,%d,%d,%d,%d]",frets[0]
                                              ,frets[1]
                                              ,frets[2]
                                              ,frets[3]
                                              ,frets[4]);
    command[17]=0;
    Serial.println(command);
    strumming = 1;
  }
  if(strumming && !pressed)
  {
    Serial.println("RELEASE");
    strumming = 0;
  }
  
  if(ps2x.ButtonPressed(PSB_SELECT))
  {
    Serial.println("DISTORTION");
  }
}

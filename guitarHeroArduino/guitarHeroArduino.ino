#include <PS2X_lib.h>  //for v1.6

PS2X ps2x;

int error = 0; 
byte type = 0;
byte vibrate = 0;
int strumming = 0;
int frets[5];
int pressed = 0;
int tick = 0;

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
  int newfrets[5];
  int newpressed = 0;
  if(error == 1)
  {
    cfg();
    return;
  }
  ps2x.read_gamepad();
  newpressed += newfrets[0] = ps2x.Button(GREEN_FRET);
  newpressed += newfrets[1] = ps2x.Button(RED_FRET);
  newpressed += newfrets[2] = ps2x.Button(YELLOW_FRET);
  newpressed += newfrets[3] = ps2x.Button(BLUE_FRET);
  newpressed += newfrets[4] = ps2x.Button(ORANGE_FRET);
  if(newpressed && (ps2x.ButtonPressed(UP_STRUM) || ps2x.ButtonPressed(DOWN_STRUM)))
  {
    sprintf(command, "STRUM[%d,%d,%d,%d,%d]",frets[0]=newfrets[0]
                                              ,frets[1]=newfrets[1]
                                              ,frets[2]=newfrets[2]
                                              ,frets[3]=newfrets[3]
                                              ,frets[4]=newfrets[4]);
    command[17]=0;
    Serial.println(command);
    strumming = 1;
    pressed = newpressed;
    
  }else if(pressed == 1 && 
                            (frets[0] != newfrets[0] ||
                            frets[1] != newfrets[1] ||
                            frets[2] != newfrets[2] ||
                            frets[3] != newfrets[3] ||
                            frets[4] != newfrets[4]))
  {
    if(tick < 6)
    {
      tick++;
    }
    else
    {
      tick = 0;
      sprintf(command, "HAMMER[%d,%d,%d,%d,%d]",newfrets[4]||newfrets[3]||newfrets[2]||newfrets[1] ? 0 : newfrets[0] 
                                              ,newfrets[4]||newfrets[3]||newfrets[2] ? 0 : newfrets[1]
                                              ,newfrets[4]||newfrets[3] ? 0 : newfrets[2]
                                              ,newfrets[4]? 0 : newfrets[3]
                                              ,frets[4]=newfrets[4]);
      command[18]=0;
      Serial.println(command);
      frets[0] = newfrets[0];
      frets[1] = newfrets[1];
      frets[2] = newfrets[2];
      frets[3] = newfrets[3];
    }
  }
  if(strumming && !newpressed)
  {
    Serial.println("RELEASE");
    frets[0] = frets[1] = frets[2] = frets[3] = frets[4] = 0;
    pressed = 0;
    strumming = 0;
  }
  
  if(ps2x.ButtonPressed(PSB_SELECT))
  {
    Serial.println("DISTORTION");
  }
}

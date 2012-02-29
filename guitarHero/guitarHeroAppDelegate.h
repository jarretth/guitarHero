//
//  guitarHeroAppDelegate.h
//  guitarHero
//
//  Created by Jarrett Hawrylak on 2/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "guitarSoundObject.h"

@interface guitarHeroAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    NSButton *greenButton;
    NSButton *redButton;
    NSButton *yellowButton;
    NSButton *blueButton;
    NSButton *orangeButton;
    NSSlider *scaleSlider;
    NSSlider *volumeSlider;
    NSButton *muteButton;
    guitarSoundObject *gso;
    
    float volume;
    int mute;
    int currentScale;
    int notesOn[5];
    int scales[7];
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSButton *greenButton;
@property (assign) IBOutlet NSButton *redButton;
@property (assign) IBOutlet NSButton *yellowButton;
@property (assign) IBOutlet NSButton *blueButton;
@property (assign) IBOutlet NSButton *orangeButton;
@property (assign) IBOutlet NSSlider *scaleSlider;
@property (assign) IBOutlet NSSlider *volumeSlider;
@property (assign) IBOutlet NSButton *muteButton;
@property (assign) int currentScale;
- (IBAction)buttonPressed:(id)sender;
- (IBAction)openWindow:(id)sender;
- (IBAction)scaleChanged:(id)sender;
- (IBAction)changeVolume:(id)sender;
- (IBAction)mutePressed:(id)sender;

- (void)updateView;
+(NSArray *)noteToScale:(int) note;
-(NSArray *)enabledNotes;

@end

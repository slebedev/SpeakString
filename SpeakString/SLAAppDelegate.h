//
//  SLAAppDelegate.h
//  SpeakString
//
//  Created by Sergey Lebedev on 21.11.12.
//  Copyright (c) 2012 Sergey Lebedev. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SLAAppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate, NSSpeechSynthesizerDelegate, NSWindowDelegate> {
    NSArray *voices; // Container for availableVoices and dataSource for tableView
    NSSpeechSynthesizer *speaker; // For speaking! :)
}

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *textField;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSButton *startSpeakingButton;
@property (weak) IBOutlet NSButton *stopSpeakingButton;

- (IBAction)stopSpeaking:(id)sender;
- (IBAction)startSpeaking:(id)sender;

@end

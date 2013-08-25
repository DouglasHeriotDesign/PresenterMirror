//
//  DHPMApplication.m
//  PresenterMirror
//
//  Created by Douglas Heriot on 21/08/13.
//  Copyright (c) 2013 Douglas Heriot. All rights reserved.
//

#import "DHPMApplication.h"
#import "DHPMAppDelegate.h"
#import "DHPMDisplayWindow.h"

@implementation DHPMApplication

/*
- (void)sendEvent:(NSEvent *)theEvent
{
	[super sendEvent:theEvent];
	
	if(theEvent.type == NSFlagsChanged)
	{
		BOOL isHoldingCommand = theEvent.modifierFlags & NSCommandKeyMask;
		
		DHPMDisplayWindow *displayWindow = (DHPMDisplayWindow *)[[NSApp delegate] window];
		
		displayWindow.alphaValue = isHoldingCommand ? 1.0 : 0.2;
		displayWindow.ignoresMouseEvents = !isHoldingCommand;
	}
	else if(theEvent.type == NSMouseMoved)
	{
		NSLog(@"Mouse moved!");
	}
}
*/
 
@end

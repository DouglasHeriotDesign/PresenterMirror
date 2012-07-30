//
//  DHPMDisplayWindow.m
//  PresenterMirror
//
//  Created by Douglas Heriot on 31/07/12.
//  Copyright (c) 2012 Douglas Heriot. All rights reserved.
//

#import "DHPMDisplayWindow.h"

@implementation DHPMDisplayWindow

- (BOOL)canBecomeKeyWindow
{
	return YES;
}

- (BOOL)canBecomeVisibleWithoutLogin
{
	return YES;
}

- (BOOL)isMovableByWindowBackground
{
	return YES;
}

@end

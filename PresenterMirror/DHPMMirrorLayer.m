//
//  DHPMMirrorLayer.m
//  PresenterMirror
//
//  Created by Douglas Heriot on 20/08/13.
//  Copyright (c) 2013 Douglas Heriot. All rights reserved.
//

#import "DHPMMirrorLayer.h"
#import "NSScreen_Extension.h"
#include <OpenGL/CGLTypes.h>
#include <OpenGL/gl.h>
#include <OpenGL/glext.h>
#import <IOSurface/IOSurface.h>
#import <OpenGL/CGLIOSurface.h>

@interface DHPMMirrorLayer()
{
	CGDisplayStreamRef displayStream;
	IOSurfaceRef iosurface;
	CGRect mirroredScreenFrame;
	CGSize mirroredScreenSize;
	
	BOOL hasCreatedTexture;
	GLuint surfaceTexture;
}
@property (strong) dispatch_queue_t queue;
@property BOOL hasDrawnLastSurface;
@end

@implementation DHPMMirrorLayer

- (id)init
{
	if(self = [super init])
	{
		self.queue = dispatch_queue_create("com.douglasheriot.presentermirror2.screenCapture", DISPATCH_QUEUE_SERIAL);
	}
	return self;
}

- (void)setMirroredScreen:(NSScreen *)mirroredScreen
{
	_mirroredScreen = mirroredScreen;
	
	if(displayStream)
	{
		CGDisplayStreamStop(displayStream);
		CFRelease(displayStream);
	}
	
	mirroredScreenFrame = mirroredScreen.frame;
	mirroredScreenSize = mirroredScreenFrame.size;
	
	// Account for retina displays
	mirroredScreenSize.width *= mirroredScreen.backingScaleFactor;
	mirroredScreenSize.height *= mirroredScreen.backingScaleFactor;
	
	displayStream = CGDisplayStreamCreateWithDispatchQueue(mirroredScreen.displayID, mirroredScreenSize.width, mirroredScreenSize.height, 'BGRA', nil, self.queue, ^(CGDisplayStreamFrameStatus status, uint64_t displayTime, IOSurfaceRef frameSurface, CGDisplayStreamUpdateRef updateRef) {
		
		if(status == kCGDisplayStreamFrameStatusFrameComplete && frameSurface)
		{
			IOSurfaceRef old = iosurface;
			
			iosurface = frameSurface;
			self.hasDrawnLastSurface = NO;
			
			CFRetain(iosurface);
			IOSurfaceIncrementUseCount(frameSurface);
			
			if(old)
			{
				IOSurfaceDecrementUseCount(old);
				CFRelease(old);
			}
		}
	});
	
	CGDisplayStreamStart(displayStream);
	
}

- (void)drawInCGLContext:(CGLContextObj)ctx pixelFormat:(CGLPixelFormatObj)pf forLayerTime:(CFTimeInterval)t displayTime:(const CVTimeStamp *)ts
{
	if(!hasCreatedTexture)
	{
		glGenTextures(1, &surfaceTexture);
		hasCreatedTexture = YES;
	}
	
	glEnable(GL_TEXTURE_RECTANGLE_ARB);
	glBindTexture(GL_TEXTURE_RECTANGLE_ARB, surfaceTexture);
	CGLError err = CGLTexImageIOSurface2D(ctx, GL_TEXTURE_RECTANGLE_ARB, GL_RGBA, mirroredScreenSize.width, mirroredScreenSize.height, GL_BGRA, GL_UNSIGNED_INT_8_8_8_8_REV, iosurface, 0);
	
	if(err != kCGLNoError)
	{
		//NSLog(@"CGLTexImageIOSurface2D failed!");
		glClearColor(0, 0, 0, 1);
		glClear(GL_COLOR_BUFFER_BIT);
		return;
	}
	
	glTexParameteri(GL_TEXTURE_RECTANGLE_ARB, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_RECTANGLE_ARB, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_RECTANGLE_ARB, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_RECTANGLE_ARB, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

	glColor4f(1.0, 1.0, 1.0, 1.0);
	
	GLfloat textureCoords[] = {
		0, mirroredScreenSize.height,
		mirroredScreenSize.width, mirroredScreenSize.height,
		mirroredScreenSize.width, 0,
		0, 0};
	
	GLfloat vertices[] = {
		-1.0, -1.0,
		1.0, -1.0,
		1.0, 1.0,
		-1.0, 1.0
	};
	
	glShadeModel(GL_SMOOTH);
	
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glTexCoordPointer(2, GL_FLOAT, 0, textureCoords);
	glEnableClientState(GL_VERTEX_ARRAY);
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	
	glDisable(GL_TEXTURE_COORD_ARRAY);
	glDisable(GL_VERTEX_ARRAY);
	
	
	glBindTexture(GL_TEXTURE_RECTANGLE_ARB, 0);
	glDisable(GL_TEXTURE_RECTANGLE_ARB);
	glShadeModel(GL_FLAT);
	
	self.hasDrawnLastSurface = YES;
}

- (BOOL)canDrawInCGLContext:(CGLContextObj)ctx pixelFormat:(CGLPixelFormatObj)pf forLayerTime:(CFTimeInterval)t displayTime:(const CVTimeStamp *)ts
{
	return !self.hasDrawnLastSurface;
}

- (BOOL)isAsynchronous
{
	return YES;
}

@end

//
//  JEFormulas.h
//  JEToolkit
//
//  Created by John Rommel Estropia on 2014/01/05.
//  Copyright (c) 2014 John Rommel Estropia. All rights reserved.
//

#ifndef JEToolkit_JEFormulas_h
#define JEToolkit_JEFormulas_h

#import "JECompilerDefines.h"


#pragma mark - Clamping Values

JE_STATIC_INLINE JE_CONST JE_OVERLOAD
double JEClamp(double min, double value, double max)
{
	return MIN(max, MAX(min, value));
}

JE_STATIC_INLINE JE_CONST JE_OVERLOAD
NSInteger JEClamp(NSInteger min, NSInteger value, NSInteger max)
{
	return MIN(max, MAX(min, value));
}

JE_STATIC_INLINE JE_CONST JE_OVERLOAD
NSUInteger JEClamp(NSUInteger min, NSUInteger value, NSUInteger max)
{
	return MIN(max, MAX(min, value));
}


#pragma mark - Geometry

JE_STATIC_INLINE JE_CONST JE_OVERLOAD
double JEAngleRadians(double degrees)
{
	return (M_PI * degrees / 180.0);
}

JE_STATIC_INLINE JE_CONST JE_OVERLOAD
double JEAngleRadians(CGPoint point1, CGPoint point2)
{
	return atan((point2.y - point1.y) / (point1.x - point2.x));
}

JE_STATIC_INLINE JE_CONST JE_OVERLOAD
double JEAngleDegrees(double radians)
{
	return (180.0 * radians / M_PI);
}

JE_STATIC_INLINE JE_CONST JE_OVERLOAD
double JEAngleDegrees(CGPoint point1, CGPoint point2)
{
	return JEAngleDegrees(JEAngleRadians(point1, point2));
}

JE_STATIC_INLINE JE_CONST
CGPoint JEPoint(CGPoint startPoint, double angle, double distance)
{
    return (CGPoint){
        .x = (startPoint.x + (sin(angle) * distance)),
        .y = (startPoint.y + (cos(angle) * distance))
    };
}

JE_STATIC_INLINE JE_CONST
double JEDistance(CGPoint point1, CGPoint point2)
{
    return hypot((point1.x - point2.x), (point1.y - point2.y));
}

JE_STATIC_INLINE JE_CONST JE_CONST JE_OVERLOAD
CGPoint JEPointMidpoint(CGPoint point1, CGPoint point2)
{
    return (CGPoint){
        .x = ((point1.x + point2.x) * 0.5f),
        .y = ((point1.y + point2.y) * 0.5f),
    };
}

JE_STATIC_INLINE JE_CONST
CGRect JERect(CGPoint midpoint, CGFloat width, CGFloat height)
{
    return (CGRect){
        .origin.x = (midpoint.x - (width * 0.5f)),
        .origin.y = (midpoint.y - (height * 0.5f)),
        .size.width = width,
        .size.height = height
    };
}

JE_STATIC_INLINE JE_CONST JE_CONST JE_OVERLOAD
CGPoint JERectCenter(CGRect rect)
{
	return (CGPoint){ .x = CGRectGetMidX(rect), .y = CGRectGetMidY(rect) };
}

JE_STATIC_INLINE JE_CONST
CGSize JESizeScaled(CGSize size, CGFloat scale)
{
    return (CGSize){ .width = (size.width * scale), .height = (size.height * scale) };
}


#pragma mark - Random

JE_STATIC_INLINE
NSInteger JERandom(NSInteger min, NSInteger max)
{
    return ((NSInteger)arc4random_uniform((u_int32_t)(max - min + 1)) + min);
}



#endif

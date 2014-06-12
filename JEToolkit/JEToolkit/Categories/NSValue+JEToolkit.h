//
//  NSValue+JEToolkit.h
//  JEToolkit
//
//  Created by John Rommel Estropia on 2013/11/26.
//  Copyright (c) 2013 John Rommel Estropia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSValue (JEToolkit)

+ (NSValue *)valueWithWeakObject:(id)weakObject;
- (id)weakObjectValue;

@end

//
//
//  Created by Kurt Jacobs
//  Copyright © 2016 RandomDudes. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "KSJArchConfiguration.h"

@interface KSJFullyConnectedArchConfiguration : KSJArchConfiguration <KSJArchProtocol>

@property (nonatomic, readonly) NSInteger inputSize;
@property (nonatomic, readonly) NSInteger outputSize;

@property (nonatomic, readonly) NSValue *weightBuffer;
@property (nonatomic, readonly) NSValue *biasBuffer;

@property (nonatomic, readonly) NSInteger activationFunction;

@end

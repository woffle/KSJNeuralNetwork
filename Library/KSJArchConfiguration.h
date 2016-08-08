//
//
//  Created by Kurt Jacobs
//  Copyright © 2016 RandomDudes. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>

@protocol KSJArchProtocol <NSObject>

@required
+ (instancetype)archFromStructureBuffer:(int *)s_buffer weightBuffer:(void *)w_buffer biasBuffer:(void *)b_buffer dataType:(NSInteger)dataType activation:(NSInteger)activation;
+ (instancetype)archFromStructureBufferWrapped:(int *)s_buffer weightBuffer:(NSValue *)w_buffer biasBuffer:(NSValue *)b_buffer dataType:(NSInteger)dataType activation:(NSInteger)activation;

@end

@interface KSJArchConfiguration : NSObject

@property (nonatomic, readonly) NSString *layerName;
@property (nonatomic, readonly) NSInteger dataType;
@property (nonatomic, readonly) NSInteger activationFunction;

@end

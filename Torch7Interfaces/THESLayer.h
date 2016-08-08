//
//
//  Created by Kurt Jacobs
//  Copyright © 2016 RandomDudes. All rights reserved.
//
//

#import <Foundation/Foundation.h>

extern NSString * const THES_layer_activations[];
extern NSString * const THES_tensor_types[];

@interface THESLayer : NSObject

@property (nonatomic) NSNumber *layerType;
@property (nonatomic) NSValue *weightsBuffer;
@property (nonatomic) NSUInteger weightsBufferSize;
@property (nonatomic) NSValue *biasBuffer;
@property (nonatomic) NSUInteger biasBufferSize;
@property (nonatomic) NSValue *structureBuffer;

/*! @brief Accepts an array of THESLayers and clears the bias and weight buffers for each instance.
 *  @param layers An array of THESLayers.
 */
+ (void)freeLayerBuffers:(NSArray *)layers;

- (instancetype)initWithLayerType:(NSNumber *)layerType weightBuffer:(NSValue *)wBuffer weightBufferSize:(NSUInteger)wBufferSize biasBuffer:(NSValue *)bBuffer weightBufferSize:(NSUInteger)bBufferSize andStructureBuffer:(NSValue *)structureBuffer;

/*! @brief Clears the bias and weight buffers.
 */
- (void)freeBuffers;

@end

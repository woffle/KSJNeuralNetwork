//
//
//  Created by Kurt Jacobs
//  Copyright © 2016 RandomDudes. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#import "KSJConvolutionArchConfiguration.h"
#import "KSJFullyConnectedArchConfiguration.h"
#import "KSJPoolingArchConfiguration.h"

#if (!TARGET_OS_SIMULATOR)
    #import <MetalPerformanceShaders/MetalPerformanceShaders.h>
#endif

typedef NS_ENUM(NSUInteger, KSJNeuralNetworkDevice)
{
    KSJNeuralNetworkDeviceNONE,
    KSJNeuralNetworkDeviceCPU,
    KSJNeuralNetworkDeviceGPU
};

@protocol KSJNeuralNetworkProtocol <NSObject>

@required
- (BOOL)createFullyConnectedLayerWithConfiguration:(KSJFullyConnectedArchConfiguration *)configuration;
- (BOOL)createConvolutionLayerWithConfiguration:(KSJConvolutionArchConfiguration *)configuration;
- (BOOL)createPoolingLayerWithConfiguration:(KSJPoolingArchConfiguration *)configuration;
- (NSValue *)forward:(NSValue *)data;

@end

@interface KSJNeuralNetwork : NSObject

@property (nonatomic, readonly) NSMutableArray *nnGraphStructure;
@property (nonatomic, readonly) NSInteger nnDatatype;
@property (nonatomic, readonly) NSMutableArray *nnModel;
@property (nonatomic, readonly) KSJNeuralNetworkDevice nnDevice;

/*! @brief Returns a string representation of the model architecture.
 */
- (NSString *)graphToString;

/*! @brief Adds a Fully Connected Layer based on the specifications provided in the FCAC (Fully Connected Architecture Configuration)
 *  @param configuration The Full Connected Layer Configuration.
 */
- (void)addFullyConnectedLayerWithConfiguration:(KSJFullyConnectedArchConfiguration *)configuration;

/*! @brief Adds a Convolution Layer based on the specifications provided in the CAC (Convolution Architecture Configuration)
 *  @param configuration The Convolution Layer Configuration.
 */
- (void)addConvolutionLayerWithConfiguration:(KSJConvolutionArchConfiguration *)configuration;

/*! @brief Adds a Max Pooling Layer based on the specifications provided in the PAC (Pooling Architecture Configuration)
 *  @param configuration The Max Pooling Layer Configuration.
 */
- (void)addMaxPoolingLayerWithConfiguration:(KSJPoolingArchConfiguration *)configuration;

/*! @brief Adds a Average Pooling Layer based on the specifications provided in the PAC (Pooling Architecture Configuration)
 *  @param configuration The Average Pooling Layer Configuration.
 */
- (void)addAveragePoolingLayerWithConfiguration:(KSJPoolingArchConfiguration *)configuration;

/*! @brief Builds the model based on the architecture defined by the configurations provided in addMaxPoolingLayerWithConfiguration:, addFullyConnectedLayerWithConfiguration:, etc.
 *  @param dataType the datatype that should be used Int, Float or Double CPU supports all however GPU supports on Float.
 */
- (void)buildGraphWithDataType:(NSInteger)dataType;
// ^--- Move This To Sub Class So We Can Use BNNS ENUMs and MPS ENUMs for this method.

/*! @brief Destroy the model created by buildGraphWithDataType:
 */
- (void)destroyGraph;

/*! @brief Performs the inference based on the model built using buildGraphWithDataType:
 *  @param data a pointer to the input buffer.
 */
- (NSValue *)forward:(NSValue *)data;

/*! @brief Sets the input and output channels/planes of Convolution and Pooling layers based on input size.
 *  @param geometry input size.
 */
- (void)setGeometryForConvolutionAndPoolingLayers:(CGPoint)geometry;

@end

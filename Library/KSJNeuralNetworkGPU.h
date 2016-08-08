//
//
//  Created by Kurt Jacobs
//  Copyright © 2016 RandomDudes. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "KSJNeuralNetwork.h"

@interface KSJNeuralNetworkGPU : KSJNeuralNetwork <KSJNeuralNetworkProtocol>

/*! @brief Creates a GPU accelerated Fully Connected Layer based on the specifications provided in the FCAC (Fully Connected Architecture Configuration)
 *  @param configuration The Full Connected Layer Configuration.
 */
- (BOOL)createFullyConnectedLayerWithConfiguration:(KSJFullyConnectedArchConfiguration *)configuration;

/*! @brief Creates a GPU accelerated Convolution Layer based on the specifications provided in the CAC (Convolution Architecture Configuration)
 *  @param configuration The Convolution Layer Configuration.
 */
- (BOOL)createConvolutionLayerWithConfiguration:(KSJConvolutionArchConfiguration *)configuration;

/*! @brief Creates a GPU accelerated Average or Max Pooling Layer based on the specifications provided in the PAC (Pooling Architecture Configuration)
 *  @param configuration The Pooling Layer Configuration.
 */
- (BOOL)createPoolingLayerWithConfiguration:(KSJPoolingArchConfiguration *)configuration;

@end

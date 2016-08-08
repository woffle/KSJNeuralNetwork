//
//
//  Created by Kurt Jacobs
//  Copyright © 2016 RandomDudes. All rights reserved.
//
//

#import <Foundation/Foundation.h>


@interface KSJBNNSExtras : NSObject

/*! @brief Applies SoftMax to an input vector (SoftMax is defined as e^x/sum(e^x)
 *  @param vector the NSArray vector
 */
+ (NSArray *)softmax:(NSArray *)vector;

/*! @brief Applies SoftMax to an input vector (SoftMax is defined as e^x/sum(e^x)
 *  @param vector The float* vector
 *  @param vector_len The float* vector length
 */
+ (float *)softmax:(float *)vector vector_len:(NSInteger)vector_len;

/*! @brief Finds the minimum value in a vector and returns the index
 *  @param vector the float* vector
 *  @param vector_len The float* vector length
 */
+ (NSInteger)min_value_in_vector:(float *)vector vector_len:(NSInteger)vector_len;

/*! @brief Finds the maximum value in a vector and returns the index
 *  @param vector the float* vector
 *  @param vector_len The float* vector length
 */
+ (NSInteger)max_value_in_vector:(float *)vector vector_len:(NSInteger)vector_len;
@end

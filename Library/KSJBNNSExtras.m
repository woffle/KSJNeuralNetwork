//
//
//  Created by Kurt Jacobs
//  Copyright © 2016 RandomDudes. All rights reserved.
//
//

#import "KSJBNNSExtras.h"

@implementation KSJBNNSExtras

+ (NSArray *)softmax:(NSArray *)vector
{
    NSMutableArray *elements = [NSMutableArray array];
    float sum = 0.0f;
    for (int i = 0; i < vector.count; i++)
    {
        float exp = expf([vector[i] floatValue]);
        [elements addObject:@(exp)];
        sum += exp;
    }
    for (int i = 0; i < elements.count; i++)
    {
        elements[i] = @([elements[i] floatValue]/sum);
    }
    return elements;
}

+ (float *)softmax:(float *)vector vector_len:(NSInteger)vector_len
{
    float *elements = calloc(vector_len, sizeof(float));
    float sum = 0.0f;
    for (int i = 0; i < vector_len; i ++)
    {
        float exp = expf(vector[i]);
        elements[i] = exp;
        sum += exp;
    }
    for (int i = 0; i < vector_len; i ++)
    {
        elements[i] = elements[i] / sum;
    }
    return elements;
}

+ (NSInteger)max_value_in_vector:(float *)vector vector_len:(NSInteger)vector_len
{
    float max_index = -1;
    float max_value = FLT_MIN;
    for (int i = 0; i < vector_len; i++)
    {
        float v = vector[i];
        if (v > max_value)
        {
            max_value = v;
            max_index = i;
        }
    }
    return max_index+1;
}

+ (NSInteger)min_value_in_vector:(float *)vector vector_len:(NSInteger)vector_len
{
    float min_index = -1;
    float min_value = FLT_MAX;
    for (int i = 0; i < vector_len; i++)
    {
        float v = vector[i];
        if (v < min_value)
        {
            min_value = v;
            min_index = i;
        }
    }
    return min_index+1;
}

@end

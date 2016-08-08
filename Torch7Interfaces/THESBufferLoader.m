//
//
//  Created by Kurt Jacobs
//  Copyright © 2016 RandomDudes. All rights reserved.
//
//

#import "THESBufferLoader.h"
#import "THESSampleBuffer.h"

@implementation THESBufferLoader

+ (NSArray *)readSamplesBuffer:(NSString *)path
{
    NSMutableArray *samples = [NSMutableArray array];
    NSFileHandle *f = [NSFileHandle fileHandleForReadingAtPath:path];
    int sample_count = 0;
    [[f readDataOfLength:sizeof(int)] getBytes:&sample_count length:sizeof(int)];
    
    int buffer_len = 0;
    float *buffer = 0;
    int label = 0;
    
    for (int i = 0; i < sample_count ; i ++)
    {
        [[f readDataOfLength:sizeof(int)] getBytes:&buffer_len length:sizeof(int)];
        buffer = (float *)calloc(buffer_len,sizeof(float));
        for (int j = 0; j < buffer_len; j++)
        {
            float readValue;
            [[f readDataOfLength:sizeof(float)] getBytes:&readValue length:sizeof(float)];
            buffer[j] = readValue;
        }
        [[f readDataOfLength:sizeof(int)] getBytes:&label length:sizeof(int)];
        
        THESSampleBuffer *sample_buffer = [THESSampleBuffer new];
        sample_buffer.buffer = [NSValue valueWithPointer:buffer];
        sample_buffer.bufferLength = buffer_len;
        sample_buffer.label = label;
        [samples addObject:sample_buffer];
    }
    
    [f closeFile];
    return samples;
}

@end

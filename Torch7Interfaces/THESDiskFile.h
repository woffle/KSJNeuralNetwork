//
//
//  Created by Kurt Jacobs
//  Copyright © 2016 RandomDudes. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "THESLayer.h"

@interface THESDiskFile : NSObject

/*! @brief Reads a .t7ios file on disk and returns an array of THESLayer objects.
 *  @param path The path to the .t7ios file on disk.
 */
+ (NSArray *)readLayersBinary:(NSString *)path;

@end

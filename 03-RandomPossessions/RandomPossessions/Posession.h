//
//  Posession.h
//  RandomPossessions
//
//  Created by Marjan Hratson on 7/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Posession : NSObject {

    NSString *posessionName;
    NSString *serialNumber;
    int valueInDollars;
    NSDate *dateCreated;
    
}

+ (id)randomPosession;

- (id)initWithName:(NSString *)name 
    valueInDollars:(int) value
       serialNumber:(NSString *)num;

// default attributes of properties:
// atomic, readwrite, assign
// 

@property (nonatomic,retain) NSString *posessionName;
@property (nonatomic,retain) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly) NSDate *dateCreated;

-(void)dealloc;

@end

//
//  ResumenArticulo.h
//  melitest
//
//  Created by Diego de Paz Sierra on 11/28/14.
//  Copyright (c) 2014 depa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ResumenArticulo : NSObject

@property (nonatomic,strong) NSString * itemId;
@property (nonatomic,strong) NSString * titulo;
@property (nonatomic,strong) NSNumber * precio;
@property (nonatomic,strong) NSString * moneda;
@property (nonatomic,strong) NSString * imagenUrl;
@property (nonatomic,strong) UIImage * imagen;

+(instancetype) initWithDictionary:(NSDictionary*) dictionary;

@end

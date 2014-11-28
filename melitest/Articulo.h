//
//  Articulo.h
//  melitest
//
//  Created by Diego de Paz Sierra on 11/28/14.
//  Copyright (c) 2014 depa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Articulo : NSObject

+(instancetype) initWithDictionary:(NSDictionary*) dictionary;

@property (nonatomic,strong) NSString * itemId;
@property (nonatomic,strong) NSString * titulo;
@property (nonatomic,strong) NSNumber * precio;
@property (nonatomic,strong) NSString * moneda;
@property (nonatomic,strong) NSArray * imagenesUrl;
@property (nonatomic,strong) NSMutableArray * imagenes;


@end

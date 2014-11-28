//
//  Articulo.m
//  melitest
//
//  Created by Diego de Paz Sierra on 11/28/14.
//  Copyright (c) 2014 depa. All rights reserved.
//

#import "Articulo.h"

@implementation Articulo

+(instancetype) initWithDictionary:(NSDictionary*) dictionary{
    
    Articulo * articulo = [[Articulo alloc] init];
    articulo.itemId = dictionary[@"id"];
    articulo.titulo = dictionary[@"title"];
    articulo.precio = dictionary[@"price"];
    articulo.moneda = dictionary[@"currency_id"];
    
    NSMutableArray * imagenesUrl = [NSMutableArray arrayWithCapacity:0];
    
    for (NSDictionary * imagenD in dictionary[@"pictures"]){
        NSString * url = imagenD[@"url"];
        
        [imagenesUrl addObject:url];
    }
    
    articulo.imagenesUrl = imagenesUrl;
    
    articulo.imagenes = [NSMutableArray arrayWithCapacity:0];
    
    return articulo;
    
}

@end

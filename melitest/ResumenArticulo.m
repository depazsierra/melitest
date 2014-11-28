//
//  ResumenArticulo.m
//  melitest
//
//  Created by Diego de Paz Sierra on 11/28/14.
//  Copyright (c) 2014 depa. All rights reserved.
//

#import "ResumenArticulo.h"

@implementation ResumenArticulo

+(instancetype) initWithDictionary:(NSDictionary*) dictionary{
    
    ResumenArticulo * articulo = [[ResumenArticulo alloc] init];
    articulo.itemId = dictionary[@"id"];
    articulo.titulo = dictionary[@"title"];
    articulo.precio = dictionary[@"price"];
    articulo.moneda = dictionary[@"currency_id"];
    articulo.imagenUrl = dictionary [@"thumbnail"];
    
    return articulo;
    
}

@end

//
//  ServiciosWeb.m
//  melitest
//
//  Created by Diego de Paz Sierra on 11/28/14.
//  Copyright (c) 2014 depa. All rights reserved.
//

#import "ServiciosWeb.h"

static ServiciosWeb * _sharedInstance = nil;
static NSString *baseURL = @"https://api.mercadolibre.com";
static NSString *consultaURL = @"/sites/MLA/search?q=";
static NSString *detalleItem = @"/items";


@implementation ServiciosWeb

+(ServiciosWeb *)sharedInstance {
    if (!_sharedInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedInstance = [[ServiciosWeb alloc] init];
        });
    }
    return _sharedInstance;
}

-(void)buscarProductos:(NSString *) textoFiltro completion:(void (^)(NSDictionary * dictionary))completion failedBlock:(void (^)(NSString * error))failed{
    
    NSMutableString * url = [NSMutableString stringWithFormat:@"%@%@\"%@\"",baseURL, consultaURL, textoFiltro];
    
    [self GET:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        completion(jsonDict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed([NSString stringWithFormat:@"Fallo en devolver los resultados de busqueda"]);
    }];
}

-(void)buscarProductos:(NSString *) textoFiltro limit:(NSNumber*)limit offset:(NSNumber*)offset completion:(void (^)(NSDictionary * dictionary))completion failedBlock:(void (^)(NSString * error))failed{
    
    NSMutableString * url = [NSMutableString stringWithFormat:@"%@%@\"%@\"&limit=%@&offset=%@",baseURL, consultaURL, textoFiltro,limit,offset];
    
    
    [self GET:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        completion(jsonDict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed([NSString stringWithFormat:@"Fallo en devolver los resultados de busqueda"]);
    }];
}

-(void)buscarProductos:(NSString *) textoFiltro offset:(NSNumber*)offset completion:(void (^)(NSDictionary * dictionary))completion failedBlock:(void (^)(NSString * error))failed{
    
    NSMutableString * url = [NSMutableString stringWithFormat:@"%@%@\"%@\"&offset=%@",baseURL, consultaURL, textoFiltro,offset];
    
    
    [self GET:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        completion(jsonDict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed([NSString stringWithFormat:@"Fallo en devolver los resultados de busqueda"]);
    }];
}

-(void)detalleProducto:(NSString*)itemId completion:(void (^)(NSDictionary * dictionary))completion failedBlock:(void (^)(NSString * error))failed{
    
    NSMutableString * url = [NSMutableString stringWithFormat:@"%@%@\%@",baseURL, detalleItem, itemId];
    
    
    [self GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        completion(jsonDict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed([NSString stringWithFormat:@"Fallo en devolver el devolver el detalle del item"]);
    }];
}



@end

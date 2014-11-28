//
//  ServiciosWeb.h
//  melitest
//
//  Created by Diego de Paz Sierra on 11/28/14.
//  Copyright (c) 2014 depa. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface ServiciosWeb : AFHTTPRequestOperationManager

+(ServiciosWeb*) sharedInstance;

//Primeros resultados de la busqueda por filtro
-(void)buscarProductos:(NSString *) textoFiltro completion:(void (^)(NSDictionary * dictionary))completion failedBlock:(void (^)(NSString * error))failed;

//Consulta de articulos, con datos de cantidad por pantalla y nro de pagina
-(void)buscarProductos:(NSString *) textoFiltro limit:(NSNumber*)limit offset:(NSNumber*)offset completion:(void (^)(NSDictionary * dictionary))completion failedBlock:(void (^)(NSString * error))failed;

//Consulta de articulos, con dato del nro de pagina
-(void)buscarProductos:(NSString *) textoFiltro offset:(NSNumber*)offset completion:(void (^)(NSDictionary * dictionary))completion failedBlock:(void (^)(NSString * error))failed;

//Devuelve el detalle de un articulo
-(void)detalleProducto:(NSString*)itemId completion:(void (^)(NSDictionary * dictionary))completion failedBlock:(void (^)(NSString * error))failed;

@end

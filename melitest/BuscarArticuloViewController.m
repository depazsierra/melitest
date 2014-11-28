//
//  BuscarArticuloViewController.m
//  melitest
//
//  Created by Diego de Paz Sierra on 11/28/14.
//  Copyright (c) 2014 depa. All rights reserved.
//

#import "BuscarArticuloViewController.h"
#import "ServiciosWeb.h"
#import "ResumenArticulo.h"
#import <MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "CeldaArticulo.h"
#import "DetalleArticuloViewController.h"


#define OFFSET_Y_TEXTFIELD 65
#define OFFSET_Y_RESULT 100
#define CELL_SIZE 60
#define LINE_SEPARATOR 1
#define FOOTER_SIZE 30

@interface BuscarArticuloViewController ()<UITextFieldDelegate>

@property (weak,nonatomic) UIScrollView * resultView;
@property (weak,nonatomic) UITextField * filtroText;
@property (strong, nonatomic) NSMutableArray * datasource;

@end

@implementation BuscarArticuloViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
    [self setupView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - private methods

-(void) setupView {
    self.title = @"Búsqueda de Articulos";
    
    [self createTextField];
    
    //dissmiss teclado con un tap
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchScreen)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void) createTextField{
    
    CGRect frame = self.view.frame;
    
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(10, OFFSET_Y_TEXTFIELD, frame.size.width-20, 32)];
    textField.placeholder = @"Buscar articulo";
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    textField.delegate = self;
    self.filtroText = textField;
    [self.view addSubview:textField];
}


-(void)didTouchScreen{
    [self.filtroText resignFirstResponder];

}

- (void) cargarDatos:(NSString*) filtro {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Cargando";
    
    [[ServiciosWeb sharedInstance] buscarProductos:filtro completion:^(NSDictionary *dictionary) {
        
        NSDictionary * results = dictionary[@"results"];
        self.datasource = [NSMutableArray arrayWithCapacity:0];
        
        for (NSDictionary * result in results){
            ResumenArticulo * articulo = [ResumenArticulo initWithDictionary:result];
            
            [self.datasource addObject:articulo];
            
        }
        
        [self refreshData];
        
        [hud hide:YES];
    } failedBlock:^(NSString *error) {
        NSLog(@"%@", error);
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"MELI" message:@"Problemas de conexión. Por favor, intente más tarde." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [alert show];
        [hud hide:YES];
        
    }];
    
}


#pragma mark - Metodos de la tabla de resultados
//Con estos metodos se arma la clase que implemente el custom table view
- (void) refreshData {
    
    [self crearTableView];
    
   
    for ( NSInteger numeroCelda = 0; numeroCelda < self.datasource.count; numeroCelda++) {
        
        [self.resultView addSubview:[self crearCelda:numeroCelda]];
        [self.resultView addSubview:[self lineaSeparadora:numeroCelda]];
        
        
        self.resultView.contentSize = CGSizeMake(self.resultView.frame.size.width, CELL_SIZE*(numeroCelda+1)
                                            + LINE_SEPARATOR*numeroCelda);
    }
    
}

- (void) crearTableView {
    
    if (self.resultView) {
        [self.resultView removeFromSuperview];
        self.resultView = nil;
    }
    
    CGRect frame = self.view.frame;
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, OFFSET_Y_RESULT, frame.size.width, frame.size.height-OFFSET_Y_RESULT)];
    
    scrollView.scrollEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    
    [scrollView setBackgroundColor:[UIColor greenColor]];
    
    [self.view addSubview:scrollView];
    self.resultView = scrollView;
}

-(UIView*) crearCelda:(NSInteger) numero{
    
    ResumenArticulo * articulo = self.datasource[numero];
    
    CGRect frame = self.resultView.frame;
    CeldaArticulo * view = [[CeldaArticulo alloc] initWithFrame:CGRectMake(0, CELL_SIZE*numero+LINE_SEPARATOR*numero, frame.size.width, CELL_SIZE)];
    view.numero = numero;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchView:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [view addGestureRecognizer:tapGestureRecognizer];
    
    
    CGRect frameView  = view.frame;
    
    NSLog(@"frame %f %f %f %f",frameView.origin.x, frameView.origin.y, frameView.size.width, frameView.size.height);
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [view addSubview:imageView];
    UIActivityIndicatorView * activity = [[UIActivityIndicatorView alloc] init];
    [activity setHidesWhenStopped:YES];
    activity.center = CGPointMake(30, 30);
    [view addSubview:activity];
    
    [activity startAnimating];
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:articulo.imagenUrl]
                                                        options:0
                                                       progress:nil
                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                          
                                                          if (image && finished)
                                                          {
                                                              articulo.imagen = image;
                                                              imageView.image  = image;
                                                          }
                                                          [activity stopAnimating];
                                                          
                                                      }];
    
    UILabel * tituloLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 8, frameView.size.width-76, 54)];
    tituloLabel.numberOfLines = 0;
    tituloLabel.text = articulo.titulo;
    [view addSubview:tituloLabel];
    tituloLabel.font = [UIFont systemFontOfSize:14];
    
   
    
    
    return view;
}

-(UIView*) lineaSeparadora:(NSUInteger) numero{
    CGRect frame = self.resultView.frame;
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, CELL_SIZE*(numero+1)
                                                             + LINE_SEPARATOR*numero, frame.size.width, LINE_SEPARATOR)];
    
    CGRect frameView  = view.frame;
    
    NSLog(@"linea separadora %f %f %f %f",frameView.origin.x, frameView.origin.y, frameView.size.width, frameView.size.height);
    [view setBackgroundColor:[UIColor blackColor]];
    
    return view;
}

#pragma mark - actions

-(void)touchView:(UITapGestureRecognizer*)sender {
    DetalleArticuloViewController * vc = [[DetalleArticuloViewController alloc] init];
    CeldaArticulo * celda = sender.view;
    ResumenArticulo * articulo =  self.datasource[celda.numero];
    vc.itemId = articulo.itemId;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - text field delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.filtroText resignFirstResponder];
    [self cargarDatos:self.filtroText.text];
    
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  DetalleArticuloViewController.m
//  melitest
//
//  Created by Diego de Paz Sierra on 11/28/14.
//  Copyright (c) 2014 depa. All rights reserved.
//

#import "DetalleArticuloViewController.h"
#import "ServiciosWeb.h"
#import "Articulo.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD.h>
#import "KASlideShow.h"

#define OFFSET_INICIAL_Y 65
#define OFFSET_Y_BOTONES 305
#define OFFSET_Y_TITULO 323
#define OFFSET_Y_PRECIO 365

@interface DetalleArticuloViewController ()

@property (nonatomic,strong) Articulo * articulo;
@property (nonatomic) BOOL imagenesCargadas;
@property (nonatomic,strong) KASlideShow * slideshow;

@end

@implementation DetalleArticuloViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
    [self cargarDatos];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods

-(void) setupView {
    self.imagenesCargadas = NO;
    self.title = @"Detalle Articulo";
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
}


- (void) cargarDatos{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Cargando";
    
    [[ServiciosWeb sharedInstance] detalleProducto:self.itemId completion:^(NSDictionary *dictionary) {
        
        self.articulo = [Articulo initWithDictionary:dictionary];
        
        if (self.articulo.imagenesUrl.count > 0) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText=@"Cargando";
            [self cargarImagen:0];
        } else {
            
            //TODO
            [self refreshView];
        }
         [hud hide:YES];
    } failedBlock:^(NSString *error) {
        NSLog(@"%@", error);
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"MELI" message:@"Problemas de conexión. Por favor, intente más tarde." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [alert show];
        [hud hide:YES];
        
    }];
    
}

-(void) cargarImagen:(NSInteger) numero {

    
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:self.articulo.imagenesUrl[numero]]
                                                        options:0
                                                       progress:nil
                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                          
                                                          if (image && finished)
                                                          {
                                                              [self.articulo.imagenes addObject:image ];
                                                              image = nil;
                                                              if (numero < self.articulo.imagenesUrl.count-1) {
                                                                  [self cargarImagen:numero+1];
                                                              } else {
                                                                  self.imagenesCargadas = YES;
                                                                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                                  [self refreshViewWithImages];
                                                              }
                                                          }
                                                          
                                                      }];
    
}

-(void) refreshViewWithImages {
    CGRect frame = self.view.frame;
    
    self.slideshow = [[KASlideShow alloc] initWithFrame:CGRectMake(0,65,frame.size.width,250)];
    [self.slideshow setDelay:3]; // Delay between transitions
    [self.slideshow setTransitionDuration:1]; // Transition duration
    [self.slideshow setTransitionType:KASlideShowTransitionFade]; // Choose a transition type (fade or slide)
    [self.slideshow setImagesContentMode:UIViewContentModeScaleAspectFit]; // Choose a content mode for images to display
    
    self.slideshow.clipsToBounds = YES;
    
    for (UIImage * image in self.articulo.imagenes) {
        [_slideshow addImage:image];
    }
    
    
    UIButton *anteriorBoton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    anteriorBoton.frame = CGRectMake(20, OFFSET_Y_BOTONES, 80, 44);
    [anteriorBoton setTitle:@"Anterior" forState:UIControlStateNormal];
    [anteriorBoton addTarget:self action:@selector(anteriorFoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:anteriorBoton];
    
    UIButton *siguienteBoton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    siguienteBoton.frame = CGRectMake(frame.size.width-80-8, OFFSET_Y_BOTONES,80 , 44);
    [siguienteBoton setTitle:@"Siguiente" forState:UIControlStateNormal];
    [siguienteBoton addTarget:self action:@selector(siguienteFoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:siguienteBoton];
    
    
    UILabel * tituloLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, OFFSET_Y_TITULO, frame.size.width-20, 60)];
    tituloLabel.numberOfLines = 0;
    tituloLabel.text = self.articulo.titulo;
    [self.view addSubview:tituloLabel];
    tituloLabel.font = [UIFont systemFontOfSize:15];
    
    UILabel * precioLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, OFFSET_Y_PRECIO, frame.size.width-20, 30)];
    precioLabel.numberOfLines = 0;
    precioLabel.text =  [NSString stringWithFormat:@"%@ %@", self.articulo.precio, self.articulo.moneda];
    [self.view addSubview:precioLabel];
    precioLabel.font = [UIFont systemFontOfSize:14];
    
    
    [self.view addSubview:self.slideshow];
    
}

-(void) refreshView {
    
}

-(void) anteriorFoto:(id)sender {
    [self.slideshow previous];
}

-(void) siguienteFoto:(id)sender {
    [self.slideshow next];
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

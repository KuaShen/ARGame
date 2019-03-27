//
//  JFViewController.m
//  ARGame
//
//  Created by KuaShen on 03/19/2019.
//  Copyright (c) 2019 KuaShen. All rights reserved.
//

#import "JFViewController.h"
#import "JFScene.h"
#import <ARKit/ARKit.h>

API_AVAILABLE(ios(11.0))
@interface JFViewController ()<ARSKViewDelegate>{
    SCNScene *scene;
    NSString *defaultPath;
}

@property (strong, nonatomic) ARSKView *sceneView;
//@property (strong, nonatomic) IBOutlet ARSKView *sceneView;



@end

@implementation JFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view = self.sceneView;
    
    // Set the view's delegate
    _sceneView.delegate = self;
    
    // Show statistics such as fps and node count
    _sceneView.showsFPS = true;
    _sceneView.showsNodeCount = true;
    
    JFScene *scene = [JFScene sceneWithSize:_sceneView.bounds.size];
    scene.scaleMode = SKSceneScaleModeResizeFill;
    [_sceneView presentScene:scene];
    
//    let scene = Scene(size: sceneView.bounds.size)
//    scene.scaleMode = .resizeFill
//    sceneView.presentScene(scene)
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Create a session configuration
    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
    
    // Run the view's session
    [self.sceneView.session runWithConfiguration:configuration];
    
//    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap)];
//    [self.sceneView addGestureRecognizer:tapGesture];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Pause the view's session
    [self.sceneView.session pause];
}

- (NSInteger)randomInt:(NSInteger)min and:(NSInteger)max{
    return min + (NSUInteger)arc4random_uniform((uint32_t)(max - min + 1));
}

#pragma mark - ARSCNViewDelegate

/*
 // Override to create and configure nodes for anchors added to the view's session.
 - (SCNNode *)renderer:(id<SCNSceneRenderer>)renderer nodeForAnchor:(ARAnchor *)anchor {
 SCNNode *node = [SCNNode new];
 
 // Add geometry to the node...
 
 return node;
 }
 */
- (SKNode *)view:(ARSKView *)view nodeForAnchor:(ARAnchor *)anchor{
    
    NSInteger ghostId = [self randomInt:1 and:6];
    
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"ghost%ld", ghostId]];
    node.name = @"ghost";
    
    return node;
}

- (void)session:(ARSession *)session didFailWithError:(NSError *)error {
    // Present an error message to the user
    
}

- (void)sessionWasInterrupted:(ARSession *)session {
    // Inform the user that the session has been interrupted, for example, by presenting an overlay
    
}

- (void)sessionInterruptionEnded:(ARSession *)session {
    // Reset tracking and/or remove existing anchors if consistent tracking is required
    
}



@end

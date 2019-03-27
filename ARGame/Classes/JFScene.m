//
//  JFScene.m
//  ARGame_Example
//
//  Created by mac on 2019/3/26.
//  Copyright © 2019 KuaShen. All rights reserved.
//

#import "JFScene.h"
#import <ARKit/ARKit.h>

@interface JFScene()

@property (strong, nonatomic) SKLabelNode *ghostsLabel;

@property (strong, nonatomic) SKLabelNode *numberOfGhostsLabel;

@property (nonatomic) NSTimeInterval creationTime;

@property (nonatomic, assign) NSInteger ghostCount;

@property (strong, nonatomic) SKAction *killSound;

@end

@implementation JFScene

- (void)sceneDidLoad{
    
    _ghostsLabel = [SKLabelNode labelNodeWithText:@"Ghosts"];
    _ghostCount = 0;
    _numberOfGhostsLabel = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%ld",(long)_ghostCount]];
    _creationTime = 0;

    _killSound = [SKAction playSoundFileNamed:@"ghost" waitForCompletion:false];
    
    
    
}


- (void)didMoveToView:(SKView *)view{
    
    _ghostsLabel.fontSize = 20;
    _ghostsLabel.fontName = @"DevanagariSangamMN-Bold";
    _ghostsLabel.color = [UIColor whiteColor];
    _ghostsLabel.position = CGPointMake(40, 50);
    [self.scene addChild:_ghostsLabel];
    
    _numberOfGhostsLabel.fontSize = 30;
    _numberOfGhostsLabel.fontName = @"DevanagariSangamMN-Bold";
    _numberOfGhostsLabel.color = [UIColor whiteColor];
    _numberOfGhostsLabel.position = CGPointMake(40, 10);
    [self.scene addChild:_numberOfGhostsLabel];
    
    
}

- (void)update:(NSTimeInterval)currentTime{
    
    if (currentTime > _creationTime) {
        [self createGhostAnchor];
        _creationTime = currentTime + [self randomFloat:3.0 and:6.0];
        
    }
}


- (void)createGhostAnchor{
    if (![self.view isKindOfClass:[ARSKView class]]) {
        return;
    }
    
    float _360degree = 2.0 * M_PI;
    
    simd_float4x4 rotateX = SCNMatrix4ToMat4(SCNMatrix4MakeRotation(_360degree * [self randomFloat:0.0 and:1.0], 1, 0, 0));
    
    simd_float4x4 rotateY = SCNMatrix4ToMat4(SCNMatrix4MakeRotation(_360degree * [self randomFloat:0.0 and:1.0], 0, 1, 0));
    
    simd_float4x4 rotation = simd_mul(rotateX, rotateY);
    
    simd_float4x4 translation = matrix_identity_float4x4;
    translation.columns[3].z = -1 - [self randomFloat:0.0 and:1.0];
    
    simd_float4x4 transform = simd_mul(rotation, translation);
    
    ARAnchor *anchor = [[ARAnchor alloc]initWithTransform:transform];
    
    ARSKView *sceneView = (ARSKView *)self.view;
    [sceneView.session addAnchor:anchor];

    // Increment the counter
    _ghostCount += 1;
    [self refrash];
}

- (void)refrash{
    _numberOfGhostsLabel.text = [NSString stringWithFormat:@"%ld",(long)_ghostCount];
}

- (float)randomFloat:(float)min and:(float)max{
    return (arc4random() * 1.0f / 0xFFFFFFFF) * (max - min) + min;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    if (!touch){return;}
    
    CGPoint location = [touch locationInNode:self];
    NSArray<SKNode *>*hit = [self nodesAtPoint:location];
    SKNode *node = hit.firstObject;
    if (node) {
        if ([node.name isEqualToString:@"ghost"]) {
            SKAction *fadOut = [SKAction fadeOutWithDuration:.5];
            SKAction *remove = [SKAction removeFromParent];
            SKAction *groupKillingActions = [SKAction group:@[fadOut, _killSound]];
            SKAction *sequenceAction = [SKAction sequence:@[groupKillingActions, remove]];
            [node runAction:sequenceAction];
            
            _ghostCount -= 1;
            if (_ghostCount < 0) {
                _ghostCount = 0;
                [self removeAllChildren];
                [self.scene addChild:_ghostsLabel];
                [self.scene addChild:_numberOfGhostsLabel];
            }
            [self refrash];
        }
    }
    
    
}




@end

#import "PAGPlayerView.h"
#import <libpag/PAGView.h>
#import <libpag/PAGSurface.h>
#import <libpag/PAGPlayer.h>
#import <libpag/PAGMovie.h>

@implementation PAGPlayerView {
    PAGView* pagView;
    NSString* pagPath;
    EAGLContext *context;
    PAGSurface * surface;
    PAGPlayer * player;
}

- (void)loadPAGAndPlay: (NSString*)pagPath{
    if (pagView != nil) {
        [pagView stop];
        [pagView removeFromSuperview];
        pagView = nil;
    }
    pagView = [[PAGView alloc] init];

    [self testFile: pagPath];

    [self addSubview:pagView];
    pagView.frame = self.frame;
    [pagView setRepeatCount:-1];
    [pagView play];
}

- (void)testFile: (NSString*)path {
    NSString* fileName = [path substringToIndex:path.length-4];
    NSString* extension = [path substringFromIndex:path.length-3];
    pagPath = [[NSBundle mainBundle] pathForResource:fileName ofType:extension];
    PAGFile* pagFile = [PAGFile Load:pagPath];
    [pagView setComposition:pagFile];
}

- (void)stop {
    if (pagView != nil) {
        [pagView stop];
        [pagView removeFromSuperview];
        pagView = nil;
    }
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    if ([pagView isPlaying]) {
        [pagView stop];
    } else {
        [pagView play];
    }

}

- (PAGComposition *)getCurrentComposition {
    return [pagView getComposition];
}

- (void)replaceMovie:(NSArray<NSString *> *)moviePaths {
    NSInteger num = [self numImages];
    for (int i = 0; i < moviePaths.count; i++) {
      PAGMovie* movie = [PAGMovie MakeFromFile:moviePaths[i]];
      [(PAGFile*)[pagView getComposition] replaceImage:i data:movie];
    }
}

- (NSInteger)numImages {
    return [(PAGFile*)[pagView getComposition] numImages];
}
@end

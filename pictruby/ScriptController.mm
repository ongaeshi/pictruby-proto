#import "ScriptController.h"

@implementation ScriptController
{
    UIImageView* mImageView;
}

- (id) initWithScriptName:(char*)scriptPath
{
    self = [super init];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];

    // TODO: Call mruby script
    UIImage *image = [UIImage imageNamed:@"sample.jpg"];

    // TODO: Adjust navbar
    mImageView = [[UIImageView alloc] initWithImage:image];
    mImageView.frame = self.view.frame;
    mImageView.contentMode = UIViewContentModeScaleAspectFit; //UIViewContentModeCenter?
    [self.view addSubview:mImageView];
}

@end

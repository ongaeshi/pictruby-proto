#import "ScriptController.h"

#import "BindImage.hpp"
#import "mruby.h"
#import "mruby/class.h"
#import "mruby/compile.h"
#import "mruby/irep.h"
#import "mruby/string.h"

@implementation ScriptController
{
    UIImageView* mImageView;
    const char* mScriptPath;
}

- (id) initWithScriptName:(char*)scriptPath
{
    self = [super init];
    mScriptPath = scriptPath;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];

    // TODO: Call mruby script
    UIImage *image = [self callScript];

    // TODO: Adjust navbar
    mImageView = [[UIImageView alloc] initWithImage:image];
    mImageView.frame = self.view.frame;
    mImageView.contentMode = UIViewContentModeScaleAspectFit; //UIViewContentModeCenter?
    [self.view addSubview:mImageView];
}

- (UIImage*)callScript
{
    mrb_state* mrb = mrb_open();

    // Bind
    pictruby::BindImage::Bind(mrb);

    // Load builtin library
    // mrb_load_irep(mrb, BuiltIn);
    
    // Load user script
    FILE *fd = fopen(mScriptPath, "r");
    mrb_load_file(mrb, fd);
    fclose(fd);

    // Call "convert()"
    int ai = mrb_gc_arena_save(mrb);
    mrb_value ret = mrb_funcall(mrb, mrb_obj_value(mrb->kernel_module), "convert", 0);
    mrb_gc_arena_restore(mrb, ai);

    // NSLog(@"ret val : %d", mrb_fixnum(ret));

    return pictruby::BindImage::ToPtr(mrb, ret);
}

@end

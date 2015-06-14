#import "ScriptController.h"

#import "BindImage.hpp"
#import "mruby.h"
#import "mruby/class.h"
#import "mruby/compile.h"
#import "mruby/irep.h"
#import "mruby/string.h"

@implementation ScriptController
{
    NSTimer* mTimer;
    int mValue;
    UIImagePickerController* mImagePicker;
    const char* mScriptPath;
    UIImageView* mImageView;
    
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

    // Create timer
    mTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/30.0 target:self selector:@selector(timerProcess) userInfo:nil repeats:YES];
    mValue = 0;

    // Create ImagePicker
    mImagePicker = [[UIImagePickerController alloc] init];
    [mImagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [mImagePicker setAllowsEditing:YES];
    [mImagePicker setDelegate:self];
    // [self presentViewController:mImagePicker animated:YES completion:nil];

    // Call mruby script
    UIImage *image = [self callScript];

    // TODO: Adjust navbar
    mImageView = [[UIImageView alloc] initWithImage:image];
    mImageView.frame = self.view.frame;
    mImageView.contentMode = UIViewContentModeScaleAspectFit; //UIViewContentModeCenter?
    [self.view addSubview:mImageView];
}

- (void)timerProcess
{
    mValue++;
    NSLog(@"timer %d", mValue);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    if (image) {
    }

    [self dismissViewControllerAnimated:YES completion:nil];
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

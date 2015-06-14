#import "ScriptController.h"

#import "BindImage.hpp"
#import "mruby.h"
#import "mruby/class.h"
#import "mruby/compile.h"
#import "mruby/irep.h"
#import "mruby/string.h"

@implementation ScriptController
{
    const char* mScriptPath;
    mrb_state* mMrb;
    NSTimer* mTimer;
    int mValue;
    UIImagePickerController* mImagePicker;
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

    // Create ImagePicker
    mImagePicker = [[UIImagePickerController alloc] init];
    [mImagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [mImagePicker setAllowsEditing:YES];
    [mImagePicker setDelegate:self];
    // [self presentViewController:mImagePicker animated:YES completion:nil];

    // Create timer
    mTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/30.0 target:self selector:@selector(timerProcess) userInfo:nil repeats:YES];
    mValue = 0;

    // Init mruby
    [self initScript];
}

- (void)timerProcess
{
    // Call mruby script
    UIImage *image = [self callScript];

    mValue++;
    NSLog(@"timer %d", mValue);

    // TODO: Adjust navbar
    mImageView = [[UIImageView alloc] initWithImage:image];
    mImageView.frame = self.view.frame;
    mImageView.contentMode = UIViewContentModeScaleAspectFit; //UIViewContentModeCenter?
    [self.view addSubview:mImageView];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    if (image) {
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initScript
{
    mMrb = mrb_open();

    // Bind
    pictruby::BindImage::Bind(mMrb);

    // Load builtin library
    // mrb_load_irep(mMrb, BuiltIn);

    // Load user script
    FILE *fd = fopen(mScriptPath, "r");
    mrb_load_file(mMrb, fd);
    fclose(fd);
}

- (UIImage*)callScript
{
    // Call "convert()"
    int ai = mrb_gc_arena_save(mMrb);
    mrb_value ret = mrb_funcall(mMrb, mrb_obj_value(mMrb->kernel_module), "convert", 0);
    mrb_gc_arena_restore(mMrb, ai);

    // NSLog(@"ret val : %d", mrb_fixnum(ret));

    // TODO: mrb_close

    return pictruby::BindImage::ToPtr(mMrb, ret);
}

@end

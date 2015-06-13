#import <UIKit/UIKit.h>

@interface ScriptController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
- (id) initWithScriptName:(char*)scriptPath;
@end

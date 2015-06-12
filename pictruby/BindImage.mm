#import "BindImage.hpp"

#import "mruby.h"
#import "mruby/class.h"
#import "mruby/data.h"
#import "mruby/string.h"

namespace pictruby {

namespace {
void free(mrb_state *mrb, void *p)
{
    // TODO: retain?
}

struct mrb_data_type data_type = { "pictruby_image", free };

mrb_value load(mrb_state *mrb, mrb_value self)
{
    UIImage* obj = [UIImage imageNamed:@"sample.jpg"];
    return BindImage::ToMrb(mrb, obj);
}

}

mrb_value BindImage::ToMrb(mrb_state* mrb, UIImage* aPtr)
{
    struct RData *data = mrb_data_object_alloc(mrb, mrb_class_get(mrb, "Image"), (__bridge void*)aPtr, &data_type); //TODO inc?
    return mrb_obj_value(data);
}


//----------------------------------------------------------
UIImage* BindImage::ToPtr(mrb_state* mrb, mrb_value aValue)
{
    if (!mrb_obj_is_instance_of(mrb, aValue, mrb_class_get(mrb, "Image"))) {
        mrb_raise(mrb, E_TYPE_ERROR, "wrong argument class");
    }

    return (__bridge UIImage*)(DATA_PTR(aValue));
}

//----------------------------------------------------------
void BindImage::Bind(mrb_state* mrb)
{
    struct RClass *cc = mrb_define_class(mrb, "Image", mrb->object_class);

    mrb_define_class_method(mrb , cc, "load",               load,               MRB_ARGS_REQ(1));
    // mrb_define_class_method(mrb , cc, "sample",             sample,             MRB_ARGS_REQ(1));
    // mrb_define_class_method(mrb , cc, "grab_screen",        grab_screen,        MRB_ARGS_OPT(4));
                                                             
    // mrb_define_method(mrb, cc,        "clone",              clone,              MRB_ARGS_NONE());
    // // mrb_define_method(mrb, cc,        "save",               save,               MRB_ARGS_ARG(2, 1));
    // mrb_define_method(mrb, cc,        "color",              color,              MRB_ARGS_REQ(2));
    // mrb_define_method(mrb, cc,        "set_color",          set_color,          MRB_ARGS_REQ(3));
    // mrb_define_method(mrb, cc,        "resize",             resize,             MRB_ARGS_REQ(2));
    // mrb_define_method(mrb, cc,        "set_image_type",     set_image_type,     MRB_ARGS_REQ(1));
    // mrb_define_method(mrb, cc,        "crop",               crop,               MRB_ARGS_REQ(4));
    // mrb_define_method(mrb, cc,        "crop!",              crop_bang,          MRB_ARGS_REQ(4));
    // mrb_define_method(mrb, cc,        "rotate90",           rotate90,           MRB_ARGS_OPT(1));
    // mrb_define_method(mrb, cc,        "mirror",             mirror,             MRB_ARGS_REQ(2));
    // mrb_define_method(mrb, cc,        "update",             update,             MRB_ARGS_NONE());
    // mrb_define_method(mrb, cc,        "set_anchor_percent", set_anchor_percent, MRB_ARGS_REQ(2));
    // mrb_define_method(mrb, cc,        "set_anchor_point",   set_anchor_point,   MRB_ARGS_REQ(2));
    // mrb_define_method(mrb, cc,        "reset_anchor",       reset_anchor,       MRB_ARGS_REQ(2));
    // mrb_define_method(mrb, cc,        "draw",               draw,               MRB_ARGS_ARG(2, 2));
    // mrb_define_method(mrb, cc,        "draw_sub",           draw_sub,           MRB_ARGS_ARG(6, 2));
    // mrb_define_method(mrb, cc,        "height",             height,             MRB_ARGS_NONE());
    // mrb_define_method(mrb, cc,        "width",              width,              MRB_ARGS_NONE());
    // mrb_define_method(mrb, cc,        "each_pixels",        each_pixels,        MRB_ARGS_OPT(2));
    // mrb_define_method(mrb, cc,        "map_pixels",         map_pixels,         MRB_ARGS_OPT(2));
}

}
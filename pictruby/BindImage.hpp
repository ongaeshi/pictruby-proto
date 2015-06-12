#pragma once

#include "mruby.h"

//----------------------------------------------------------
namespace pictruby {

class BindImage {
public:
    static void Bind(mrb_state* mrb);
};

}

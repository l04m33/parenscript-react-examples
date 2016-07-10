#!/bin/sh

sbcl --noinform \
     --load ~/workspace/lisp/quicklisp_env/dummy/setup.lisp \
     --load psx.lisp \
     --load ps-compile.lisp \
     --eval "(ps-compile:batch-compile \"$1\" \"$2\")" \
     --quit

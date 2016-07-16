Intro
#####

These are the official `React examples`_ ported to `Parenscript`_ .

.. _React examples: https://github.com/facebook/react/tree/15-stable/examples
.. _Parenscript: https://common-lisp.net/project/parenscript/

How to Run
##########

You'll need `SBCL`_ and `Quicklisp`_ .

1. Install Quicklisp and run ``(ql:quickload :parenscript)`` in your
   SBCL environment.

2. Compile the Parenscript code. For example, to compile the
   ``basic`` example,

   .. code-block:: text

       ❯ sbcl --load psx.lisp --load ps-compile.lisp --eval '(ps-compile:batch-compile "examples/basic/package.lisp" "examples/basic/")'

3. Load the corresponding ``index.html`` file in a modern browser.

.. _SBCL: http://sbcl.org/
.. _Quicklisp: https://www.quicklisp.org/

About the PSX Syntax
####################

``psx.lisp`` implements a small syntax for Parenscript that is
equivalent to `JSX`_ for Javascript. Codes written in PSX are
ultimately transformed into React API calls. You can see it in
action in the examples.

I got this idea (And the name, of course) from `cl-react`_ . And
since I was just trying things out, I decided to build my own
simpler wheels :)

.. _JSX: https://babeljs.io/docs/plugins/transform-react-jsx/
.. _cl-react: https://github.com/helmutkian/cl-react

License
#######

MIT.

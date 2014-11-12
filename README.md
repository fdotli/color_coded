color_coded: semantic highlighting with vim
---
color_coded is a vim plugin that provides realtime (fast), tagless code highlighting for C++, C, and Objective C using libclang.

  * Fast compilation, using native C++14
  * Lua binding for VimL -> C++
  * Exhaustive customization possibilities

**NOTE:** color_coded is currently _alpha_ software; use it knowing shit may break (but it'll be colorfully broken).

color_coded | normal
:----------:|:-----:
<img width="90%" src="https://raw.githubusercontent.com/jeaye/color_coded/colorscheme/res/col_1.png"/> | <img width="100%" src="https://raw.githubusercontent.com/jeaye/color_coded/colorscheme/res/no_col_1.png"/>
<img width="90%" src="https://raw.githubusercontent.com/jeaye/color_coded/colorscheme/res/col_2.png"/> | <img width="100%" src="https://raw.githubusercontent.com/jeaye/color_coded/colorscheme/res/no_col_2.png"/>

Installation
---
Installation has been tested using [vundle](https://github.com/gmarik/Vundle.vim), but should also be compatible with [pathogen](https://github.com/tpope/vim-pathogen). To install using vundle (add the line to your `~/.vimrc`, restart vim, run `:BundleInstall`):

```viml
Bundle 'jeaye/color_coded'
```

Since color_coded has a compiled component, you'll need to manually compile when installing and updating. Compilation works as follows, assuming usage of vundle:

```bash
cd ~/.vim/bundle/color_coded
./configure && make
```

For various compatibility reasons, color_coded will attempt to download a known version of clang. This may add time to your configuration process, but it offers more stability across multiple platforms.

**NOTE:** color_coded, to my knowledge, has not been tested on Windows.

Usage
---
Once color_coded is installed and compiled, it will automatically begin working the next time you start vim. In order for color_coded to know how your code must be compiled, you _may_ need to create a file describing the required compiler options. Note, color_coded assumes sane defaults and tries to allow for immediate usage (it favors C++ in this regard).

That said, in any non-trivial case, you'll find yourself needing to supply a `.color_coded` file for your project. color_coded will search from the current working directory all the way up to the root of the filesystem looking for a `.color_coded` file. This makes it possible for you to have one in your home directory, for example, and then in each of your projects' directories. If you don't specify one in a project directory, the one in your home directory is used. Again, if no such files are found, sane defaults will be applied.

**color_coded will try its hardest to highlight your code for you, even if there are errors in the translation unit.** This allows for better highlighting while typing and highlighting of valid code when color_coded doesn't know everything about your project.

You can test that color_coded is working properly after installation by running `make run`, which will open a small C++ file known to be valid. Highlighting compilation may take a second, but, after moving the cursor, you should see the code becomes highlighted.

### .color_coded file contents
The contents of a `.color_coded` file is simply a line-separated list of compiler options. For example, the `.color_coded` file for color_coded is:

```
-std=c++1y
-Iinclude
-I/usr/lib/clang/3.5.0/include
```

**NOTE:** Out of simplicity, no other data is permitted in the `.color_coded` file. That is to say, comments are not supported.

Options
---

#### `g:color_coded_filetypes`
This option controls the filetypes for which color_coded will try to compile.

Default:
```viml
let g:color_coded_filetypes = ['c', 'h', 'cpp', 'hpp', 'cc', 'm', 'mm']
```

Highlighting
---
There are many new highlighting groups which color_coded adds. They are designed to follow [libclang's internals](http://clang.llvm.org/doxygen/group__CINDEX.html#gaaccc432245b4cd9f2d470913f9ef0013) as closely as possible. To tie things together, some wrapper groups have been created that will allow more sweeping changes. The clang groups, by default, are mapped to use these, along with vim's normal groups (`Function`, `Macro`, `Number`, etc).

#### Generic groups
```viml
hi Member # Any non-static member variable
hi Variable # Any non-member variable
hi Namespace 
hi EnumConstant
```

#### Example of clang groups
```
hi link StructDecl Type
hi link UnionDecl Type
hi link ClassDecl Type
hi link EnumDecl Type
```

For more information on all of the supported groups, see `after/syntax/color_coded.vim` and the [clang documentation](http://clang.llvm.org/doxygen/group__CINDEX.html#gaaccc432245b4cd9f2d470913f9ef0013).

Commands
---

#### `:CCerror`
This command outputs the last compilation error message from libclang. If your highlighting is not working properly, you may have a misconfigured `.color_coded` file or you may have syntax errors in your source. When in doubt, check here first.

Dependencies
---
Compilation of color_coded requires a modern compiler:
  * GCC ≥ 4.9
  * Clang ≥ 3.4

Usage of color_coded requires vim:
  * Version: 7.4p330+
  * Compiled with Lua support (+lua)

Troubleshooting
---

#### The highlighting isn't refreshed in a new buffer until I move the cursor
This is intentional. The first time you open a buffer, color_coded doesn't know if it's going to compile properly and it doesn't want you to wait while it tries to figure this out. color_coded will always compile in the background and events like moving the cursor or changing text will poll for updates. **Note, however,** that, once a buffer has highlighting, leaving that buffer and coming back to it will synchronously apply the previous highlighting.

#### "color_coded unavailable: you need to compile it"
See the above installation docs. When you install color_coded, you need to manually `./configure && make` (any errors will be reported) before you can successfully use it.

#### "color_coded has been updated: you need to recompile it"
Assuming you've updated a working installation of color_coded, you'll get this error if the update requires you to recompile color_coded (i.e. there have been changes to the native API). To recompile, follow the same exact steps you took to compile initially. Generally, this just means `./configure && make`.

#### "xz is required to unpack clang"
As of clang 5.0, both Linux and OS X tarballs are compressed with [xz](http://tukaani.org/xz/). To install, consider one of the following (or further documentation for your OS/distribution):  
###### OS X
```bash
brew install xz # for homebrew
port install xz # for macports
```
###### Ubuntu/Debian
```bash
sudo apt-get install xz-utils
```

License
---
color_coded is under the MIT open-source license.  
See the `LICENSE` file or http://opensource.org/licenses/MIT

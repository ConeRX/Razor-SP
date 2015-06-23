// Script header for module 'CustomDialogGui'
//
// Version: 1.4
//
// Author: Dirk Kreyenberg (abstauber)
//   Please use the PM function on the AGS forums to contact
//   me about problems with this module
// 
// Abstract: Adds a scrollable dialog GUI, which is easy to customize.
//
// Dependencies:
//
//   AGS 3.1.2 SP1 or later
//
//
// Usage:
// If you want to modify the dialog GUI at runtime, put
// following at top of your room script:
//
//   import CustomDialogGui CDG;
//
// After that, you can access all the options this way:
//
//   CDG.bg_color=10;
//
//
// Syntax of dialog options in icon mode:
//  ([d/i][icon],[highlighted icon])Text
// 
//  Example: (d12,13)Want a cup of tea?
// 
//  This means, the topic uses sprite slot 12 as a normal icon,
//  slot 13 for the highlighted icon and it's a dialog item.
//
//  Example: (i14,15)Jelly Beans
//
//  This adds an "inventory-topic" which is sorted after the dialog topics.
//
// Please make also sure to uncheck "say" in the dialog editor. If you want the topic to be said,
// you have to add the text in the dialog itself.
//
//
// Caveats:
//  - The border line thickness is fixed at 1px
//  - There's no space between the bullets and the dialog text
//    You have to manage that via transparent pixels
//
// Revision History
// 1.0    initial release
// 1.1    customizable from roomscripts
// 1.2    Mousewheel support, fixed scrolling bugs, added optional space between lines,
//        added optional line numbering
// 1.2.1  Bugs fixed: wrong text height with auto numbering, outline border in hires. 
// 1.2.2  Bug fixed: translated options weren't shown correctly
// 1.3    Added auto-adjusting height and width
//        Added GUI appearing at mouse position
//        Added background scaling
// 1.4    Added support for icons as dialog options
//        Added Icons can be sorted vertically or horizontally
//        Added custom border decorations
//        Added sorting two kinds of dialog options
//        Added GUI stays centered on screen
//        Bugfix: GUI borders sometimes not accurate  
//
// 1.5    Added: Anchor point for autosize
//        Added: x/y-offset for scroll arrow images 
//        Added: Bottom-up sorting for text and vertical icons
//        Bugfix: GUI borders and highlighting corrected
//        
//
// Licence:
//
//   CustomDialogGui AGS script module
//   Copyright (C) 2008,2009 Dirk Kreyenberg
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to 
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in 
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
// DEALINGS IN THE SOFTWARE.

enum CDGMode {
	eTextMode,
  eIconMode
};

enum CDGAnchorPoint {
  eAnchorTopLeft, 
  eAnchorTopRight, 
  eAnchorBottomLeft, 
  eAnchorBottomRight
};
struct CustomDialogGui {
  import function init();
  import function setAutosizeCorners(int upleft, int upright, int downleft, int downright);
  import function setAutosizeBorders(int top, int left, int bottom, int right);
  import function _prepare(DialogOptionsRenderingInfo *info);
  import function _getOptionDetails(DialogOptionsRenderingInfo *info);
  import function _addOption(int position, int optionNumber, String optionText);
  import function _getRowCount(int width);
  CDGMode gui_type;
  int gui_xpos;
  int gui_ypos;
  bool gui_pos_at_cursor;
  int gui_width;
  int gui_height;
  int gui_parser_xpos;
  int gui_parser_ypos;
  int gui_parser_width;
  bool autosize_height;
  bool autosize_width;
  int yscreenborder;
  int xscreenborder;
  CDGAnchorPoint anchor_point;
  int autosize_minheight;
  int autosize_maxheight;
  int autosize_minwidth;
  int autosize_maxwidth;  
  bool gui_stays_centered_x;
  bool gui_stays_centered_y;
  int auto_arrow_align;
  int auto_arrow_up_offset_x;
  int auto_arrow_up_offset_y;
  int auto_arrow_down_offset_x;
  int auto_arrow_down_offset_y;  
  
  int bullet;
  int uparrow_img;
  int uparrow_xpos;
  int uparrow_ypos;
  int downarrow_img;
  int downarrow_xpos;
  int downarrow_ypos;

  int border_top;
  int border_bottom;
  int border_left;
  int border_right;
  int border_visible;
  int border_color;

  bool seperator_visible;
  bool seperator_color;
  bool mousewheel;
  bool reset_scrollstate;
  bool dialog_options_upwards;
  int bg_img; 
  int bg_img_scaling;
  int bg_img_transparency;
  int bg_color;

  int text_font;
  int text_color;
  int text_color_active;
  int text_alignment;
  int text_bg;
  int text_bg_xpos;
  int text_bg_scaling;
  int text_bg_transparency;  
  int text_line_space;
  int text_numbering;
  bool icon_align_horizontal;
  bool icon_show_text_vertical;
  bool icon_text_vert_center;
  bool icon_horizontal_center;
  
  bool icon_sort_inv;
  int icon_inv_linefeed;
  
  // internal Stuff from here on
  int scroll_from;
  int scroll_to;
  int icons_per_row;
  int icon_rows;
  int icon_count_first_row;
  int linefeed_after_icon;
  int max_option_height;
  int max_option_width;
  int active_options_count;  
  int debug_ocount;
  int debug_maxheight;
  int debug_maxwidth;
  int debug_calcguiwidth;
  int debug_calcguiheight;
  bool lock_xy_pos;
  bool borderDeco;
  int borderDecoCornerUpleft;
  int borderDecoCornerUpright;
  int borderDecoCornerDownleft;
  int borderDecoCornerDownright;
  int borderDecoFrameTop;
  int borderDecoFrameLeft;
  int borderDecoFrameBottom;
  int borderDecoFrameRight;
  int locked_xpos;
  int locked_ypos;
  
};

int CDG_active_options[];
int CDG_active_options_height[];
int CDG_active_options_width[];
int CDG_active_options_sprite[];
int CDG_active_options_hisprite[];
int CDG_active_options_per_row[];
String CDG_active_options_text[];

struct CDG_Arrow {
  int x1;
  int y1;
  int x2;
  int y2;
};
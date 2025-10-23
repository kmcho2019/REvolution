module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

// Parallel comparison of scancode with each arrow key code
wire is_left  = (scancode == 16'he06b);
wire is_down  = (scancode == 16'he072);
wire is_right = (scancode == 16'he074);
wire is_up    = (scancode == 16'he075);

// Direct assignment of outputs (priority encoded)
assign left  = is_left;
assign down  = is_down  & ~is_left;   // Down only if not left
assign right = is_right & ~(is_left | is_down);  // Right only if neither left nor down
assign up    = is_up    & ~(is_left | is_down | is_right);  // Up only if none others

endmodule
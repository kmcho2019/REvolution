module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Parallel comparators for each arrow key
    wire is_left  = (scancode == 16'he06b);
    wire is_down  = (scancode == 16'he072);
    wire is_right = (scancode == 16'he074);
    wire is_up    = (scancode == 16'he075);

    // Priority encoder (left has highest priority)
    assign left  = is_left;
    assign down  = is_down  & ~is_left;
    assign right = is_right & ~(is_left | is_down);
    assign up    = is_up    & ~(is_left | is_down | is_right);

endmodule
module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Individual key detection
    wire left_pressed  = (scancode == 16'he06b);
    wire down_pressed  = (scancode == 16'he072);
    wire right_pressed = (scancode == 16'he074);
    wire up_pressed    = (scancode == 16'he075);

    // Priority encoder (left has highest priority)
    assign left  = left_pressed;
    assign down  = down_pressed & ~left_pressed;
    assign right = right_pressed & ~(left_pressed | down_pressed);
    assign up    = up_pressed & ~(left_pressed | down_pressed | right_pressed);

endmodule
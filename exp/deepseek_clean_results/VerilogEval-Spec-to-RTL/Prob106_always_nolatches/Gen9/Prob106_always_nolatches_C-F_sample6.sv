module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Shared extended key prefix check
    wire is_extended = (scancode[15:8] == 8'he0);
    
    // Individual key comparisons
    wire is_left  = is_extended & (scancode[7:0] == 8'h6b);
    wire is_down  = is_extended & (scancode[7:0] == 8'h72);
    wire is_right = is_extended & (scancode[7:0] == 8'h74);
    wire is_up    = is_extended & (scancode[7:0] == 8'h75);
    
    // Priority-encoded outputs (left has highest priority)
    assign left  = is_left;
    assign down  = is_down & ~is_left;
    assign right = is_right & ~is_left & ~is_down;
    assign up    = is_up & ~is_left & ~is_down & ~is_right;

endmodule
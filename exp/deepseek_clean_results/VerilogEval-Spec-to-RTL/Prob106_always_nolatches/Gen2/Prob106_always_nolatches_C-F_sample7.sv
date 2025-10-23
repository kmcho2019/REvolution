module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // First check if it's an extended key (0xe0 prefix)
    wire is_extended = (scancode[15:8] == 8'he0);
    
    // Map scancodes to arrow key outputs (mutually exclusive)
    assign left  = is_extended & (scancode[7:0] == 8'h6b);  // Left arrow
    assign down  = is_extended & (scancode[7:0] == 8'h72);  // Down arrow
    assign right = is_extended & (scancode[7:0] == 8'h74);  // Right arrow
    assign up    = is_extended & (scancode[7:0] == 8'h75);  // Up arrow

endmodule
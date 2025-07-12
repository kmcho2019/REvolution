module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

// Optimized E0 prefix check (only check necessary bits)
wire is_extended = scancode[15] & ~scancode[14] & ~scancode[13] & 
                  scancode[12] & ~scancode[11] & ~scancode[10] & ~scancode[9] & ~scancode[8];

// Parallel comparisons for each arrow key
assign left  = is_extended & (scancode[7:0] == 8'h6b);
assign down  = is_extended & (scancode[7:0] == 8'h72);
assign right = is_extended & (scancode[7:0] == 8'h74);
assign up    = is_extended & (scancode[7:0] == 8'h75);

endmodule
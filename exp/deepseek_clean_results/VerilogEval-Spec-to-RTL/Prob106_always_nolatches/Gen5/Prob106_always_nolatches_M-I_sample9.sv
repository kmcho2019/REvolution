module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

// Check for E0 prefix (11100000) by examining only necessary bits
wire is_extended = scancode[15] & ~scancode[14] & ~scancode[13] & scancode[12];

// Direct comparisons for each arrow key
assign left  = is_extended & (scancode[7:0] == 8'h6b);
assign down  = is_extended & (scancode[7:0] == 8'h72);
assign right = is_extended & (scancode[7:0] == 8'h74);
assign up    = is_extended & (scancode[7:0] == 8'h75);

endmodule
module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

// Common prefix check (0xE0)
wire is_arrow_key = (scancode[15:8] == 8'hE0);

// Parallel comparison of all target codes
wire is_left   = (scancode[7:0] == 8'h6B);
wire is_down   = (scancode[7:0] == 8'h72);
wire is_right  = (scancode[7:0] == 8'h74);
wire is_up     = (scancode[7:0] == 8'h75);

// Output generation with enable
assign left   = is_arrow_key & is_left;
assign down   = is_arrow_key & is_down;
assign right  = is_arrow_key & is_right;
assign up     = is_arrow_key & is_up;

endmodule
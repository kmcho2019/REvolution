module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

wire [99:0] in_shift_left;
wire [99:0] in_shift_right;
wire [99:0] in_rotate_left;

// Shift input left by 1 (neighbor to the left), fill LSB with 0
assign in_shift_left = {in[98:0], 1'b0};

// Shift input right by 1 (neighbor to the right), fill MSB with 0
assign in_shift_right = {1'b0, in[99:1]};

// Rotate input left by 1 for wrap-around left neighbor (MSB goes to LSB)
assign in_rotate_left = {in[98:0], in[99]};

// out_both: bitwise AND with left neighbor (except MSB set to 0)
assign out_both = in & in_shift_left;
assign out_both[0] = 1'b0;    // Since in[0] has no left neighbor, enforce zero
assign out_both[99] = 1'b0;   // MSB also set to 0 as per spec

// out_any: bitwise OR with right neighbor (except LSB set to 0)
assign out_any = in | in_shift_right;
assign out_any[0] = 1'b0;     // LSB zero, no right neighbor
assign out_any[99] = 1'b0;    // To keep symmetry, set MSB zero as it has no right neighbor

// out_different: XOR input with its left neighbor (wrap-around)
assign out_different = in ^ in_rotate_left;

endmodule
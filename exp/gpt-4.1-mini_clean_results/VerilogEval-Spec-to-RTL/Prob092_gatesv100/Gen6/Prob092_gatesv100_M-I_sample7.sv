module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

wire [99:0] in_shift_left = {in[98:0], 1'b0};  // shift in left by 1, zero lowest bit
wire [99:0] in_shift_right = {1'b0, in[99:1]}; // shift in right by 1, zero highest bit

// out_both: both bit and its left neighbor are 1, highest bit invalid => 0
assign out_both = in & in_shift_left;

// out_any: either bit or its right neighbor is 1, lowest bit invalid => 0
assign out_any = in | in_shift_right;

// out_different: bit differs from its left neighbor with wrap-around (rotate left by 1)
assign out_different = in ^ {in[98:0], in[99]};

endmodule
module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// out_both: Check if current bit and left neighbor are both 1
assign out_both[99] = 1'b0; // No left neighbor for most significant bit
assign out_both[98:0] = in[98:0] & {in[98:1], 1'b0}; // AND with left shifted input

// out_any: Check if current bit or right neighbor is 1
assign out_any[0] = 1'b0; // No right neighbor for least significant bit
assign out_any[99:1] = in[99:1] | {1'b0, in[99:2]}; // OR with right shifted input

// out_different: Check if current bit is different from left neighbor
assign out_different = in ^ {in[0], in[99:1]}; // XOR with left shifted input, wrapping around

endmodule
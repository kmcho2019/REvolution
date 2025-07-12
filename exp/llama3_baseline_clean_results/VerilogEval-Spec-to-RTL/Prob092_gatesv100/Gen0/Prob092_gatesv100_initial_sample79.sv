module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// Generate out_both
assign out_both[99] = 1'b0; // Set leftmost bit to 0
assign out_both[98:0] = in[98:0] & in[99:1]; // AND with neighbour to the left

// Generate out_any
assign out_any[0] = 1'b0; // Set rightmost bit to 0
assign out_any[99:1] = in[99:1] | in[98:0]; // OR with neighbour to the right

// Generate out_different
assign out_different[99] = in[99] ^ in[0]; // XOR with neighbour to the left, considering wrap-around
assign out_different[98:0] = in[98:0] ^ in[99:1]; // XOR with neighbour to the left

endmodule
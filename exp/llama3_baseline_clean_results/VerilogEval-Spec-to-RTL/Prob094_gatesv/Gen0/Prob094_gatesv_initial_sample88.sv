module TopModule(
    input  [3:0] in,
    output [3:1] out_both,
    output [2:0] out_any,
    output [3:0] out_different
);

// out_both: Each bit indicates whether the corresponding input bit and its left neighbor are both '1'
assign out_both[3] = in[3] & in[3]; // no left neighbor, always 0
assign out_both[2] = in[2] & in[3];
assign out_both[1] = in[1] & in[2];
assign out_both[0] = in[0] & in[1];

// out_any: Each bit indicates whether the corresponding input bit or its right neighbor are '1'
assign out_any[2] = in[2] | in[1];
assign out_any[1] = in[1] | in[0];
assign out_any[0] = in[0] | 1'b0; // no right neighbor, always 1 if in[0] is 1

// out_different: Each bit indicates whether the corresponding input bit is different from its left neighbor (wrapping around)
assign out_different[3] = in[3] ^ in[0]; // wrap around to in[0]
assign out_different[2] = in[2] ^ in[3];
assign out_different[1] = in[1] ^ in[2];
assign out_different[0] = in[0] ^ in[1];

endmodule
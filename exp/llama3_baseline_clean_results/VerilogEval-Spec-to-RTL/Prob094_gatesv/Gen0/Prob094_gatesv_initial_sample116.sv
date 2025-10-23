module TopModule(
    input  [3:0] in,
    output [3:1] out_both,
    output [2:0] out_any,
    output [3:0] out_different
);

// out_both: check if current bit and its neighbour to the left are both '1'
assign out_both[3] = 1'b0; // Don't need to calculate out_both[3]
assign out_both[2] = in[2] & in[3];
assign out_both[1] = in[1] & in[2];
assign out_both[0] = in[0] & in[1];

// out_any: check if current bit or its neighbour to the right is '1'
assign out_any[2] = in[2] | in[1];
assign out_any[1] = in[1] | in[0];
assign out_any[0] = 1'b1; // Don't need to calculate out_any[0], it's always 1 if in[0] is 1

// out_different: check if current bit is different from its neighbour to the left (wrapping around)
assign out_different[3] = in[3] ^ in[0]; // in[3]'s neighbour to the left is in[0]
assign out_different[2] = in[2] ^ in[3];
assign out_different[1] = in[1] ^ in[2];
assign out_different[0] = in[0] ^ in[1];

endmodule
module TopModule(
    input  [3:0] in,
    output [3:1] out_both,
    output [2:0] out_any,
    output [3:0] out_different
);

// out_both: Check if current bit and its neighbor to the left are both '1'
assign out_both[3] = in[3] & in[3]; // in[3] has no neighbor to the left, so we use in[3] itself
assign out_both[2] = in[2] & in[3];
assign out_both[1] = in[1] & in[2];
assign out_both[0] = in[0] & in[1];

// out_any: Check if current bit or its neighbor to the right is '1'
assign out_any[2] = in[2] | in[1];
assign out_any[1] = in[1] | in[0];
assign out_any[0] = in[0] | 1'b0; // in[0] has no neighbor to the right, so we use 1'b0

// out_different: Check if current bit is different from its neighbor to the left
assign out_different[3] = in[3] ^ in[0]; // in[3]'s neighbor to the left is in[0] due to wrapping
assign out_different[2] = in[2] ^ in[3];
assign out_different[1] = in[1] ^ in[2];
assign out_different[0] = in[0] ^ in[1];

endmodule
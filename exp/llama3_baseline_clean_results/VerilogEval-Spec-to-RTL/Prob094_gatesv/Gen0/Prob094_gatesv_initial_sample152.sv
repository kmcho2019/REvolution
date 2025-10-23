module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

// out_both: Check if current bit and its neighbor to the left are both 1
assign out_both[0] = in[0] & in[1];
assign out_both[1] = in[1] & in[2];
assign out_both[2] = in[2] & in[3];
assign out_both[3] = 0; // No neighbor to the left for in[3]

// out_any: Check if current bit or its neighbor to the right are 1
assign out_any[0] = 0; // No neighbor to the right for in[0]
assign out_any[1] = in[1] | in[0];
assign out_any[2] = in[2] | in[1];
assign out_any[3] = in[3] | in[2];

// out_different: Check if current bit is different from its neighbor to the left (wrap around)
assign out_different[0] = in[0] ^ in[3];
assign out_different[1] = in[1] ^ in[0];
assign out_different[2] = in[2] ^ in[1];
assign out_different[3] = in[3] ^ in[2];

endmodule
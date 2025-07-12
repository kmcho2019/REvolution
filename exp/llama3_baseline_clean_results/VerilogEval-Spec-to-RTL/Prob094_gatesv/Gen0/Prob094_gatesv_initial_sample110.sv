module TopModule(
    input  [3:0] in,
    output [3:1] out_both,
    output [2:0] out_any,
    output [3:0] out_different
);

// out_both: check each bit and its neighbor to the left
assign out_both[3] = in[3] & in[2];
assign out_both[2] = in[2] & in[1];
assign out_both[1] = in[1] & in[0];

// out_any: check each bit and its neighbor to the right
assign out_any[2] = in[2] | in[1];
assign out_any[1] = in[1] | in[0];
assign out_any[0] = in[0] | in[3]; // wrap around for the last bit

// out_different: check each bit and its neighbor to the left, considering wrap around
assign out_different[3] = in[3] != in[0];
assign out_different[2] = in[2] != in[3];
assign out_different[1] = in[1] != in[2];
assign out_different[0] = in[0] != in[1];

endmodule
module TopModule(
    input  [3:0] in,
    output [2:0] out_both,
    output [3:1] out_any,
    output [3:0] out_different
);

// out_both: both current bit and its neighbor to the left are '1'
assign out_both = {in[2] & in[3], in[1] & in[2], in[0] & in[1]};

// out_any: current bit or its neighbor to the right is '1'
assign out_any = {in[3] | in[2], in[2] | in[1], in[1] | in[0]};

// out_different: current bit is different from its neighbor to the left
assign out_different = {in[3] ^ in[0], in[2] ^ in[3], in[1] ^ in[2], in[0] ^ in[1]};

endmodule
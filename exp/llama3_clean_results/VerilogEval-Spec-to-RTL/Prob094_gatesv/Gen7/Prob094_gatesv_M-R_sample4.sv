module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: each bit indicates if the corresponding input bit and its neighbor to the left are both '1'
    assign out_both[0] = in[0] & in[1];
    assign out_both[1] = in[1] & in[2];
    assign out_both[2] = in[2] & in[3];
    assign out_both[3] = 1'b0; // since in[3] has no neighbor to the left

    // out_any: each bit indicates if the corresponding input bit or its neighbor to the right is '1'
    assign out_any[0] = in[0]; // since in[0] has no neighbor to the right
    assign out_any[1] = in[1] | in[0];
    assign out_any[2] = in[2] | in[1];
    assign out_any[3] = in[3] | in[2];

    // out_different: each bit indicates if the corresponding input bit is different from its neighbor to the left (wrapping around for the most significant bit)
    assign out_different[0] = in[0] ^ in[3]; // wrapping around for the most significant bit
    assign out_different[1] = in[1] ^ in[2];
    assign out_different[2] = in[2] ^ in[3];
    assign out_different[3] = in[3] ^ in[0]; // wrapping around for the most significant bit

endmodule
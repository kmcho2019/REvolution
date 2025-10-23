module TopModule(
    input [3:0] in,
    output [3:1] out_both,
    output [2:0] out_any,
    output [3:0] out_different
);

    // out_both: check if current bit and its neighbor to the left are both '1'
    assign out_both[3] = 1'b0; // in[3] has no neighbor to the left
    assign out_both[2] = in[2] & in[3];
    assign out_both[1] = in[1] & in[2];
    assign out_both[0] = in[0] & in[1];

    // out_any: check if current bit or its neighbor to the right is '1'
    assign out_any[2] = in[2] | in[1];
    assign out_any[1] = in[1] | in[0];
    assign out_any[0] = in[0] | in[0]; // in[0] has no neighbor to the right, so use itself

    // out_different: check if current bit is different from its neighbor to the left
    assign out_different[3] = in[3] ^ in[0]; // wrap around for in[3]
    assign out_different[2] = in[2] ^ in[3];
    assign out_different[1] = in[1] ^ in[2];
    assign out_different[0] = in[0] ^ in[1];

endmodule
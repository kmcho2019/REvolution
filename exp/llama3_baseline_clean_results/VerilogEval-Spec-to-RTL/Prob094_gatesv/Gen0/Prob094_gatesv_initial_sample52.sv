module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: both current bit and its neighbor to the left are '1'
    assign out_both[0] = in[0] && in[1];
    assign out_both[1] = in[1] && in[2];
    assign out_both[2] = in[2] && in[3];
    assign out_both[3] = 1'b0; // out_both[3] is not needed, assign a default value

    // out_any: current bit or its neighbor to the right is '1'
    assign out_any[0] = 1'b1; // out_any[0] is always 1 since in[0] has no neighbor to the right
    assign out_any[1] = in[1] || in[0];
    assign out_any[2] = in[2] || in[1];
    assign out_any[3] = in[3] || in[2];

    // out_different: current bit is different from its neighbor to the left
    assign out_different[0] = in[0] != in[3]; // consider the vector as a circular array
    assign out_different[1] = in[1] != in[0];
    assign out_different[2] = in[2] != in[1];
    assign out_different[3] = in[3] != in[2];

endmodule
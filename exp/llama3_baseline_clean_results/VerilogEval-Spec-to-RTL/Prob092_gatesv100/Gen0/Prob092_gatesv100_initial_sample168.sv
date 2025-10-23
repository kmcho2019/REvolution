module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // For out_both: AND operation with neighbor to the left
    assign out_both[99] = 1'b0;  // in[99] has no neighbor to the left
    assign out_both[98:0] = in[98:0] & {1'b0, in[99:1]};

    // For out_any: OR operation with neighbor to the right
    assign out_any[0] = 1'b0;   // in[0] has no neighbor to the right
    assign out_any[99:1] = in[99:1] | {in[0], in[99:2]};

    // For out_different: XOR operation with neighbor to the left (wrap-around)
    assign out_different = in ^ {in[0], in[99:1]};

endmodule
module TopModule #(
    parameter WIDTH = 4
)(
    input  [WIDTH-1:0] in,
    output             out_and,
    output             out_or,
    output             out_xor
);
    /* 
     * Reduction operators:
     * &in - AND all bits together (1 if all bits are 1)
     * |in - OR all bits together (1 if any bit is 1)
     * ^in - XOR all bits together (1 if odd number of 1s)
     */
    assign out_and = &in;  // N-input AND gate
    assign out_or  = |in;  // N-input OR gate
    assign out_xor = ^in;  // N-input XOR gate (parity generator)

endmodule
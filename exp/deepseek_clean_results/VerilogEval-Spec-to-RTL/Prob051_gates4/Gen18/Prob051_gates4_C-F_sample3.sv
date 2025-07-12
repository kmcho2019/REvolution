module TopModule #(
    parameter WIDTH = 4
)(
    input  [WIDTH-1:0] in,
    output             out_and,
    output             out_or,
    output             out_xor
);
    // 4-input AND (all bits high)
    assign out_and = &in;
    // 4-input OR (any bit high)
    assign out_or  = |in;
    // 4-input XOR (odd parity)
    assign out_xor = ^in;

endmodule
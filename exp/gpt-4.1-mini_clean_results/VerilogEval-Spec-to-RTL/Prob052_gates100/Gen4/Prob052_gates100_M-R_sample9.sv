module TopModule (
    input  [99:0] in,
    output        out_and,  // 100-input AND reduction
    output        out_or,   // 100-input OR reduction
    output        out_xor   // 100-input XOR reduction (parity)
);

    assign out_and = &in;
    assign out_or  = |in;
    assign out_xor = ^in;

endmodule
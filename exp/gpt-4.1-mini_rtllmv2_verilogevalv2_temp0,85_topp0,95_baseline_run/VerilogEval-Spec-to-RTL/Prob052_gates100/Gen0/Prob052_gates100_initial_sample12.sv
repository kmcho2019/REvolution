module TopModule(
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);
    assign out_and = &in; // AND reduction of all bits
    assign out_or  = |in; // OR reduction of all bits
    assign out_xor = ^in; // XOR reduction of all bits
endmodule
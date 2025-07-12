module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Use Verilog built-in reduction operators to compute outputs
    assign out_and = &in;  // AND reduction: all bits must be 1
    assign out_or  = |in;  // OR reduction: any bit is 1
    assign out_xor = ^in;  // XOR reduction: parity of all bits

endmodule
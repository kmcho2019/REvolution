module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Use built-in reduction operators for the 100-input AND, OR, and XOR
    assign out_and = &in;  // AND reduction: 1 if all bits of in are 1
    assign out_or  = |in;  // OR  reduction: 1 if any bit of in is 1
    assign out_xor = ^in;  // XOR reduction: parity of bits in

endmodule
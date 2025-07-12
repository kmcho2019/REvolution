module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in;  // Verilog's reduction AND operator (&) applies AND across all bits
    assign out_or  = |in;  // Verilog's reduction OR operator (|) applies OR across all bits

    // Verilog's reduction XOR operator (^) applies XOR across all bits
    assign out_xor = ^in;

endmodule
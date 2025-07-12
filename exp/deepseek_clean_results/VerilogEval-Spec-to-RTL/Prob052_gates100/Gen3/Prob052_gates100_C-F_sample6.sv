module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Reduction operations with descriptive wire names
    wire all_bits_and = &in;
    wire any_bit_or   = |in;
    wire parity_xor   = ^in;

    // Direct assignments to outputs
    assign out_and = all_bits_and;
    assign out_or  = any_bit_or;
    assign out_xor = parity_xor;

endmodule
module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in; // Reduction AND operator (&) to perform 100-input AND
    assign out_or = |in;  // Reduction OR operator (|) to perform 100-input OR
    
    // For XOR, since Verilog does not support a direct reduction XOR operator (^),
    // we implement it by reducing the XOR operation across all bits.
    assign out_xor = ^in; // Note: ^ is a reduction XOR operator in some Verilog versions

endmodule
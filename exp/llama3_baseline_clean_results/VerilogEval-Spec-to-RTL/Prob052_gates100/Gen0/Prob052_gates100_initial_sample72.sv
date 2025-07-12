module TopModule (
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in; // Using Verilog's reduction AND operator (&)
    assign out_or  = |in;  // Using Verilog's reduction OR operator (|)
    assign out_xor = ^in;  // Using Verilog's reduction XOR operator (^)

endmodule
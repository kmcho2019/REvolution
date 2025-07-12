module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &(in);  // Using the reduction AND operator (&) to implement 100-input AND gate
    assign out_or = |(in);   // Using the reduction OR operator (|) to implement 100-input OR gate
    assign out_xor = ^(in);  // Using the reduction XOR operator (^) to implement 100-input XOR gate

endmodule
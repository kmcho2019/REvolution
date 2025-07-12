module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in; // Using the reduction operator (&) to perform 100-input AND
    assign out_or = |in;  // Using the reduction operator (|) to perform 100-input OR
    assign out_xor = ^in; // Using the reduction operator (^) to perform 100-input XOR

endmodule
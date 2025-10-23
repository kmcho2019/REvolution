module TopModule (
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in;  // using the bitwise AND reduction operator (&)
    assign out_or = |in;   // using the bitwise OR reduction operator (|)
    assign out_xor = ^in;  // using the bitwise XOR reduction operator (^)

endmodule
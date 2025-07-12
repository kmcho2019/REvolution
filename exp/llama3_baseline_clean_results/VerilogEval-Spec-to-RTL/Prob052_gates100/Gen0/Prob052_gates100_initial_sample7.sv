module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in; // using the bitwise AND operator
    assign out_or  = |in; // using the bitwise OR operator
    assign out_xor = ^in; // using the bitwise XOR operator

endmodule
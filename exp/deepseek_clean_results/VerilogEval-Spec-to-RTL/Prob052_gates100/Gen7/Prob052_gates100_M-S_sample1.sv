module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // All operations using simple reduction operators
    assign out_and = &in;
    assign out_or  = |in;
    assign out_xor = ^in;

endmodule
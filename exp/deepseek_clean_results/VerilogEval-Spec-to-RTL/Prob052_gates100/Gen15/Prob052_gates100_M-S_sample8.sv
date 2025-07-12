module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Parameter for input width
    localparam WIDTH = 100;

    // Direct reduction operations
    assign out_and = &in;
    assign out_or  = |in;
    assign out_xor = ^in;

endmodule
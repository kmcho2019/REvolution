module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Parameter for input width
    localparam WIDTH = 100;

    // AND operation using reduction operator
    assign out_and = &in;

    // OR operation using reduction operator
    assign out_or = |in;

    // XOR operation using reduction operator
    assign out_xor = ^in;

endmodule
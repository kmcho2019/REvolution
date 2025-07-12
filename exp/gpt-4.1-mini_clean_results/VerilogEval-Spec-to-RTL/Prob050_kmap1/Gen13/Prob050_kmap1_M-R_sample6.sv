module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    wire or_bc;

    // First OR b and c
    assign or_bc = b | c;

    // Then OR result with a
    assign out = a | or_bc;

endmodule
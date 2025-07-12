module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of the two inputs
    assign out_or_bitwise = a | b;

    // Logical OR (reduction OR of bitwise OR result)
    assign out_or_logical = |(a | b);

    // Inversion: upper half is ~b, lower half is ~a
    assign out_not = {~b, ~a};

endmodule
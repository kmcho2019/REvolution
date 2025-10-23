module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    // Compute bitwise OR
    assign out_or_bitwise = a | b;

    // Compute logical OR using reduction
    assign out_or_logical = |(a | b);

    // Compute inversion of vectors and concatenate
    assign out_not[5:3] = ~b;
    assign out_not[2:0] = ~a;
endmodule
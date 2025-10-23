module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Compute the bitwise-OR of the two vectors
    assign out_or_bitwise = a | b;

    // Compute the logical-OR of the two vectors
    assign out_or_logical = (a != 3'b0) || (b != 3'b0);

    // Compute the bitwise NOT of the two vectors and assign the result to out_not
    assign out_not = {~b, ~a};

endmodule
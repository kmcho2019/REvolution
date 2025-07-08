module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR
    assign out_or_bitwise = a | b;

    // Logical OR (1 if either a or b is non-zero)
    assign out_or_logical = (|a) || (|b);

    // Concatenate NOT of b and NOT of a
    assign out_not = { ~b, ~a };

endmodule
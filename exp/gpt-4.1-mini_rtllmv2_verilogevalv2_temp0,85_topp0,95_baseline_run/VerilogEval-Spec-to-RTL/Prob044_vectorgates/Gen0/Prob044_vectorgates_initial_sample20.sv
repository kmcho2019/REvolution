module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of a and b
    assign out_or_bitwise = a | b;

    // Logical OR of a and b (1 if either input is non-zero)
    assign out_or_logical = (|a) || (|b);

    // Inverse of b in upper half, inverse of a in lower half
    assign out_not = { ~b, ~a };

endmodule
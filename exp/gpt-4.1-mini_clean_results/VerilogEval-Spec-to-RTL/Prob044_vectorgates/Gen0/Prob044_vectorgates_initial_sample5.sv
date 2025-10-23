module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of a and b
    assign out_or_bitwise = a | b;

    // Logical OR of a and b (if any bit of a or b is 1, result is 1)
    assign out_or_logical = (|a) || (|b);

    // Bitwise NOT of b assigned to upper half [5:3]
    // Bitwise NOT of a assigned to lower half [2:0]
    assign out_not = { ~b, ~a };

endmodule
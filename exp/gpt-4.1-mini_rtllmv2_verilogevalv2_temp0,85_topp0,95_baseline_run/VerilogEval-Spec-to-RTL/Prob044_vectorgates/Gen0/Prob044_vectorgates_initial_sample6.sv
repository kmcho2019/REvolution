module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of a and b
    assign out_or_bitwise = a | b;

    // Logical OR: 1 if any bit in a or b is high, else 0
    assign out_or_logical = |a | |b;

    // out_not[5:3] = NOT b, out_not[2:0] = NOT a
    assign out_not = { ~b, ~a };

endmodule
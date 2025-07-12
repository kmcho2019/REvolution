module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of inputs
    assign out_or_bitwise = a | b;

    // Logical OR reduction over all bits of a and b combined
    assign out_or_logical = |(a | b);

    // Concatenate a and b into one 6-bit vector, invert once,
    // then split: upper half for ~b, lower half for ~a
    assign out_not = ~{b, a};

endmodule
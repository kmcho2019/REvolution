module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of vectors a and b
    assign out_or_bitwise = a | b;

    // Logical OR reduction over all bits of a and b combined
    assign out_or_logical = |{a, b};

    // Invert a and b and concatenate: ~b in bits [5:3], ~a in bits [2:0]
    assign out_not = {~b, ~a};

endmodule
module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of inputs a and b
    assign out_or_bitwise = a | b;

    // Logical OR of all bits in a and b (if any bit set in either input)
    assign out_or_logical = |{a, b};

    // Inverse of b in upper 3 bits, inverse of a in lower 3 bits
    assign out_not = {~b, ~a};

endmodule
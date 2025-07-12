module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of inputs a and b
    assign out_or_bitwise = a | b;

    // Logical OR of all bits in a and b
    assign out_or_logical = |a | |b;

    // Concatenate inverted b (upper bits) and inverted a (lower bits)
    assign out_not = {~b, ~a};

endmodule
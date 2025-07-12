module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of inputs a and b
    assign out_or_bitwise = a | b;

    // Logical OR reduction of the bitwise OR result
    assign out_or_logical = |out_or_bitwise;

    // Invert b for upper half [5:3], invert a for lower half [2:0]
    assign out_not = {~b, ~a};

endmodule
module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR directly assigned
    assign out_or_bitwise = a | b;

    // Logical OR of any bit set in the bitwise OR result
    assign out_or_logical = |out_or_bitwise;

    // Invert inputs and concatenate: upper bits = ~b, lower bits = ~a
    assign out_not = {~b, ~a};

endmodule
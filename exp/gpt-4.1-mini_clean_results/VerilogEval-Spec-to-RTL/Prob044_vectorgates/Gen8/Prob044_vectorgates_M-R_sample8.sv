module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of inputs
    assign out_or_bitwise = a | b;

    // Logical OR (reduction OR of bitwise OR)
    assign out_or_logical = |out_or_bitwise;

    // Bitwise NOT of inputs concatenated as {~b, ~a}
    assign out_not = {~b, ~a};

endmodule
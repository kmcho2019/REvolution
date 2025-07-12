module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Compute bitwise OR once and reuse
    assign out_or_bitwise = a | b;

    // Logical OR reduction of out_or_bitwise to avoid re-evaluating a or b
    assign out_or_logical = |out_or_bitwise;

    // Concatenate inverted inputs as required
    assign out_not = {~b, ~a};

endmodule
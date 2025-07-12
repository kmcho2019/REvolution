// Top-level module
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    // Compute bitwise-OR and assign to out_or_bitwise
    assign out_or_bitwise = a | b;

    // Compute logical-OR and assign to out_or_logical
    assign out_or_logical = (|a) || (|b);

    // Compute inversion of b and assign to upper half of out_not
    // Compute inversion of a and assign to lower half of out_not
    assign out_not = {~b, ~a};
endmodule
// Top-level module
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    // Bitwise-OR operation for out_or_bitwise
    assign out_or_bitwise = a | b;

    // Logical-OR operation using bitwise-OR result
    assign out_or_logical = |(a | b);

    // Inversion operation for out_not
    assign out_not = {~b, ~a};
endmodule
// Top-level module
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    // Simplified logical-OR operation using the || operator
    assign out_or_logical = a != 0 || b != 0;

    // Bitwise-OR operation remains straightforward and efficient
    assign out_or_bitwise = a | b;

    // Direct computation of out_not with minimal logic
    assign out_not = {~b, ~a};
endmodule
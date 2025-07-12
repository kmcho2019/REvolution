// Top-level module with integrated operations
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    // Direct bitwise-OR operation
    assign out_or_bitwise = a | b;

    // Direct logical-OR operation by checking if either vector is non-zero
    assign out_or_logical = (a | b) != 3'b000;

    // Direct calculation of out_not by concatenating inverted inputs
    assign out_not = {~b, ~a};
endmodule
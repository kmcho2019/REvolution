// Top-level module
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    // Direct bitwise-OR operation
    assign out_or_bitwise = a | b;

    // Direct logical-OR operation
    assign out_or_logical = (a != 3'b000) || (b != 3'b000);

    // Direct calculation of out_not vector
    assign out_not = {~b, ~a};
endmodule
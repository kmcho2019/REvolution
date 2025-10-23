// Top-level module with direct assignments
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    assign out_or_bitwise = a | b; // Direct bitwise-OR operation
    assign out_or_logical = |a || |b; // Logical-OR operation
    assign out_not[5:3] = ~b; // Inversion of b
    assign out_not[2:0] = ~a; // Inversion of a
endmodule
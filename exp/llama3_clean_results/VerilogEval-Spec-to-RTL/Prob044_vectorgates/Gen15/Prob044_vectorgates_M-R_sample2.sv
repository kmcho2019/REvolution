// Top-level module with inlined bitwise-OR and simplified logical-OR
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    // Directly implement bitwise-OR within TopModule
    assign out_or_bitwise = a | b;

    // Simplified logical-OR condition for any '1' bit in either vector
    assign out_or_logical = (|a) || (|b);

    // Direct inversion within TopModule
    assign out_not[5:3] = ~b; // Inverse of b in the upper half of out_not
    assign out_not[2:0] = ~a; // Inverse of a in the lower half of out_not
endmodule
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    // Directly compute bitwise-OR
    assign out_or_bitwise = a | b;

    // Simplified condition for logical-OR
    assign out_or_logical = (|a) || (|b);

    // Direct inversion within TopModule
    assign out_not[5:3] = ~b; // Inverse of b in the upper half
    assign out_not[2:0] = ~a; // Inverse of a in the lower half
endmodule
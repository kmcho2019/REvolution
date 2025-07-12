// Top-level module
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    assign out_or_bitwise = a | b;
    assign out_or_logical = (|a) || (|b); // Simplified condition for any '1' bit in either vector
    assign out_not[5:3] = ~b; // Direct inversion within TopModule
    assign out_not[2:0] = ~a; // Direct inversion within TopModule
endmodule
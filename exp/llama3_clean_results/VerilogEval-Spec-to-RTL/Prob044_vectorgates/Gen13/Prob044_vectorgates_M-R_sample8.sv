// Top-level module
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    // Directly implement bitwise-OR operation
    assign out_or_bitwise = a | b;
    
    // Simplified condition for logical-OR operation
    assign out_or_logical = (|a) || (|b);
    
    // Direct inversion of input vectors
    assign out_not[5:3] = ~b;
    assign out_not[2:0] = ~a;
endmodule
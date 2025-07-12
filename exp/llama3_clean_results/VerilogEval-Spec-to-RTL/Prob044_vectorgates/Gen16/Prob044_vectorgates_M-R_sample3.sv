// Top-level module
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    // Inline the bitwise-OR operation
    assign out_or_bitwise = a | b;
    
    // Simplified condition for logical-OR
    assign out_or_logical = (|a) || (|b);
    
    // Direct inversion for NOT operation
    assign out_not[5:3] = ~b;
    assign out_not[2:0] = ~a;
endmodule
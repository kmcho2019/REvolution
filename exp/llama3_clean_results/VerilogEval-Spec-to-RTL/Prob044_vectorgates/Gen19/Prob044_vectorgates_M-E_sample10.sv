module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    // Bitwise-OR operation
    assign out_or_bitwise = a | b;
    
    // Logical-OR operation using reduction OR
    assign out_or_logical = (|a) || (|b);
    
    // Inversion operation using XOR with all ones for reduced switching activity
    assign out_not[5:3] = b ^ 3'b111; // Inversion of b
    assign out_not[2:0] = a ^ 3'b111; // Inversion of a
endmodule
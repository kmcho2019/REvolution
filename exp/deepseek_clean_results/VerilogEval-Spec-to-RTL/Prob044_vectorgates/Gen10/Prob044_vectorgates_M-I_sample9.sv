module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Direct OR implementation for better timing
    assign out_or_bitwise = a | b;
    
    // Shared OR computation - logical OR is just the OR of all bitwise OR bits
    assign out_or_logical = |out_or_bitwise;
    
    // Efficient NOT implementation with proper concatenation
    assign out_not = {~b, ~a};
endmodule
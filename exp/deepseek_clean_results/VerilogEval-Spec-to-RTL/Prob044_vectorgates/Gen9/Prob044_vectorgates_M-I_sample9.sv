module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Direct OR implementation for better timing
    assign out_or_bitwise = a | b;
    
    // Shared computation between logical and bitwise OR
    wire [2:0] or_result = a | b;
    assign out_or_logical = |or_result;
    
    // Efficient NOT computation with proper concatenation
    assign out_not = {~b, ~a};
endmodule
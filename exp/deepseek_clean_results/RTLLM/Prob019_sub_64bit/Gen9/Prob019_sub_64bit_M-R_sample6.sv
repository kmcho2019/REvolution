module sub_64bit (
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

    // Perform subtraction using explicit bitwise operations
    wire [63:0] B_complement = ~B + 1'b1;  // Two's complement of B
    wire [63:0] subtraction_result = A + B_complement;
    
    // Sign bits
    wire A_sign = A[63];
    wire B_sign = B[63];
    wire result_sign = subtraction_result[63];
    
    // Overflow conditions
    wire positive_overflow = (~A_sign & B_sign & result_sign);  // A positive, B negative, result negative
    wire negative_overflow = (A_sign & ~B_sign & ~result_sign); // A negative, B positive, result positive
    
    // Final outputs
    assign result = subtraction_result;
    assign overflow = positive_overflow | negative_overflow;

endmodule
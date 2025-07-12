module sub_64bit(
    input  wire [63:0] A,  // First 64-bit input operand
    input  wire [63:0] B,  // Second 64-bit input operand
    output wire [63:0] result,  // 64-bit output representing the difference of A and B
    output wire        overflow  // 1-bit output indicating whether an overflow occurred
);

    // Intermediate signal for the subtraction result
    wire [63:0] diff;
    
    // Perform binary subtraction of A and B
    assign diff = A - B;
    
    // Assign the subtraction result to the output
    assign result = diff;
    
    // Overflow detection logic
    // Set overflow if the signs of A and B are the same but different from the result
    assign overflow = (A[63] == B[63] && A[63] != diff[63]) ? 1'b1 : 1'b0;

    // Alternative approach using always block for assignment
    // always @(*) begin
    //     result = A - B;
    //     overflow = (A[63] == B[63] && A[63] != result[63]) ? 1'b1 : 1'b0;
    // end

endmodule
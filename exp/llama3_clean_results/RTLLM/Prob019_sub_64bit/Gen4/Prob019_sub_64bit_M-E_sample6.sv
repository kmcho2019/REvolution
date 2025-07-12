module sub_64bit (
    input   [63:0] A,  // First 64-bit input operand
    input   [63:0] B,  // Second 64-bit input operand
    output  [63:0] result,  // 64-bit output representing the difference of the two operands (A - B)
    output         overflow  // 1-bit output indicating whether an overflow occurred during the subtraction operation
);

    // Divide each 64-bit operand into four 16-bit segments
    wire [15:0] A_segment1, A_segment2, A_segment3, A_segment4;
    wire [15:0] B_segment1, B_segment2, B_segment3, B_segment4;
    assign A_segment1 = A[15:0];
    assign A_segment2 = A[31:16];
    assign A_segment3 = A[47:32];
    assign A_segment4 = A[63:48];
    assign B_segment1 = B[15:0];
    assign B_segment2 = B[31:16];
    assign B_segment3 = B[47:32];
    assign B_segment4 = B[63:48];

    // Perform subtraction on each segment sequentially
    wire [15:0] result_segment1, result_segment2, result_segment3, result_segment4;
    wire borrow1, borrow2, borrow3;
    assign {result_segment1, borrow1} = A_segment1 - B_segment1;
    assign {result_segment2, borrow2} = A_segment2 - B_segment2 - borrow1;
    assign {result_segment3, borrow3} = A_segment3 - B_segment3 - borrow2;
    assign {result_segment4, } = A_segment4 - B_segment4 - borrow3;

    // Combine the results of each segment
    assign result[15:0] = result_segment1;
    assign result[31:16] = result_segment2;
    assign result[47:32] = result_segment3;
    assign result[63:48] = result_segment4;

    // Final overflow checking
    assign overflow = (A[63] == 1'b0 && B[63] == 1'b1 && result[63] == 1'b1) ||  // Positive overflow
                     (A[63] == 1'b1 && B[63] == 1'b0 && result[63] == 1'b0);  // Negative overflow

endmodule
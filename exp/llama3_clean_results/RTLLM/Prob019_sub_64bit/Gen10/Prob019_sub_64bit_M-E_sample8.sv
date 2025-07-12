module sub_64bit_arch2(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output reg overflow
);

    // Divide the 64-bit input operands into four 16-bit segments
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

    // Perform subtraction on each segment
    wire [15:0] result_segment1, result_segment2, result_segment3, result_segment4;
    wire overflow_segment1, overflow_segment2, overflow_segment3, overflow_segment4;
    sub_16bit sub1(A_segment1, B_segment1, result_segment1, overflow_segment1);
    sub_16bit sub2(A_segment2, B_segment2, result_segment2, overflow_segment2);
    sub_16bit sub3(A_segment3, B_segment3, result_segment3, overflow_segment3);
    sub_16bit sub4(A_segment4, B_segment4, result_segment4, overflow_segment4);

    // Combine the results from each segment
    assign result[15:0] = result_segment1;
    assign result[31:16] = result_segment2;
    assign result[47:32] = result_segment3;
    assign result[63:48] = result_segment4;

    // Detect overflow conditions
    assign overflow = (overflow_segment1 | overflow_segment2 | overflow_segment3 | overflow_segment4);

endmodule

// 16-bit subtractor module with overflow detection
module sub_16bit(
    input [15:0] A,
    input [15:0] B,
    output [15:0] result,
    output reg overflow
);

    assign result = A - B;
    assign overflow = (A[15] != result[15]) && (A[15] != B[15])? 1'b1 : 1'b0;

endmodule
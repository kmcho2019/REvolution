module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    wire [15:0] a_segment1, a_segment2, a_segment3, a_segment4;
    wire [15:0] b_segment1, b_segment2, b_segment3, b_segment4;
    wire [15:0] result_segment1, result_segment2, result_segment3, result_segment4;
    wire carry_out1, carry_out2, carry_out3;
    wire [15:0] temp_result1, temp_result2, temp_result3, temp_result4;

    assign a_segment1 = A[15:0];
    assign a_segment2 = A[31:16];
    assign a_segment3 = A[47:32];
    assign a_segment4 = A[63:48];

    assign b_segment1 = B[15:0];
    assign b_segment2 = B[31:16];
    assign b_segment3 = B[47:32];
    assign b_segment4 = B[63:48];

    // Segment 1 subtraction
    assign {carry_out1, result_segment1} = a_segment1 - b_segment1;

    // Segment 2 subtraction with carry-in
    assign {carry_out2, temp_result2} = a_segment2 - b_segment2 - carry_out1;
    assign result_segment2 = (carry_out1 == 1) ? (a_segment2 - b_segment2 - 1) : (a_segment2 - b_segment2);

    // Segment 3 subtraction with carry-in
    assign {carry_out3, temp_result3} = a_segment3 - b_segment3 - carry_out2;
    assign result_segment3 = (carry_out2 == 1) ? (a_segment3 - b_segment3 - 1) : (a_segment3 - b_segment3);

    // Segment 4 subtraction with carry-in
    assign temp_result4 = a_segment4 - b_segment4 - carry_out3;
    assign result_segment4 = (carry_out3 == 1) ? (a_segment4 - b_segment4 - 1) : (a_segment4 - b_segment4);

    assign result = {result_segment4, result_segment3, result_segment2, result_segment1};
    assign overflow = (A[63] != B[63]) && (A[63] != result[63]);

endmodule
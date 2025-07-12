module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    wire [15:0] A_chunk1, A_chunk2, A_chunk3, A_chunk4;
    wire [15:0] B_chunk1, B_chunk2, B_chunk3, B_chunk4;
    wire [15:0] result_chunk1, result_chunk2, result_chunk3, result_chunk4;
    wire [15:0] temp_result1, temp_result2, temp_result3;

    assign A_chunk1 = A[15:0];
    assign A_chunk2 = A[31:16];
    assign A_chunk3 = A[47:32];
    assign A_chunk4 = A[63:48];

    assign B_chunk1 = B[15:0];
    assign B_chunk2 = B[31:16];
    assign B_chunk3 = B[47:32];
    assign B_chunk4 = B[63:48];

    assign result_chunk1 = A_chunk1 - B_chunk1;
    assign temp_result1 = A_chunk2 - B_chunk2 - (result_chunk1[15]? 1 : 0);
    assign result_chunk2 = temp_result1[15:0];
    assign temp_result2 = A_chunk3 - B_chunk3 - (temp_result1[15]? 1 : 0);
    assign result_chunk3 = temp_result2[15:0];
    assign temp_result3 = A_chunk4 - B_chunk4 - (temp_result2[15]? 1 : 0);
    assign result_chunk4 = temp_result3[15:0];

    assign result = {result_chunk4, result_chunk3, result_chunk2, result_chunk1};
    assign overflow = (A[63]!= B[63]) && (A[63]!= result[63]);

endmodule
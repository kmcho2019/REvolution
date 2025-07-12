module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] compare_result;

    // Bit-level comparator array
    assign compare_result[3] = (A[3] > B[3]) ? 2'b01 :
                              (A[3] < B[3]) ? 2'b10 :
                                                2'b00;

    assign compare_result[2] = (A[2] > B[2]) ? 2'b01 :
                              (A[2] < B[2]) ? 2'b10 :
                                                2'b00;

    assign compare_result[1] = (A[1] > B[1]) ? 2'b01 :
                              (A[1] < B[1]) ? 2'b10 :
                                                2'b00;

    assign compare_result[0] = (A[0] > B[0]) ? 2'b01 :
                              (A[0] < B[0]) ? 2'b10 :
                                                2'b00;

    // Determine the final comparison outcome
    assign A_greater = (compare_result[3] == 2'b01) || 
                       (compare_result[3] == 2'b00 && compare_result[2] == 2'b01) || 
                       (compare_result[3] == 2'b00 && compare_result[2] == 2'b00 && compare_result[1] == 2'b01) || 
                       (compare_result[3] == 2'b00 && compare_result[2] == 2'b00 && compare_result[1] == 2'b00 && compare_result[0] == 2'b01);

    assign A_less = (compare_result[3] == 2'b10) || 
                   (compare_result[3] == 2'b00 && compare_result[2] == 2'b10) || 
                   (compare_result[3] == 2'b00 && compare_result[2] == 2'b00 && compare_result[1] == 2'b10) || 
                   (compare_result[3] == 2'b00 && compare_result[2] == 2'b00 && compare_result[1] == 2'b00 && compare_result[0] == 2'b10);

    assign A_equal = !(A_greater || A_less);

endmodule
module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire A3_greater, A3_equal, A3_less;
    wire A2_greater, A2_equal, A2_less;
    wire A1_greater, A1_equal, A1_less;
    wire A0_greater, A0_equal, A0_less;

    // Most Significant Bit (MSB) comparison
    assign A3_greater = (A[3] > B[3])? 1'b1 : 1'b0;
    assign A3_equal   = (A[3] == B[3])? 1'b1 : 1'b0;
    assign A3_less    = (A[3] < B[3])? 1'b1 : 1'b0;

    // Second Most Significant Bit comparison
    assign A2_greater = (A[2] > B[2]) & A3_equal? 1'b1 : 1'b0;
    assign A2_equal   = (A[2] == B[2]) & A3_equal? 1'b1 : 1'b0;
    assign A2_less    = (A[2] < B[2]) & A3_equal? 1'b1 : 1'b0;

    // Third Most Significant Bit comparison
    assign A1_greater = (A[1] > B[1]) & A3_equal & A2_equal? 1'b1 : 1'b0;
    assign A1_equal   = (A[1] == B[1]) & A3_equal & A2_equal? 1'b1 : 1'b0;
    assign A1_less    = (A[1] < B[1]) & A3_equal & A2_equal? 1'b1 : 1'b0;

    // Least Significant Bit (LSB) comparison
    assign A0_greater = (A[0] > B[0]) & A3_equal & A2_equal & A1_equal? 1'b1 : 1'b0;
    assign A0_equal   = (A[0] == B[0]) & A3_equal & A2_equal & A1_equal? 1'b1 : 1'b0;
    assign A0_less    = (A[0] < B[0]) & A3_equal & A2_equal & A1_equal? 1'b1 : 1'b0;

    // Final output logic
    assign A_greater = A3_greater | (A3_equal & A2_greater) | (A3_equal & A2_equal & A1_greater) | (A3_equal & A2_equal & A1_equal & A0_greater);
    assign A_equal   = A3_equal & A2_equal & A1_equal & A0_equal;
    assign A_less    = A3_less | (A3_equal & A2_less) | (A3_equal & A2_equal & A1_less) | (A3_equal & A2_equal & A1_equal & A0_less);

endmodule
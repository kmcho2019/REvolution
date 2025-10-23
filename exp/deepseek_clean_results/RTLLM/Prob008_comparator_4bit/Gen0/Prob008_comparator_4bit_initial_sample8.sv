module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Intermediate comparison results
    wire A_gt_B_3, A_lt_B_3, A_eq_B_3;
    wire A_gt_B_2, A_lt_B_2, A_eq_B_2;
    wire A_gt_B_1, A_lt_B_1, A_eq_B_1;
    wire A_gt_B_0, A_lt_B_0, A_eq_B_0;

    // Bit-wise comparison
    assign A_gt_B_3 = (A[3] > B[3]);
    assign A_lt_B_3 = (A[3] < B[3]);
    assign A_eq_B_3 = (A[3] == B[3]);

    assign A_gt_B_2 = (A[2] > B[2]);
    assign A_lt_B_2 = (A[2] < B[2]);
    assign A_eq_B_2 = (A[2] == B[2]);

    assign A_gt_B_1 = (A[1] > B[1]);
    assign A_lt_B_1 = (A[1] < B[1]);
    assign A_eq_B_1 = (A[1] == B[1]);

    assign A_gt_B_0 = (A[0] > B[0]);
    assign A_lt_B_0 = (A[0] < B[0]);
    assign A_eq_B_0 = (A[0] == B[0]);

    // Final comparison results
    assign A_greater = A_gt_B_3 | 
                      (A_eq_B_3 & A_gt_B_2) |
                      (A_eq_B_3 & A_eq_B_2 & A_gt_B_1) |
                      (A_eq_B_3 & A_eq_B_2 & A_eq_B_1 & A_gt_B_0);

    assign A_less = A_lt_B_3 | 
                    (A_eq_B_3 & A_lt_B_2) |
                    (A_eq_B_3 & A_eq_B_2 & A_lt_B_1) |
                    (A_eq_B_3 & A_eq_B_2 & A_eq_B_1 & A_lt_B_0);

    assign A_equal = A_eq_B_3 & A_eq_B_2 & A_eq_B_1 & A_eq_B_0;

endmodule
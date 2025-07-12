module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    wire A_gt_B, A_eq_B, A_ls_B;

    // Compare MSB (most significant bit)
    assign A_gt_B = (A[2] == 1'b1 && B[2] == 1'b0);
    assign A_ls_B = (A[2] == 1'b0 && B[2] == 1'b1);
    assign A_eq_B = (A[2] == B[2]);

    // If MSB is equal, compare the next bit
    wire A_gt_B_1, A_ls_B_1;
    assign A_gt_B_1 = (A_eq_B && A[1] == 1'b1 && B[1] == 1'b0);
    assign A_ls_B_1 = (A_eq_B && A[1] == 1'b0 && B[1] == 1'b1);

    // If the first two bits are equal, compare the LSB (least significant bit)
    wire A_gt_B_2, A_ls_B_2;
    assign A_gt_B_2 = (A_eq_B && A[1] == B[1] && A[0] == 1'b1 && B[0] == 1'b0);
    assign A_ls_B_2 = (A_eq_B && A[1] == B[1] && A[0] == 1'b0 && B[0] == 1'b1);

    // Determine the final output based on the comparisons
    assign A_greater = A_gt_B || A_gt_B_1 || A_gt_B_2;
    assign A_equal =!(A_gt_B || A_ls_B || A_gt_B_1 || A_ls_B_1 || A_gt_B_2 || A_ls_B_2);
    assign A_less = A_ls_B || A_ls_B_1 || A_ls_B_2;

endmodule
module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    wire A_eq_B, A_gt_B, A_lt_B;

    assign A_eq_B = (A[2] == B[2]) && (A[1] == B[1]) && (A[0] == B[0]);
    assign A_gt_B = (A[2] > B[2]) || ((A[2] == B[2]) && (A[1] > B[1])) || ((A[2] == B[2]) && (A[1] == B[1]) && (A[0] > B[0]));
    assign A_lt_B = (A[2] < B[2]) || ((A[2] == B[2]) && (A[1] < B[1])) || ((A[2] == B[2]) && (A[1] == B[1]) && (A[0] < B[0]));

    assign A_greater = A_gt_B && !A_eq_B;
    assign A_equal = A_eq_B;
    assign A_less = A_lt_B && !A_eq_B;

endmodule
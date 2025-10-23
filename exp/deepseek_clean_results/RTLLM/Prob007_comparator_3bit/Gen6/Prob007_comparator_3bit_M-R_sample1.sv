module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Direct magnitude comparison
wire A_gt_B = (A > B);
wire A_eq_B = (A == B);
wire A_lt_B = (A < B);

// Output assignments with explicit mutual exclusion
assign A_greater = A_gt_B;
assign A_equal = A_eq_B;
assign A_less = A_lt_B;

// Alternative implementation showing the same logic expanded:
// assign A_greater = (A[2] > B[2]) |
//                   (A[2] == B[2] && A[1] > B[1]) |
//                   (A[2] == B[2] && A[1] == B[1] && A[0] > B[0]);
// 
// assign A_equal = (A[2] == B[2]) && (A[1] == B[1]) && (A[0] == B[0]);
// 
// assign A_less = ~A_greater & ~A_equal;

endmodule
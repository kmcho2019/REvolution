module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Parallel comparison logic
    wire A_gt_B = (A[2] > B[2]) || 
                 (A[2] == B[2] && A[1] > B[1]) || 
                 (A[2] == B[2] && A[1] == B[1] && A[0] > B[0]);
    
    wire A_eq_B = (A == B);
    
    // Output assignments (mutually exclusive)
    assign A_greater = A_gt_B;
    assign A_equal = A_eq_B;
    assign A_less = ~(A_gt_B | A_eq_B);

endmodule
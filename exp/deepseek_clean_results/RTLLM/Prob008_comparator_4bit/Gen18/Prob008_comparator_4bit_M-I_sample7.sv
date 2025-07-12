module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Fast parallel equality check
    wire equal = (A == B);
    
    // Balanced hierarchical comparison
    // First level: Compare upper and lower pairs separately
    wire upper_gt = (A[3] > B[3]) | ((A[3] == B[3]) & (A[2] > B[2]));
    wire upper_eq = (A[3] == B[3]) & (A[2] == B[2]);
    
    wire lower_gt = (A[1] > B[1]) | ((A[1] == B[1]) & (A[0] > B[0]));
    wire lower_eq = (A[1] == B[1]) & (A[0] == B[0]);
    
    // Second level: Combine results
    wire gt_hi = upper_gt | (upper_eq & lower_gt);
    
    // Output assignments - mutually exclusive by construction
    assign A_equal = equal;
    assign A_greater = ~equal & gt_hi;
    assign A_less = ~equal & ~gt_hi;

endmodule
module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Parallel equality check (fastest path)
    wire equal = (A == B);
    
    // Balanced comparison tree
    // Compare upper and lower pairs separately
    wire upper_gt = (A[3] > B[3]) | 
                   ((A[3] == B[3]) & (A[2] > B[2]));
    wire upper_eq = (A[3] == B[3]) & (A[2] == B[2]);
    
    wire lower_gt = (A[1] > B[1]) | 
                   ((A[1] == B[1]) & (A[0] > B[0]));
    wire lower_eq = (A[1] == B[1]) & (A[0] == B[0]);
    
    // Combine results
    wire greater = upper_gt | (upper_eq & lower_gt);
    
    // Output assignments - mutually exclusive by construction
    assign A_equal = equal;
    assign A_greater = ~equal & greater;
    assign A_less = ~equal & ~greater;

endmodule
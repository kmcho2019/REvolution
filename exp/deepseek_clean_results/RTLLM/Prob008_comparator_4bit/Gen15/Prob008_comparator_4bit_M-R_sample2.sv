module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Fast parallel equality check
    wire equal = (A == B);
    
    // Grouped comparison logic (balanced tree)
    wire gt_hi = (A[3] > B[3]) | 
                ((A[3] == B[3]) & (A[2] > B[2]));
    
    wire gt_lo = (A[1] > B[1]) | 
                ((A[1] == B[1]) & (A[0] > B[0]));
    
    wire eq_hi = (A[3] == B[3]) & (A[2] == B[2]);
    wire eq_lo = (A[1] == B[1]) & (A[0] == B[0]);
    
    // Final greater-than determination
    wire gt_final = gt_hi | (eq_hi & gt_lo);
    
    // Output assignments - mutually exclusive by construction
    assign A_equal = equal;
    assign A_greater = ~equal & gt_final;
    assign A_less = ~equal & ~gt_final;

endmodule
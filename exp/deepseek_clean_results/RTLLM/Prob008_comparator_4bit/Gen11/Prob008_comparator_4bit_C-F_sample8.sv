module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bitwise equality using XNOR + AND reduction (most efficient)
    wire equal = &(A ~^ B);
    
    // Parallel magnitude comparison with priority encoding
    wire [3:0] bit_gt = A & ~B;
    wire [3:0] bit_lt = ~A & B;
    
    // Hierarchical comparison with balanced tree structure
    wire gt_hi = bit_gt[3] | 
                (bit_gt[2] & (A[3] == B[3])) |
                (bit_gt[1] & (A[3:2] == B[3:2])) |
                (bit_gt[0] & (A[3:1] == B[3:1]));
    
    wire lt_hi = bit_lt[3] | 
                (bit_lt[2] & (A[3] == B[3])) |
                (bit_lt[1] & (A[3:2] == B[3:2])) |
                (bit_lt[0] & (A[3:1] == B[3:1]));

    // Output assignments - mutually exclusive by construction
    assign A_equal = equal;
    assign A_greater = ~equal & gt_hi;
    assign A_less = ~equal & lt_hi;

endmodule
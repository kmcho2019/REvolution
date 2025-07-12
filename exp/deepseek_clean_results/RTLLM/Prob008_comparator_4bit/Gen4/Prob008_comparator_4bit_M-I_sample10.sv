module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bitwise equality using XNOR + AND reduction
    wire equal = &(A ~^ B);
    
    // Parallel prefix comparison - 2 level logic
    wire [3:0] bit_gt = A & ~B;
    wire [3:0] bit_eq = ~(A ^ B);
    
    // Hierarchical comparison
    wire gt_hi = bit_gt[3] | 
                (bit_eq[3] & bit_gt[2]) |
                (bit_eq[3] & bit_eq[2] & bit_gt[1]) |
                (bit_eq[3] & bit_eq[2] & bit_eq[1] & bit_gt[0]);
    
    wire greater = ~equal & gt_hi;

    // Output assignments - mutually exclusive by construction
    assign A_equal = equal;
    assign A_greater = greater;
    assign A_less = ~equal & ~greater;

endmodule
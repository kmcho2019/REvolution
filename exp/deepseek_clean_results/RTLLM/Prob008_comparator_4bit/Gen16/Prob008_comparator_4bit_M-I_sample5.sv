module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bitwise comparison signals
    wire [3:0] bit_gt = A & ~B;
    wire [3:0] bit_eq = ~(A ^ B);
    
    // Optimized carry-chain style greater-than comparison
    wire gt3 = bit_gt[3];
    wire gt2 = bit_gt[2] & bit_eq[3];
    wire gt1 = bit_gt[1] & &bit_eq[3:2];
    wire gt0 = bit_gt[0] & &bit_eq[3:1];
    
    // Combined greater-than signal
    wire greater = gt3 | gt2 | gt1 | gt0;
    
    // Fast parallel equality check (shared with greater-than logic)
    wire equal = &bit_eq;
    
    // Output assignments - mutually exclusive by construction
    assign A_equal = equal;
    assign A_greater = greater;
    assign A_less = ~equal & ~greater;  // Derived from other two outputs

endmodule
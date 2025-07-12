module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Shared intermediate signals
    wire [3:0] bit_gt = A & ~B;
    wire [3:0] bit_eq = ~(A ^ B);
    
    // Fast equality check (parallel)
    wire full_equal = &bit_eq;
    
    // Hierarchical greater-than with early termination
    wire gt3 = bit_gt[3];
    wire gt2 = bit_eq[3] & bit_gt[2];
    wire gt1 = &bit_eq[3:2] & bit_gt[1];
    wire gt0 = &bit_eq[3:1] & bit_gt[0];
    
    // Combined greater-than (balanced OR tree)
    wire greater = gt3 | (bit_eq[3] & (gt2 | (bit_eq[2] & (gt1 | (bit_eq[1] & gt0)))));
    
    // Output assignments with mutual exclusivity
    assign A_equal = full_equal;
    assign A_greater = greater & ~full_equal;
    assign A_less = ~(full_equal | greater);
    
endmodule
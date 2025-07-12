module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Parallel equality check (all bits simultaneously)
    wire equal = (A == B);
    
    // Parallel bitwise greater signals
    wire [3:0] bit_gt = A & ~B;
    
    // Optimized hierarchical comparison
    wire greater = bit_gt[3] |                     // MSB decides
                  (~(A[3] ^ B[3]) & bit_gt[2] |   // if MSB equal, check next
                  (&A[3:2] == &B[3:2]) & bit_gt[1] | // if upper 2 equal, check next
                  (&A[3:1] == &B[3:1]) & bit_gt[0];  // if upper 3 equal, check LSB

    // Output assignments (mutually exclusive)
    assign A_equal = equal;
    assign A_greater = ~equal & greater;
    assign A_less = ~equal & ~greater;

endmodule
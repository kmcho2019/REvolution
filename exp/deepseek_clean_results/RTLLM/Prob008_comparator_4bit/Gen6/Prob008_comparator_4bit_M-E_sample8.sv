module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bit-wise comparison signals
    wire [3:0] bit_eq = ~(A ^ B);
    wire [3:0] bit_gt = A & ~B;

    // Hierarchical comparison with early termination
    wire gt3 = bit_gt[3];
    wire eq3 = bit_eq[3];
    
    wire gt2 = eq3 & bit_gt[2];
    wire eq2 = eq3 & bit_eq[2];
    
    wire gt1 = eq2 & bit_gt[1];
    wire eq1 = eq2 & bit_eq[1];
    
    wire gt0 = eq1 & bit_gt[0];
    wire eq0 = eq1 & bit_eq[0];

    // Final comparison results
    wire greater = gt3 | gt2 | gt1 | gt0;
    wire equal = eq0;

    // Output assignments (mutually exclusive)
    assign A_equal = equal;
    assign A_greater = greater;
    assign A_less = ~equal & ~greater;

endmodule
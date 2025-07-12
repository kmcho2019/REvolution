module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Individual bit comparisons
    wire [3:0] bit_eq = ~(A ^ B);  // 1 if bits equal
    wire [3:0] bit_gt = A & ~B;    // 1 if A bit > B bit

    // Hierarchical combination
    wire eq3 = bit_eq[3];
    wire gt3 = bit_gt[3];
    
    wire eq2 = bit_eq[2];
    wire gt2 = bit_gt[2];
    wire cmp2 = gt3 | (eq3 & gt2);
    
    wire eq1 = bit_eq[1];
    wire gt1 = bit_gt[1];
    wire cmp1 = gt3 | (eq3 & gt2) | (eq3 & eq2 & gt1);
    
    wire eq0 = bit_eq[0];
    wire gt0 = bit_gt[0];
    wire cmp0 = gt3 | (eq3 & gt2) | (eq3 & eq2 & gt1) | (eq3 & eq2 & eq1 & gt0);

    // Final outputs
    assign A_equal = &bit_eq;
    assign A_greater = cmp0 & ~A_equal;
    assign A_less = ~A_equal & ~A_greater;

endmodule
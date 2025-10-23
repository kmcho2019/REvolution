module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bit-wise equality (XNOR)
    wire [3:0] bit_eq = ~(A ^ B);
    
    // Bit-wise greater-than
    wire [3:0] bit_gt = A & ~B;
    
    // Complete equality (all bits equal)
    assign A_equal = &bit_eq;
    
    // Greater-than if any bit is greater while higher bits are equal
    assign A_greater = (bit_gt[3]) |
                      (bit_eq[3] & bit_gt[2]) |
                      (bit_eq[3] & bit_eq[2] & bit_gt[1]) |
                      (bit_eq[3] & bit_eq[2] & bit_eq[1] & bit_gt[0]);
    
    // Less-than is neither equal nor greater
    assign A_less = ~A_equal & ~A_greater;

endmodule
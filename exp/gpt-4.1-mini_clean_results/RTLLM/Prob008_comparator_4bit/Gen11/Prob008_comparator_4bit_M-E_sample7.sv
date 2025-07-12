module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Compare bits from MSB to LSB: generate signals indicating per bit comparison
    wire [3:0] A_gt_B = A & ~B;       // bit is 1 if A[i]=1 and B[i]=0 (A > B at that bit)
    wire [3:0] B_gt_A = ~A & B;       // bit is 1 if B[i]=1 and A[i]=0 (A < B at that bit)
    wire [3:0] bits_equal = ~(A ^ B); // bit is 1 if A[i]==B[i]

    // For each bit, define signals if all more significant bits are equal
    wire eq_high_3 = 1'b1;                      // No bits higher than bit 3
    wire eq_high_2 = bits_equal[3];             // All higher bits than bit 2 equal
    wire eq_high_1 = bits_equal[3] & bits_equal[2];
    wire eq_high_0 = bits_equal[3] & bits_equal[2] & bits_equal[1];

    // Determine if A > B by checking MSB to LSB with priority
    wire A_gt_B_flag = 
        (A_gt_B[3]) ? 1'b1 :
        (eq_high_2 & A_gt_B[2]) ? 1'b1 :
        (eq_high_1 & A_gt_B[1]) ? 1'b1 :
        (eq_high_0 & A_gt_B[0]) ? 1'b1 : 1'b0;

    // Determine if A < B by checking MSB to LSB with priority
    wire A_lt_B_flag = 
        (B_gt_A[3]) ? 1'b1 :
        (eq_high_2 & B_gt_A[2]) ? 1'b1 :
        (eq_high_1 & B_gt_A[1]) ? 1'b1 :
        (eq_high_0 & B_gt_A[0]) ? 1'b1 : 1'b0;

    // A equal if all bits equal
    wire A_eq_B_flag = &bits_equal;

    assign A_greater = A_gt_B_flag;
    assign A_less    = A_lt_B_flag;
    assign A_equal   = A_eq_B_flag;

endmodule
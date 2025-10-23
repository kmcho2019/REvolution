module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire bit2_gt =  A[2] & ~B[2];
    wire bit2_lt = ~A[2] &  B[2];
    wire bit2_eq = ~(A[2] ^ B[2]);

    wire bit1_gt =  A[1] & ~B[1];
    wire bit1_lt = ~A[1] &  B[1];
    wire bit1_eq = ~(A[1] ^ B[1]);

    wire bit0_gt =  A[0] & ~B[0];
    wire bit0_lt = ~A[0] &  B[0];
    wire bit0_eq = ~(A[0] ^ B[0]);

    // Determine if A > B by cascading from MSB to LSB
    assign A_greater = bit2_gt ? 1'b1 :
                       (bit2_eq ? (bit1_gt ? 1'b1 :
                                   (bit1_eq ? bit0_gt : 1'b0)) 
                                : 1'b0);

    // Determine if A < B by cascading from MSB to LSB
    assign A_less = bit2_lt ? 1'b1 :
                    (bit2_eq ? (bit1_lt ? 1'b1 :
                                (bit1_eq ? bit0_lt : 1'b0)) 
                             : 1'b0);

    // If neither greater nor less, then equal
    assign A_equal = ~(A_greater | A_less);

endmodule
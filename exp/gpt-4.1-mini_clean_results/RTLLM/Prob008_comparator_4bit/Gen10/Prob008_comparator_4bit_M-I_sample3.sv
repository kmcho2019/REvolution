module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire bit3_greater =  A[3] & ~B[3];
    wire bit3_less    = ~A[3] &  B[3];

    wire bit2_greater =  A[2] & ~B[2];
    wire bit2_less    = ~A[2] &  B[2];

    wire bit1_greater =  A[1] & ~B[1];
    wire bit1_less    = ~A[1] &  B[1];

    wire bit0_greater =  A[0] & ~B[0];
    wire bit0_less    = ~A[0] &  B[0];

    // Compare from MSB to LSB
    assign A_greater =
           bit3_greater ? 1'b1 :
           (bit3_less  ? 1'b0 :
           (bit2_greater ? 1'b1 :
           (bit2_less  ? 1'b0 :
           (bit1_greater ? 1'b1 :
           (bit1_less  ? 1'b0 :
           (bit0_greater ? 1'b1 :
           (bit0_less  ? 1'b0 : 1'b0)))))));

    assign A_less =
           bit3_less ? 1'b1 :
           (bit3_greater ? 1'b0 :
           (bit2_less ? 1'b1 :
           (bit2_greater ? 1'b0 :
           (bit1_less ? 1'b1 :
           (bit1_greater ? 1'b0 :
           (bit0_less ? 1'b1 :
           (bit0_greater ? 1'b0 : 1'b0)))))));

    // Equality if all bits match
    assign A_equal = (A == B);

endmodule
module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Determine comparison result by checking each bit from MSB to LSB
    wire gt_bit2 =  A[2] & ~B[2];
    wire lt_bit2 = ~A[2] &  B[2];
    wire eq_bit2 =  A[2] == B[2];

    wire gt_bit1 =  A[1] & ~B[1];
    wire lt_bit1 = ~A[1] &  B[1];
    wire eq_bit1 =  A[1] == B[1];

    wire gt_bit0 =  A[0] & ~B[0];
    wire lt_bit0 = ~A[0] &  B[0];
    wire eq_bit0 =  A[0] == B[0];

    // Priority encoded logic to determine A_greater
    assign A_greater = gt_bit2 ? 1'b1 :
                       lt_bit2 ? 1'b0 :
                       gt_bit1 ? 1'b1 :
                       lt_bit1 ? 1'b0 :
                       gt_bit0 ? 1'b1 :
                       1'b0;

    // Priority encoded logic to determine A_less
    assign A_less =  gt_bit2 ? 1'b0 :
                     lt_bit2 ? 1'b1 :
                     gt_bit1 ? 1'b0 :
                     lt_bit1 ? 1'b1 :
                     gt_bit0 ? 1'b0 :
                     lt_bit0 ? 1'b1 :
                     1'b0;

    // A_equal is high only if all bits are equal
    assign A_equal = eq_bit2 & eq_bit1 & eq_bit0;

endmodule
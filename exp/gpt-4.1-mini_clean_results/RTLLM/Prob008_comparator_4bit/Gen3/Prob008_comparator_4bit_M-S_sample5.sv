module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire A_gt_B, A_eq_B, A_lt_B;

    // Compare from MSB to LSB to find first differing bit
    assign A_gt_B = (A[3] & ~B[3]) ? 1'b1 :
                    (A[3] == B[3]) ? 
                      ((A[2] & ~B[2]) ? 1'b1 :
                       (A[2] == B[2]) ?
                         ((A[1] & ~B[1]) ? 1'b1 :
                          (A[1] == B[1]) ?
                            ((A[0] & ~B[0]) ? 1'b1 : 1'b0)
                          : 1'b0)
                       : 1'b0)
                    : 1'b0;

    assign A_lt_B = (~A[3] & B[3]) ? 1'b1 :
                    (A[3] == B[3]) ? 
                      ((~A[2] & B[2]) ? 1'b1 :
                       (A[2] == B[2]) ?
                         ((~A[1] & B[1]) ? 1'b1 :
                          (A[1] == B[1]) ?
                            ((~A[0] & B[0]) ? 1'b1 : 1'b0)
                          : 1'b0)
                       : 1'b0)
                    : 1'b0;

    assign A_eq_B = ~(A_gt_B | A_lt_B);

    assign A_greater = A_gt_B;
    assign A_less    = A_lt_B;
    assign A_equal   = A_eq_B;

endmodule
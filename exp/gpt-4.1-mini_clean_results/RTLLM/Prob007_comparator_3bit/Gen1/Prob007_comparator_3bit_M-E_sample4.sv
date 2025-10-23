module comparator_3bit (
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire bit2_greater = (A[2] & ~B[2]);
    wire bit2_less    = (~A[2] & B[2]);
    wire bit2_equal   = (A[2] == B[2]);

    wire bit1_greater = (A[1] & ~B[1]);
    wire bit1_less    = (~A[1] & B[1]);
    wire bit1_equal   = (A[1] == B[1]);

    wire bit0_greater = (A[0] & ~B[0]);
    wire bit0_less    = (~A[0] & B[0]);
    wire bit0_equal   = (A[0] == B[0]);

    assign A_greater = bit2_greater ? 1'b1 :
                       (bit2_equal  ? (bit1_greater ? 1'b1 :
                                      (bit1_equal  ? bit0_greater : 1'b0))
                                    : 1'b0);

    assign A_less    = bit2_less ? 1'b1 :
                       (bit2_equal ? (bit1_less ? 1'b1 :
                                     (bit1_equal ? bit0_less : 1'b0))
                                   : 1'b0);

    assign A_equal   = bit2_equal & bit1_equal & bit0_equal;

endmodule
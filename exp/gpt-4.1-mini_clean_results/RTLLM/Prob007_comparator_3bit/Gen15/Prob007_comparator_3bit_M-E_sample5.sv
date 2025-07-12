module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Compare MSB first
    wire bit2_gt = (A[2] > B[2]);
    wire bit2_eq = (A[2] == B[2]);
    wire bit2_lt = (A[2] < B[2]);

    // Compare middle bit
    wire bit1_gt = (A[1] > B[1]);
    wire bit1_eq = (A[1] == B[1]);
    wire bit1_lt = (A[1] < B[1]);

    // Compare LSB
    wire bit0_gt = (A[0] > B[0]);
    wire bit0_eq = (A[0] == B[0]);
    wire bit0_lt = (A[0] < B[0]);

    // Determine A_greater:
    // If MSB differs, that decides. Else if middle differs, that decides. Else LSB decides.
    assign A_greater = bit2_gt ? 1'b1 :
                       bit2_eq ? (bit1_gt ? 1'b1 :
                                  bit1_eq ? (bit0_gt ? 1'b1 : 1'b0)
                                          : 1'b0)
                               : 1'b0;

    // Determine A_equal if all bits equal
    assign A_equal = bit2_eq & bit1_eq & bit0_eq;

    // Determine A_less by exclusion
    assign A_less = ~(A_greater | A_equal);

endmodule
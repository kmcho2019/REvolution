module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Bitwise comparison signals
    wire [3:0] a_gt_b = A & (~B);
    wire [3:0] a_lt_b = (~A) & B;
    wire [3:0] a_eq_b = ~(A ^ B);

    // Priority chain from MSB (bit 3) to LSB (bit 0)

    // At bit 3: if A> B or A< B decide immediately, else go to bit 2
    wire gt_or_eq_3 = (a_gt_b[3] | a_lt_b[3]) ? 1'b1 : 1'b0;
    wire gt_3 = a_gt_b[3];
    wire lt_3 = a_lt_b[3];

    // At bit 2: only consider if bit 3 equal, else ignored
    wire gt_or_eq_2 = (~gt_or_eq_3) && ((a_gt_b[2] | a_lt_b[2]));
    wire gt_2 = a_gt_b[2];
    wire lt_2 = a_lt_b[2];

    // At bit 1: only if bits 3 and 2 equal
    wire bits3_2_eq = a_eq_b[3] & a_eq_b[2];
    wire gt_or_eq_1 = (~gt_or_eq_3) && (~gt_or_eq_2) && ((a_gt_b[1] | a_lt_b[1]));
    wire gt_1 = a_gt_b[1];
    wire lt_1 = a_lt_b[1];

    // At bit 0: only if bits 3,2,1 equal
    wire bits3_1_eq = bits3_2_eq & a_eq_b[1];
    wire gt_or_eq_0 = (~gt_or_eq_3) && (~gt_or_eq_2) && (~gt_or_eq_1) && ((a_gt_b[0] | a_lt_b[0]));
    wire gt_0 = a_gt_b[0];
    wire lt_0 = a_lt_b[0];

    // Check if all bits equal
    wire all_equal = &a_eq_b;

    // Determine A_greater
    assign A_greater =
          (gt_3)
        | (~gt_or_eq_3 & gt_2)
        | (~gt_or_eq_3 & ~gt_or_eq_2 & gt_1)
        | (~gt_or_eq_3 & ~gt_or_eq_2 & ~gt_or_eq_1 & gt_0);

    // Determine A_less
    assign A_less =
          (lt_3)
        | (~gt_or_eq_3 & lt_2)
        | (~gt_or_eq_3 & ~gt_or_eq_2 & lt_1)
        | (~gt_or_eq_3 & ~gt_or_eq_2 & ~gt_or_eq_1 & lt_0);

    // Determine A_equal
    assign A_equal = all_equal;

endmodule
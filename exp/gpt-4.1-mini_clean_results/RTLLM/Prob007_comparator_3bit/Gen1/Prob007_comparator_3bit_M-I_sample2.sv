module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);
    wire a_gt_b;
    wire a_eq_b;
    wire a_lt_b;

    // Compare bits from MSB to LSB for priority encoding
    assign a_gt_b = (A[2] & ~B[2]) |
                    ((A[2] == B[2]) & (A[1] & ~B[1])) |
                    ((A[2] == B[2]) & (A[1] == B[1]) & (A[0] & ~B[0]));

    assign a_lt_b = (~A[2] & B[2]) |
                    ((A[2] == B[2]) & (~A[1] & B[1])) |
                    ((A[2] == B[2]) & (A[1] == B[1]) & (~A[0] & B[0]));

    assign a_eq_b = (A == B);

    assign A_greater = a_gt_b;
    assign A_less    = a_lt_b;
    assign A_equal   = a_eq_b;

endmodule
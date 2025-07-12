module comparator_3bit (
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire msb_greater, msb_equal, msb_less;
    wire mid_greater, mid_equal, mid_less;
    wire lsb_greater, lsb_equal, lsb_less;

    // Compare bit 2 (MSB)
    assign msb_greater = (A[2] & ~B[2]);
    assign msb_equal   = (A[2] == B[2]);
    assign msb_less    = (~A[2] & B[2]);

    // Compare bit 1
    assign mid_greater = (A[1] & ~B[1]);
    assign mid_equal   = (A[1] == B[1]);
    assign mid_less    = (~A[1] & B[1]);

    // Compare bit 0 (LSB)
    assign lsb_greater = (A[0] & ~B[0]);
    assign lsb_equal   = (A[0] == B[0]);
    assign lsb_less    = (~A[0] & B[0]);

    // Hierarchical comparison logic
    assign A_greater = msb_greater |
                       (msb_equal & mid_greater) |
                       (msb_equal & mid_equal & lsb_greater);

    assign A_less = msb_less |
                    (msb_equal & mid_less) |
                    (msb_equal & mid_equal & lsb_less);

    assign A_equal = msb_equal & mid_equal & lsb_equal;

endmodule
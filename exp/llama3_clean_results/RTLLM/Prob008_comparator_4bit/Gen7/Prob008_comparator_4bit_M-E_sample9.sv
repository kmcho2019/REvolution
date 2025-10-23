module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Compare MSBs (bit 3)
    wire msb_comp;
    assign msb_comp = A[3] && ~B[3] || ~A[3] && B[3];

    // Compare next bits if MSBs are equal
    wire mid_comp;
    assign mid_comp = (A[3] == B[3]) && (A[2] && ~B[2] || ~A[2] && B[2]);

    // Compare next bits if previous bits are equal
    wire lsb_comp;
    assign lsb_comp = (A[3:2] == B[3:2]) && (A[1] && ~B[1] || ~A[1] && B[1]);

    // Final comparison for the least significant bits
    wire final_comp;
    assign final_comp = (A[3:1] == B[3:1]) && (A[0] && ~B[0] || ~A[0] && B[0]);

    // Determine the outputs based on the comparisons
    assign A_greater = (msb_comp && A[3]) || (mid_comp && A[2]) || (lsb_comp && A[1]) || (final_comp && A[0]);
    assign A_less = (msb_comp && ~A[3]) || (mid_comp && ~A[2]) || (lsb_comp && ~A[1]) || (final_comp && ~A[0]);
    assign A_equal = ~(A_greater || A_less);

endmodule
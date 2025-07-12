module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // MSB comparison
    wire msb_greater = A[2] & ~B[2];
    wire msb_less = ~A[2] & B[2];
    wire msb_equal = ~(msb_greater | msb_less);

    // Middle bit comparison (only if MSBs equal)
    wire mid_greater = msb_equal & A[1] & ~B[1];
    wire mid_less = msb_equal & ~A[1] & B[1];
    wire mid_equal = msb_equal & ~(mid_greater | mid_less);

    // LSB comparison (only if both MSBs and middle bits equal)
    wire lsb_greater = mid_equal & A[0] & ~B[0];
    wire lsb_less = mid_equal & ~A[0] & B[0];
    wire lsb_equal = mid_equal & ~(lsb_greater | lsb_less);

    // Final output assignment
    assign A_greater = msb_greater | mid_greater | lsb_greater;
    assign A_less = msb_less | mid_less | lsb_less;
    assign A_equal = lsb_equal;

endmodule
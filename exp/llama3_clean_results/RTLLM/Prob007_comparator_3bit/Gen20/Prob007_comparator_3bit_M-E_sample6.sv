module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Compare MSB
wire msb_equal;
wire msb_A_greater;
assign msb_equal = A[2] == B[2];
assign msb_A_greater = A[2] > B[2];

// Compare middle bit if MSBs are equal
wire mid_equal;
wire mid_A_greater;
assign mid_equal = (msb_equal) ? (A[1] == B[1]) : 1'b0;
assign mid_A_greater = (msb_equal) ? (A[1] > B[1]) : msb_A_greater;

// Compare LSB if middle bits are equal
wire lsb_equal;
wire lsb_A_greater;
assign lsb_equal = (mid_equal) ? (A[0] == B[0]) : 1'b0;
assign lsb_A_greater = (mid_equal) ? (A[0] > B[0]) : mid_A_greater;

// Determine final outputs
assign A_greater = (msb_A_greater | ((~msb_A_greater & ~msb_equal) & lsb_A_greater)) ? 1'b1 : 1'b0;
assign A_equal = (msb_equal & mid_equal & lsb_equal) ? 1'b1 : 1'b0;
assign A_less = (~A_greater & ~A_equal) ? 1'b1 : 1'b0;

endmodule
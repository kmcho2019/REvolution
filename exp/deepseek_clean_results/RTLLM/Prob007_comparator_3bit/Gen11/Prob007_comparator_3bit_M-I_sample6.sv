module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// MSB comparison (highest priority)
wire msb_greater = A[2] & ~B[2];
wire msb_equal = (A[2] == B[2]);

// Middle bit comparison (only if MSBs equal)
wire mid_greater = msb_equal & (A[1] & ~B[1]);
wire mid_equal = msb_equal & (A[1] == B[1]);

// LSB comparison (only if higher bits equal)
wire lsb_greater = mid_equal & (A[0] & ~B[0]);
wire lsb_equal = mid_equal & (A[0] == B[0]);

// Output logic
assign A_greater = msb_greater | mid_greater | lsb_greater;
assign A_equal = msb_equal & mid_equal & lsb_equal;
assign A_less = (~A_greater) & (~A_equal);  // Could also be written as (A < B)

endmodule
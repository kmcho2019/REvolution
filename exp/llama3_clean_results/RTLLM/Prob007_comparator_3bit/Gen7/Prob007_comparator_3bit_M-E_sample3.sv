module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output wire A_greater,
    output wire A_equal,
    output wire A_less
);

wire A_B_msb_diff;
wire A_B_lsb_diff;
wire A_B_middle_diff;

// Compare MSB
assign A_B_msb_diff = (A[2] && ~B[2]) || (~A[2] && B[2]);

// Compare middle bit
assign A_B_middle_diff = (A[1] && ~B[1]) || (~A[1] && B[1]);

// Compare LSB
assign A_B_lsb_diff = (A[0] && ~B[0]) || (~A[0] && B[0]);

// Determine if A is greater than B
assign A_greater = (A[2] && ~B[2]) || 
                  (~A_B_msb_diff && (A[1] && ~B[1])) || 
                  (~A_B_msb_diff && ~A_B_middle_diff && (A[0] && ~B[0]));

// Determine if A is equal to B
assign A_equal = ~(A_B_msb_diff || A_B_middle_diff || A_B_lsb_diff);

// Determine if A is less than B
assign A_less = (~A[2] && B[2]) || 
               (~A_B_msb_diff && (~A[1] && B[1])) || 
               (~A_B_msb_diff && ~A_B_middle_diff && (~A[0] && B[0]));

endmodule
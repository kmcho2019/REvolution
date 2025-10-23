module comparator_3bit (
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

// Compare MSB
wire bit2_equal    = (A[2] == B[2]);
wire bit2_A_greater = (A[2] & ~B[2]);
wire bit2_A_less    = (~A[2] & B[2]);

// Compare middle bit
wire bit1_equal    = (A[1] == B[1]);
wire bit1_A_greater = (A[1] & ~B[1]);
wire bit1_A_less    = (~A[1] & B[1]);

// Compare LSB
wire bit0_equal    = (A[0] == B[0]);
wire bit0_A_greater = (A[0] & ~B[0]);
wire bit0_A_less    = (~A[0] & B[0]);

// Compute A_greater:
// If MSB differs, result depends on bit2.
// Else if middle bit differs, result depends on bit1.
// Else if LSB differs, result depends on bit0.
// Else inputs are equal.
assign A_greater = bit2_A_greater 
                   | (bit2_equal & bit1_A_greater) 
                   | (bit2_equal & bit1_equal & bit0_A_greater);

// Compute A_less similarly.
assign A_less = bit2_A_less 
                | (bit2_equal & bit1_A_less) 
                | (bit2_equal & bit1_equal & bit0_A_less);

// A_equal when all bits are equal.
assign A_equal = bit2_equal & bit1_equal & bit0_equal;

endmodule
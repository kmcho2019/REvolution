module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// MSB comparison
wire msb_equal = (A[2] == B[2]);
wire msb_greater = (A[2] > B[2]);

// Middle bit comparison
wire middle_equal = (A[1] == B[1]);
wire middle_greater = (A[1] > B[1]);

// LSB comparison
wire lsb_greater = (A[0] > B[0]);

// Hierarchical comparison logic
assign A_greater = msb_greater | 
                  (msb_equal & middle_greater) | 
                  (msb_equal & middle_equal & lsb_greater);

assign A_equal = msb_equal & middle_equal & (A[0] == B[0]);

// A_less is mutually exclusive by construction
assign A_less = ~A_greater & ~A_equal;

endmodule
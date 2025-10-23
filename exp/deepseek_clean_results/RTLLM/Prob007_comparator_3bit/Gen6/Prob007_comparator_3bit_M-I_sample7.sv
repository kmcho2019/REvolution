module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Direct bit comparisons
wire [2:0] bit_greater = A & ~B;
wire [2:0] bit_equal = ~(A ^ B);

// Local buffers for shared signals
wire eq_2_1 = bit_equal[2] & bit_equal[1];
wire eq_all = eq_2_1 & bit_equal[0];

// Optimized output logic
assign A_greater = bit_greater[2] | 
                  (bit_equal[2] & bit_greater[1]) | 
                  (eq_2_1 & bit_greater[0]);

assign A_equal = eq_all;

// Direct implementation for A_less
assign A_less = (~A[2] & B[2]) |
               (bit_equal[2] & ~A[1] & B[1]) |
               (eq_2_1 & ~A[0] & B[0]);

endmodule
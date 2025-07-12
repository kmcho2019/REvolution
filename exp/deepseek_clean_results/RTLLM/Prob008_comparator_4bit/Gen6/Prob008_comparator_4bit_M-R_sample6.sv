module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Direct comparison results for each bit
wire [3:0] bit_gt = A & ~B;
wire [3:0] bit_lt = ~A & B;
wire [3:0] bit_eq = ~(A ^ B);

// Priority-encoded outputs
assign A_greater = bit_gt[3] | 
                  (bit_eq[3] & bit_gt[2]) |
                  (bit_eq[3] & bit_eq[2] & bit_gt[1]) |
                  (bit_eq[3] & bit_eq[2] & bit_eq[1] & bit_gt[0]);

assign A_less = bit_lt[3] | 
               (bit_eq[3] & bit_lt[2]) |
               (bit_eq[3] & bit_eq[2] & bit_lt[1]) |
               (bit_eq[3] & bit_eq[2] & bit_eq[1] & bit_lt[0]);

assign A_equal = &bit_eq;

endmodule
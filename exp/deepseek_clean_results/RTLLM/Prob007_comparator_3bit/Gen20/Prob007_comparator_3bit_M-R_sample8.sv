module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [2:0] bit_eq;  // Bit equality
wire [2:0] bit_gt;  // Bit greater than

// Generate comparison for each bit
genvar i;
generate
    for (i = 0; i < 3; i = i + 1) begin : bit_compare
        assign bit_eq[i] = (A[i] == B[i]);
        assign bit_gt[i] = (A[i] & ~B[i]);
    end
endgenerate

// Hierarchical comparison logic
assign A_greater = bit_gt[2] | 
                  (bit_eq[2] & bit_gt[1]) | 
                  (bit_eq[2] & bit_eq[1] & bit_gt[0]);

assign A_equal = &bit_eq;  // All bits equal

assign A_less = ~A_greater & ~A_equal;  // Mutually exclusive

endmodule
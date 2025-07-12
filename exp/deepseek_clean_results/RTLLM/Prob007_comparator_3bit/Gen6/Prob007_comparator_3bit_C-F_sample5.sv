module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bit-wise comparison signals
    wire [2:0] A_gt_B_bit;
    wire [2:0] A_eq_B_bit;
    wire [2:0] A_lt_B_bit;

    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin : bit_compare
            assign A_gt_B_bit[i] = A[i] & ~B[i];
            assign A_eq_B_bit[i] = ~(A[i] ^ B[i]);
            assign A_lt_B_bit[i] = ~A[i] & B[i];
        end
    endgenerate

    // Hierarchical comparison logic
    assign A_greater = A_gt_B_bit[2] |
                      (A_eq_B_bit[2] & A_gt_B_bit[1]) |
                      (A_eq_B_bit[2] & A_eq_B_bit[1] & A_gt_B_bit[0]);

    assign A_equal = A_eq_B_bit[2] & A_eq_B_bit[1] & A_eq_B_bit[0];

    assign A_less = A_lt_B_bit[2] |
                   (A_eq_B_bit[2] & A_lt_B_bit[1]) |
                   (A_eq_B_bit[2] & A_eq_B_bit[1] & A_lt_B_bit[0]);

endmodule
module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Per-bit greater and less signals
    wire [3:0] gt_bit;
    wire [3:0] lt_bit;
    wire [3:0] eq_bit;

    genvar i;
    generate
        for(i = 0; i < 4; i = i +1) begin : bit_compare
            assign gt_bit[i] = A[i] & ~B[i];
            assign lt_bit[i] = ~A[i] & B[i];
            assign eq_bit[i] = ~(A[i] ^ B[i]);
        end
    endgenerate

    // Hierarchical comparison from MSB to LSB:
    // If at MSB bit A> B then A_greater=1, else if A< B then A_less=1, else check next bit...
    wire comp3_greater = gt_bit[3];
    wire comp3_less    = lt_bit[3];
    wire comp2_greater = gt_bit[2] & eq_bit[3];
    wire comp2_less    = lt_bit[2] & eq_bit[3];
    wire comp1_greater = gt_bit[1] & eq_bit[3] & eq_bit[2];
    wire comp1_less    = lt_bit[1] & eq_bit[3] & eq_bit[2];
    wire comp0_greater = gt_bit[0] & eq_bit[3] & eq_bit[2] & eq_bit[1];
    wire comp0_less    = lt_bit[0] & eq_bit[3] & eq_bit[2] & eq_bit[1];

    assign A_greater = comp3_greater | comp2_greater | comp1_greater | comp0_greater;
    assign A_less    = comp3_less    | comp2_less    | comp1_less    | comp0_less;

    // A_equal is true only if all bits are equal
    assign A_equal = &eq_bit;

endmodule
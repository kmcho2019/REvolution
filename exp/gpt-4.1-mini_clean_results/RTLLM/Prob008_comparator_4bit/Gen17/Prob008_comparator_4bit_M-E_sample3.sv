module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Bitwise comparisons
    wire [3:0] gt; // A[i] > B[i]
    wire [3:0] eq; // A[i] == B[i]
    wire [3:0] lt; // A[i] < B[i]

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : bit_compare
            assign gt[i] = A[i] & ~B[i];
            assign eq[i] = ~(A[i] ^ B[i]);
            assign lt[i] = ~A[i] & B[i];
        end
    endgenerate

    // Calculate hierarchical equalities for cascading
    wire eq_3_2 = eq[3] & eq[2];
    wire eq_3_2_1 = eq_3_2 & eq[1];
    wire eq_all = eq_3_2_1 & eq[0];

    // Determine final outputs by lexicographical order from MSB to LSB
    assign A_greater = gt[3] | (eq[3] & gt[2]) | (eq_3_2 & gt[1]) | (eq_3_2_1 & gt[0]);
    assign A_less    = lt[3] | (eq[3] & lt[2]) | (eq_3_2 & lt[1]) | (eq_3_2_1 & lt[0]);
    assign A_equal   = eq_all;

endmodule
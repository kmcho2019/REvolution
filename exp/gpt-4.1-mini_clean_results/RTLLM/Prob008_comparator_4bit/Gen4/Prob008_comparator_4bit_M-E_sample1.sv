module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Per-bit comparison signals
    wire [3:0] gt_bits;  // A[i] > B[i]
    wire [3:0] eq_bits;  // A[i] == B[i]
    wire [3:0] lt_bits;  // A[i] < B[i]

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : bit_comp
            assign gt_bits[i] = A[i] & ~B[i];
            assign lt_bits[i] = ~A[i] & B[i];
            assign eq_bits[i] = ~(A[i] ^ B[i]);
        end
    endgenerate

    // Cascade comparison from MSB to LSB:
    // Check MSB first. If equal, proceed to next bit; else output accordingly.

    wire greater_at_3 = gt_bits[3];
    wire less_at_3    = lt_bits[3];
    wire equal_3      = eq_bits[3];

    wire greater_at_2 = gt_bits[2];
    wire less_at_2    = lt_bits[2];
    wire equal_2      = eq_bits[2];

    wire greater_at_1 = gt_bits[1];
    wire less_at_1    = lt_bits[1];
    wire equal_1      = eq_bits[1];

    wire greater_at_0 = gt_bits[0];
    wire less_at_0    = lt_bits[0];
    wire equal_0      = eq_bits[0];

    // Build the chain of comparison decisions
    wire gt_chain;
    wire lt_chain;
    wire eq_chain;

    // Compare bit 3
    wire gt_3 = greater_at_3;
    wire lt_3 = less_at_3;
    wire eq_3 = equal_3;

    // Compare bit 2 if bit 3 equal
    wire gt_2 = eq_3 & greater_at_2;
    wire lt_2 = eq_3 & less_at_2;
    wire eq_2 = eq_3 & equal_2;

    // Compare bit 1 if bits 3 and 2 equal
    wire gt_1 = eq_2 & greater_at_1;
    wire lt_1 = eq_2 & less_at_1;
    wire eq_1 = eq_2 & equal_1;

    // Compare bit 0 if bits 3,2,1 equal
    wire gt_0 = eq_1 & greater_at_0;
    wire lt_0 = eq_1 & less_at_0;
    wire eq_0 = eq_1 & equal_0;

    // Final outputs
    assign A_greater = gt_3 | gt_2 | gt_1 | gt_0;
    assign A_less    = lt_3 | lt_2 | lt_1 | lt_0;
    assign A_equal   = eq_0; // All bits equal

endmodule
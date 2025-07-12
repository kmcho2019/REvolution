module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // 1-bit comparator signals per bit
    wire [3:0] gt_bit; // A[i] > B[i]
    wire [3:0] eq_bit; // A[i] == B[i]
    wire [3:0] lt_bit; // A[i] < B[i]

    genvar i;
    generate
        for (i = 0; i < 4; i = i +1) begin : bit_compare
            assign gt_bit[i] = A[i] & ~B[i];     // A=1, B=0 -> A > B
            assign lt_bit[i] = ~A[i] & B[i];     // A=0, B=1 -> A < B
            assign eq_bit[i] = ~(A[i] ^ B[i]);   // equal if bits match
        end
    endgenerate

    // Combine bit-level comparisons from MSB to LSB
    // The final comparison results are computed using priority:
    // If MSB differs, that determines result
    // If MSB equal, check next bit, and so forth

    // Intermediate signals for hierarchical resolution
    wire [3:0] gt_chain;
    wire [3:0] lt_chain;
    wire [3:0] eq_chain;

    // LSB level: at bit 0, comparison equals bit-level results
    assign gt_chain[0] = gt_bit[0];
    assign lt_chain[0] = lt_bit[0];
    assign eq_chain[0] = eq_bit[0];

    // For higher bits, propagate comparison results:
    // gt_chain[i] = gt_bit[i] OR (eq_bit[i] AND gt_chain[i-1])
    // lt_chain[i] = lt_bit[i] OR (eq_bit[i] AND lt_chain[i-1])
    // eq_chain[i] = eq_bit[i] AND eq_chain[i-1]
    generate
        for (i = 1; i < 4; i = i + 1) begin : chain_logic
            assign gt_chain[i] = gt_bit[i] | (eq_bit[i] & gt_chain[i-1]);
            assign lt_chain[i] = lt_bit[i] | (eq_bit[i] & lt_chain[i-1]);
            assign eq_chain[i] = eq_bit[i] & eq_chain[i-1];
        end
    endgenerate

    // Final output corresponds to the MSB of the chains
    assign A_greater = gt_chain[3];
    assign A_less    = lt_chain[3];
    assign A_equal   = eq_chain[3];

endmodule
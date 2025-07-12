module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] gt_bit; // Bitwise A > B
    wire [3:0] eq_bit; // Bitwise A == B
    wire [3:0] lt_bit; // Bitwise A < B

    // Generate bit-level comparison signals
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : BIT_COMP
            assign gt_bit[i] = A[i] & ~B[i];
            assign eq_bit[i] = ~(A[i] ^ B[i]);
            assign lt_bit[i] = ~A[i] & B[i];
        end
    endgenerate

    // Combine bit comparisons hierarchically from MSB to LSB:
    // For bit i: 
    //  - If A[i] > B[i] => A_greater=1, else if A[i]<B[i] => A_less=1
    //  - Else if equal, check lower bits
    wire [3:0] greater_chain;
    wire [3:0] equal_chain;
    wire [3:0] less_chain;

    // Start from LSB: if bits equal then propagate equals, else gt/lt from that bit
    assign greater_chain[0] = gt_bit[0];
    assign less_chain[0]    = lt_bit[0];
    assign equal_chain[0]   = eq_bit[0];

    generate
        for (i = 1; i < 4; i = i + 1) begin : CHAIN
            // If current bit A > B => set greater_chain[i] = 1
            // Else if A < B => less_chain[i] = 1
            // Else propagate previous results
            assign greater_chain[i] = gt_bit[i] | (eq_bit[i] & greater_chain[i-1]);
            assign less_chain[i]    = lt_bit[i] | (eq_bit[i] & less_chain[i-1]);
            assign equal_chain[i]   = eq_bit[i] & equal_chain[i-1];
        end
    endgenerate

    // Final outputs from MSB chain values
    assign A_greater = greater_chain[3];
    assign A_less    = less_chain[3];
    assign A_equal   = equal_chain[3];

endmodule
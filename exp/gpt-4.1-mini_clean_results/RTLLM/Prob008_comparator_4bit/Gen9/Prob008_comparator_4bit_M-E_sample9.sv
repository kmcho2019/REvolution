module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] gt; // bitwise A[i] > B[i]
    wire [3:0] eq; // bitwise A[i] == B[i]
    wire [3:0] lt; // bitwise A[i] < B[i]

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : bit_compare
            assign gt[i] = A[i] & ~B[i];
            assign eq[i] = ~(A[i] ^ B[i]);
            assign lt[i] = ~A[i] & B[i];
        end
    endgenerate

    // Combine comparison results from MSB to LSB:
    // Use a cascade to propagate decisions down the bits.
    // We'll generate final signals stepwise:
    // greater_so_far[i], less_so_far[i], equal_so_far[i]

    wire [4:0] greater_so_far;
    wire [4:0] less_so_far;
    wire [4:0] equal_so_far;

    // Initialize at bit 4 (no bits checked yet)
    assign greater_so_far[4] = 0;
    assign less_so_far[4]    = 0;
    assign equal_so_far[4]   = 1; // no difference so far means equal

    generate
        for (i = 3; i >= 0; i = i - 1) begin : combine_comp
            assign greater_so_far[i] = gt[i] | (eq[i] & greater_so_far[i+1]);
            assign less_so_far[i]    = lt[i] | (eq[i] & less_so_far[i+1]);
            assign equal_so_far[i]   = eq[i] & equal_so_far[i+1];
        end
    endgenerate

    assign A_greater = greater_so_far[0];
    assign A_less    = less_so_far[0];
    assign A_equal   = equal_so_far[0];

endmodule
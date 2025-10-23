module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Per bit comparison signals
    wire [3:0] gt_bits;  // A[i] > B[i]
    wire [3:0] eq_bits;  // A[i] == B[i]
    wire [3:0] lt_bits;  // A[i] < B[i]

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : bit_compare
            assign gt_bits[i] = A[i] & ~B[i];
            assign eq_bits[i] = ~(A[i] ^ B[i]);
            assign lt_bits[i] = ~A[i] & B[i];
        end
    endgenerate

    // Priority signals from MSB to LSB
    // The decision is made at the highest bit where A and B differ.
    // We build a chain of "equal so far" signals starting from MSB downward.
    wire eq_3_0, eq_2_0, eq_1_0;

    assign eq_3_0 = eq_bits[3];
    assign eq_2_0 = eq_3_0 & eq_bits[2];
    assign eq_1_0 = eq_2_0 & eq_bits[1];

    // Detect if A > B at bit 3, else if bits 3 equal check bit 2, and so forth.
    wire A_gt = 
        (gt_bits[3]) |
        (eq_bits[3] & gt_bits[2]) |
        (eq_2_0 & gt_bits[1]) |
        (eq_1_0 & gt_bits[0]);

    wire A_lt = 
        (lt_bits[3]) |
        (eq_bits[3] & lt_bits[2]) |
        (eq_2_0 & lt_bits[1]) |
        (eq_1_0 & lt_bits[0]);

    wire A_eq = eq_3_0 & eq_bits[2] & eq_bits[1] & eq_bits[0];

    // Outputs are mutually exclusive
    assign A_greater = A_gt;
    assign A_less    = A_lt;
    assign A_equal   = A_eq;

endmodule
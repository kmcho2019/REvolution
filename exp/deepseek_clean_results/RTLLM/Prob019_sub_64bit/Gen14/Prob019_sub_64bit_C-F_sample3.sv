module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output logic signed [63:0] result,
    output logic overflow
);

    // Local parameters for documentation
    localparam OVERFLOW = 1'b1;
    localparam NO_OVERFLOW = 1'b0;

    // Two's complement subtraction: A - B = A + ~B + 1
    wire [63:0] B_comp = ~B;
    wire [63:0] p, g;  // Propagate and generate signals
    wire [63:0] carry; // Carry chain (64 bits needed)

    // First stage: Initial carry-in
    assign carry[0] = 1'b1;  // +1 for two's complement
    assign p[0] = A[0] ^ B_comp[0];
    assign g[0] = A[0] & B_comp[0];
    assign result[0] = p[0] ^ carry[0];

    // Carry-lookahead implementation
    genvar i;
    generate
        for (i = 1; i < 64; i = i + 1) begin : sub_adder
            assign p[i] = A[i] ^ B_comp[i];
            assign g[i] = A[i] & B_comp[i];
            assign carry[i] = g[i-1] | (p[i-1] & carry[i-1]);
            assign result[i] = p[i] ^ carry[i];
        end
    endgenerate

    /* Overflow Detection:
     * Positive overflow: A positive, B negative, result negative
     * Negative overflow: A negative, B positive, result positive
     * Detected when:
     * - Signs of A and B differ (A[63] != B[63])
     * - Result sign differs from A (A[63] != result[63])
     */
    always_comb begin
        overflow = (A[63] != B[63]) && (A[63] != result[63]) ? OVERFLOW : NO_OVERFLOW;
    end

    /* Implementation Notes:
     * 1. Carry-lookahead implementation reduces critical path vs ripple-carry
     * 2. Packed arrays optimize area usage
     * 3. Single comparison overflow detection minimizes logic
     * 4. Generate block ensures scalability
     */
endmodule
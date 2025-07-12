module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output logic signed [63:0] result,
    output logic overflow
);

    // Local parameters for documentation
    localparam OVERFLOW = 1'b1;
    localparam NO_OVERFLOW = 1'b0;

    // Carry-lookahead implementation of subtraction (A - B = A + ~B + 1)
    wire [63:0] B_comp = ~B;
    wire [64:0] carry_chain;
    assign carry_chain[0] = 1'b1; // +1 for two's complement
    
    genvar i;
    generate
        for (i=0; i<64; i=i+1) begin : sub_adder
            // Propagate and generate signals
            wire p = A[i] ^ B_comp[i];
            wire g = A[i] & B_comp[i];
            
            // Carry lookahead
            assign carry_chain[i+1] = g | (p & carry_chain[i]);
            
            // Sum calculation
            assign result[i] = p ^ carry_chain[i];
        end
    endgenerate

    // Overflow detection (optimized single comparison)
    always_comb begin
        overflow = (A[63] != B[63]) && (A[63] != result[63]) ? OVERFLOW : NO_OVERFLOW;
    end

    /* Overflow Conditions:
     * 1. Positive overflow: A positive, B negative, result negative
     * 2. Negative overflow: A negative, B positive, result positive
     * Detected when:
     * - Signs of A and B differ (A[63] != B[63])
     * - Result sign differs from A (A[63] != result[63])
     */

endmodule
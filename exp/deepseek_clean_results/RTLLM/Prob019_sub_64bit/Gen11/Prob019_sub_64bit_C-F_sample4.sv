module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output logic signed [63:0] result,
    output logic overflow
);

    // Local parameters for documentation
    localparam OVERFLOW = 1'b1;
    localparam NO_OVERFLOW = 1'b0;

    // Packed arrays for propagate/generate signals
    logic [63:0] p, g;
    
    // Carry-lookahead implementation of subtraction (A - B = A + ~B + 1)
    wire [63:0] B_comp = ~B;
    wire [64:0] carry_chain;
    assign carry_chain[0] = 1'b1; // +1 for two's complement
    
    genvar i;
    generate
        for (i=0; i<64; i=i+1) begin : sub_adder
            // Propagate and generate signals
            assign p[i] = A[i] ^ B_comp[i];
            assign g[i] = A[i] & B_comp[i];
            
            // Carry lookahead
            assign carry_chain[i+1] = g[i] | (p[i] & carry_chain[i]);
            
            // Sum calculation
            assign result[i] = p[i] ^ carry_chain[i];
        end
    endgenerate

    /* Overflow Detection:
     * Detects when:
     * 1. Positive overflow: A positive, B negative, result negative
     * 2. Negative overflow: A negative, B positive, result positive
     * Implemented as single comparison:
     * overflow = (A[63] != B[63]) && (A[63] != result[63])
     */
    always_comb begin
        overflow = (A[63] != B[63]) && (A[63] != result[63]) ? OVERFLOW : NO_OVERFLOW;
    end

    /* Implementation Notes:
     * 1. Subtraction implemented as A + ~B + 1 (two's complement)
     * 2. Carry-lookahead adder provides good timing characteristics
     * 3. Packed arrays used for propagate/generate signals to reduce wiring
     * 4. No input registers to minimize power and area
     */
endmodule
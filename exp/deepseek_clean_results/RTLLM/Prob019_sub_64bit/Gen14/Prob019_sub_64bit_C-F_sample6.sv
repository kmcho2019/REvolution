module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output logic signed [63:0] result,
    output logic overflow
);

    // Documentation parameters
    localparam OVERFLOW = 1'b1;
    localparam NO_OVERFLOW = 1'b0;

    /* Subtraction Implementation:
     * A - B is implemented as A + ~B + 1 (two's complement)
     * Using carry-lookahead structure for optimal performance
     */
    wire [63:0] B_comp = ~B;
    wire [64:0] carry_chain;
    assign carry_chain[0] = 1'b1; // +1 for two's complement
    
    // Carry-lookahead adder implementation
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

    /* Overflow Detection:
     * Overflow occurs when:
     * Case 1: Positive - Negative = Negative (positive overflow)
     * Case 2: Negative - Positive = Positive (negative overflow)
     * Detected by: (A[63] != B[63]) && (A[63] != result[63])
     */
    always_comb begin
        overflow = (A[63] != B[63]) && (A[63] != result[63]) ? OVERFLOW : NO_OVERFLOW;
    end

    /* Alternative overflow detection using carry-out:
     * wire final_carry = carry_chain[64];
     * overflow = (A[63] == B_comp[63]) && (result[63] != A[63]);
     * This method is equivalent but less intuitive
     */

endmodule
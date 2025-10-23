module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output logic signed [63:0] result,
    output logic overflow
);

    // Documentation constants
    localparam OVERFLOW = 1'b1;
    localparam NO_OVERFLOW = 1'b0;
    localparam BLOCK_SIZE = 4;  // 4-bit carry-lookahead blocks

    // Two's complement subtraction: A - B = A + ~B + 1
    wire [63:0] B_comp = ~B;
    wire [16:0] block_carry;  // 64/4 = 16 blocks + 1 initial carry
    assign block_carry[0] = 1'b1;  // +1 for two's complement

    // Hierarchical carry-lookahead implementation
    genvar i, j;
    generate
        for (i=0; i<64; i=i+BLOCK_SIZE) begin : block
            // Block propagate and generate
            wire p_block = &(A[i+:BLOCK_SIZE] ^ B_comp[i+:BLOCK_SIZE]);
            wire g_block = |(A[i+:BLOCK_SIZE] & B_comp[i+:BLOCK_SIZE]);

            // Block carry calculation
            assign block_carry[i/BLOCK_SIZE+1] = g_block | 
                                               (p_block & block_carry[i/BLOCK_SIZE]);

            // Bit-level operations within each block
            for (j=0; j<BLOCK_SIZE; j=j+1) begin : bit
                if (i+j < 64) begin  // Handle non-multiple-of-4 cases
                    wire p_bit = A[i+j] ^ B_comp[i+j];
                    wire g_bit = A[i+j] & B_comp[i+j];
                    wire carry_in = (j == 0) ? block_carry[i/BLOCK_SIZE] :
                                    g_bit | (p_bit & result[i+j-1]);
                    assign result[i+j] = p_bit ^ carry_in;
                end
            end
        end
    endgenerate

    /* Optimized Overflow Detection:
     * Detects when sign of result doesn't match expected sign
     * (A negative and B positive gives negative result) OR
     * (A positive and B negative gives positive result)
     */
    wire a_neg_b_pos = A[63] & ~B[63];
    wire a_pos_b_neg = ~A[63] & B[63];
    wire result_sign_mismatch = (a_neg_b_pos & ~result[63]) | 
                               (a_pos_b_neg & result[63]);

    always_comb begin
        overflow = result_sign_mismatch ? OVERFLOW : NO_OVERFLOW;
    end

    // Operand isolation for power optimization
    // (Assuming enable signal exists in system)
    // wire enable;  // Would come from higher level control
    // assign result = enable ? calculated_result : 'z;
    // assign overflow = enable ? calculated_overflow : 'z;

endmodule
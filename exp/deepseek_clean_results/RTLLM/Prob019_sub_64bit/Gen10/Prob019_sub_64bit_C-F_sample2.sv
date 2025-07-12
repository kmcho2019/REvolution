module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output reg signed [63:0] result,
    output reg overflow
);

    // Hierarchical carry-lookahead subtraction (4-bit blocks)
    wire [63:0] B_comp = ~B;
    wire [16:0] block_carry;
    assign block_carry[0] = 1'b1; // +1 for two's complement

    genvar i;
    generate
        for (i=0; i<16; i=i+1) begin : sub_blocks
            // Block-level propagate and generate
            wire [3:0] p = A[i*4 +:4] ^ B_comp[i*4 +:4];
            wire [3:0] g = A[i*4 +:4] & B_comp[i*4 +:4];
            
            // Block carry lookahead
            assign block_carry[i+1] = g[3] | 
                                     (p[3] & g[2]) |
                                     (p[3] & p[2] & g[1]) |
                                     (p[3] & p[2] & p[1] & g[0]) |
                                     (p[3] & p[2] & p[1] & p[0] & block_carry[i]);
            
            // Bit-level sum calculation
            always_comb begin
                result[i*4]   = p[0] ^ block_carry[i];
                result[i*4+1] = p[1] ^ (g[0] | (p[0] & block_carry[i]));
                result[i*4+2] = p[2] ^ (g[1] | (p[1] & g[0]) | (p[1] & p[0] & block_carry[i]));
                result[i*4+3] = p[3] ^ (g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | 
                               (p[2] & p[1] & p[0] & block_carry[i]));
            end
        end
    endgenerate

    // Overflow detection using shared MSB logic
    always_comb begin
        case ({A[63], B[63], result[63]})
            3'b001: overflow = 1'b1;  // Positive overflow
            3'b110: overflow = 1'b1;  // Negative overflow
            default: overflow = 1'b0; // No overflow
        endcase
    end

endmodule
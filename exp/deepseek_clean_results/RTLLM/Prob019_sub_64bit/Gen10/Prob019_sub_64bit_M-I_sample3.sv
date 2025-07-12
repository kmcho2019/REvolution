module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Hierarchical 4-bit CLA blocks
    wire [15:0] group_propagate;
    wire [15:0] group_generate;
    wire [16:0] group_carry;
    assign group_carry[0] = 1'b1; // +1 for subtraction
    
    // Generate 16x 4-bit CLA blocks
    genvar i;
    generate
        for (i=0; i<16; i=i+1) begin : CLA_BLOCKS
            wire [3:0] p, g;
            wire [4:0] carry;
            assign carry[0] = group_carry[i];
            
            // Bit-level propagate/generate
            assign p[0] = A[i*4+0] ^ ~B[i*4+0];
            assign p[1] = A[i*4+1] ^ ~B[i*4+1];
            assign p[2] = A[i*4+2] ^ ~B[i*4+2];
            assign p[3] = A[i*4+3] ^ ~B[i*4+3];
            
            assign g[0] = A[i*4+0] & ~B[i*4+0];
            assign g[1] = A[i*4+1] & ~B[i*4+1];
            assign g[2] = A[i*4+2] & ~B[i*4+2];
            assign g[3] = A[i*4+3] & ~B[i*4+3];
            
            // Block-level propagate/generate
            assign group_propagate[i] = &p;
            assign group_generate[i] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
            
            // Carry lookahead within block
            assign carry[1] = g[0] | (p[0] & carry[0]);
            assign carry[2] = g[1] | (p[1] & carry[1]);
            assign carry[3] = g[2] | (p[2] & carry[2]);
            assign carry[4] = g[3] | (p[3] & carry[3]);
            
            // Result calculation
            assign result[i*4+0] = p[0] ^ carry[0];
            assign result[i*4+1] = p[1] ^ carry[1];
            assign result[i*4+2] = p[2] ^ carry[2];
            assign result[i*4+3] = p[3] ^ carry[3];
            
            // Group carry propagation
            assign group_carry[i+1] = group_generate[i] | (group_propagate[i] & group_carry[i]);
        end
    endgenerate

    // Overflow detection using final carry and sign bits
    assign overflow = (A[63] ^ B[63]) && (A[63] ^ result[63]);

endmodule
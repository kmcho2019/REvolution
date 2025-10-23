module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Generate and Propagate signals for each bit
    wire [32:1] G = A & B;
    wire [32:1] P = A ^ B;
    
    // Carry signals for each 4-bit group
    wire [8:0] C;
    assign C[0] = 1'b0;  // Initial carry-in
    
    // Carry lookahead logic for 32-bit adder (8 groups of 4 bits)
    assign C[1] = G[4] | (P[4] & C[0]);
    assign C[2] = G[8] | (P[8] & C[1]);
    assign C[3] = G[12] | (P[12] & C[2]);
    assign C[4] = G[16] | (P[16] & C[3]);
    assign C[5] = G[20] | (P[20] & C[4]);
    assign C[6] = G[24] | (P[24] & C[5]);
    assign C[7] = G[28] | (P[28] & C[6]);
    assign C[8] = G[32] | (P[32] & C[7]);  // Final carry-out
    
    // Generate 8 instances of 4-bit CLA blocks
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : cla_blocks
            // Local carry signals within each 4-bit block
            wire [3:0] c;
            assign c[0] = C[i];
            assign c[1] = G[i*4+1] | (P[i*4+1] & c[0]);
            assign c[2] = G[i*4+2] | (P[i*4+2] & c[1]);
            assign c[3] = G[i*4+3] | (P[i*4+3] & c[2]);
            
            // Sum generation
            assign S[i*4+1] = P[i*4+1] ^ c[0];
            assign S[i*4+2] = P[i*4+2] ^ c[1];
            assign S[i*4+3] = P[i*4+3] ^ c[2];
            assign S[i*4+4] = P[i*4+4] ^ c[3];
        end
    endgenerate
    
    assign C32 = C[8];  // Final carry-out
endmodule
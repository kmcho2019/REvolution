module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Generate and propagate signals for all bits
    wire [32:0] G, P;
    assign G[0] = 1'b0;
    assign P[0] = 1'b0;
    
    genvar i;
    generate
        for (i = 1; i <= 32; i = i + 1) begin : bit_slice
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] ^ B[i];
        end
    endgenerate

    // Carry computation using prefix tree (4-bit blocks)
    wire [32:0] C;
    assign C[0] = 1'b0;
    
    // First level - 4-bit blocks
    wire [7:0] G4, P4;
    generate
        for (i = 0; i < 8; i = i + 1) begin : carry4
            assign G4[i] = G[i*4+4] | (P[i*4+4] & (G[i*4+3] | (P[i*4+3] & 
                          (G[i*4+2] | (P[i*4+2] & G[i*4+1])))));
            assign P4[i] = P[i*4+1] & P[i*4+2] & P[i*4+3] & P[i*4+4];
            assign C[i*4+1] = G[i*4] | (P[i*4] & C[i*4]);
            assign C[i*4+2] = G[i*4+1] | (P[i*4+1] & C[i*4+1]);
            assign C[i*4+3] = G[i*4+2] | (P[i*4+2] & C[i*4+2]);
            assign C[i*4+4] = G[i*4+3] | (P[i*4+3] & C[i*4+3]);
        end
    endgenerate

    // Second level - 16-bit super blocks
    wire [1:0] G16, P16;
    generate
        for (i = 0; i < 2; i = i + 1) begin : carry16
            assign G16[i] = G4[i*4+3] | (P4[i*4+3] & (G4[i*4+2] | (P4[i*4+2] & 
                           (G4[i*4+1] | (P4[i*4+1] & G4[i*4])))));
            assign P16[i] = P4[i*4] & P4[i*4+1] & P4[i*4+2] & P4[i*4+3];
            assign C[i*16+16] = G16[i] | (P16[i] & C[i*16]);
        end
    endgenerate

    // Final carry out
    assign C32 = C[32];

    // Sum computation
    generate
        for (i = 1; i <= 32; i = i + 1) begin : sum
            assign S[i] = P[i] ^ C[i-1];
        end
    endgenerate
endmodule
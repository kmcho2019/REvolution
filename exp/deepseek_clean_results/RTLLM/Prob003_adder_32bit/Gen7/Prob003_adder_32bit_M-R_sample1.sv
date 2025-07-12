module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Generate and Propagate signals for each bit
    wire [32:0] G, P;
    wire [32:0] C;
    
    // Bit-level PG computation
    assign G[32:1] = A & B;
    assign P[32:1] = A ^ B;
    
    // Initial carry-in
    assign C[0] = 1'b0;
    
    // Carry computation for 4-bit blocks
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 4) begin : carry_block
            // Block Generate and Propagate
            wire G_block = G[i+3] | (P[i+3] & G[i+2]) | 
                          (P[i+3] & P[i+2] & G[i+1]) | 
                          (P[i+3] & P[i+2] & P[i+1] & G[i]);
            wire P_block = P[i+3] & P[i+2] & P[i+1] & P[i];
            
            // Block carry computation
            assign C[i+4] = G_block | (P_block & C[i]);
            
            // Bit-level carries within the block
            assign C[i+1] = G[i] | (P[i] & C[i]);
            assign C[i+2] = G[i+1] | (P[i+1] & C[i+1]);
            assign C[i+3] = G[i+2] | (P[i+2] & C[i+2]);
        end
    endgenerate
    
    // Sum computation
    assign S = P[32:1] ^ C[32:1];
    assign C32 = C[32];
endmodule
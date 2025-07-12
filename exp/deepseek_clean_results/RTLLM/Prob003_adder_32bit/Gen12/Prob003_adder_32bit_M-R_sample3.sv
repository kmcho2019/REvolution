module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Generate and propagate signals
    wire [32:0] G, P;
    wire [32:0] C;
    
    // Initialize carry chain
    assign C[0] = 1'b0;
    
    // Generate individual bit propagate/generate terms
    assign P[32:1] = A ^ B;
    assign G[32:1] = A & B;
    
    // Parallel prefix computation (Brent-Kung structure)
    // First level: 2-bit groups
    wire [31:1] G1, P1;
    genvar i;
    generate
        for (i = 1; i <= 31; i = i + 2) begin : level1
            assign G1[i] = G[i+1] | (P[i+1] & G[i]);
            assign P1[i] = P[i+1] & P[i];
        end
        
        // Second level: 4-bit groups
        wire [29:1] G2, P2;
        for (i = 1; i <= 29; i = i + 4) begin : level2
            assign G2[i] = G1[i+2] | (P1[i+2] & G1[i]);
            assign P2[i] = P1[i+2] & P1[i];
        end
        
        // Third level: 8-bit groups
        wire [25:1] G3, P3;
        for (i = 1; i <= 25; i = i + 8) begin : level3
            assign G3[i] = G2[i+4] | (P2[i+4] & G2[i]);
            assign P3[i] = P2[i+4] & P2[i];
        end
        
        // Fourth level: 16-bit groups
        wire [17:1] G4, P4;
        for (i = 1; i <= 17; i = i + 16) begin : level4
            assign G4[i] = G3[i+8] | (P3[i+8] & G3[i]);
            assign P4[i] = P3[i+8] & P3[i];
        end
        
        // Fifth level: 32-bit carry
        assign C32 = G4[17] | (P4[17] & G4[1]);
        
        // Carry computation for each bit
        for (i = 1; i <= 32; i = i + 1) begin : carry_gen
            if (i % 2 == 1) begin
                assign C[i] = G[i] | (P[i] & C[i-1]);
            end else if (i % 4 == 2) begin
                assign C[i] = G1[i-1] | (P1[i-1] & C[i-2]);
            end else if (i % 8 == 4) begin
                assign C[i] = G2[i-3] | (P2[i-3] & C[i-4]);
            end else if (i % 16 == 8) begin
                assign C[i] = G3[i-7] | (P3[i-7] & C[i-8]);
            end else begin
                assign C[i] = G4[i-15] | (P4[i-15] & C[i-16]);
            end
        end
    endgenerate
    
    // Sum computation
    assign S = P[32:1] ^ C[31:0];
endmodule
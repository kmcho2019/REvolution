module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Generate and propagate terms for all bits
    wire [32:1] G = A & B;
    wire [32:1] P = A ^ B;
    
    // Carry computation with balanced logic
    wire [32:0] C;
    assign C[0] = 1'b0;
    
    // Carry lookahead logic optimized for 32 bits
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & C[0]);
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & C[0]);
    
    // Block-level carry lookahead for remaining bits
    genvar i;
    generate
        for (i = 4; i <= 32; i = i + 1) begin : carry_gen
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate
    
    // Sum calculation with shared XOR resources
    assign S = P ^ C[32:1];
    assign C32 = C[32];
endmodule
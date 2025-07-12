module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Generate and propagate signals for each bit
    wire [32:0] G, P, C;
    
    assign C[0] = 1'b0;  // Initial carry-in
    
    // Bit-level propagate and generate
    assign P[32:1] = A ^ B;
    assign G[32:1] = A & B;
    
    // Carry computation - unrolled for better performance
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & C[0]);
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & C[0]);
    
    // Group-level carry computation (4-bit groups)
    genvar i;
    generate
        for (i = 4; i <= 32; i = i + 1) begin : carry_gen
            if (i % 4 == 0) begin
                // Group propagate and generate
                wire Pg = &P[i:i-3];
                wire Gg = G[i] | (P[i] & G[i-1]) | (P[i] & P[i-1] & G[i-2]) | 
                         (P[i] & P[i-1] & P[i-2] & G[i-3]);
                
                // Group carry computation
                assign C[i] = Gg | (Pg & C[i-4]);
            end else begin
                // Individual bit carry within group
                assign C[i] = G[i] | (P[i] & C[i-1]);
            end
        end
    endgenerate
    
    // Sum computation
    assign S = P[32:1] ^ C[31:0];
    assign C32 = C[32];
endmodule
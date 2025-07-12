module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Generate and propagate signals for each bit
    wire [32:0] G, P;
    wire [32:0] C;
    
    assign C[0] = 1'b0;  // Initial carry-in
    
    // Generate G and P for each bit
    genvar i;
    generate
        for (i = 1; i <= 32; i = i + 1) begin : bit_slice
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] ^ B[i];
            assign S[i] = P[i] ^ C[i-1];
        end
    endgenerate
    
    // Carry lookahead computation - 4-bit blocks
    generate
        for (i = 1; i <= 32; i = i + 1) begin : carry_chain
            if (i % 4 == 1) begin
                // First bit in each 4-bit block
                assign C[i] = G[i] | (P[i] & C[i-1]);
            end
            else if (i % 4 == 2) begin
                // Second bit
                assign C[i] = G[i] | (P[i] & G[i-1]) | (P[i] & P[i-1] & C[i-2]);
            end
            else if (i % 4 == 3) begin
                // Third bit
                assign C[i] = G[i] | (P[i] & G[i-1]) | (P[i] & P[i-1] & G[i-2]) | 
                            (P[i] & P[i-1] & P[i-2] & C[i-3]);
            end
            else begin
                // Fourth bit (block carry out)
                assign C[i] = G[i] | (P[i] & G[i-1]) | (P[i] & P[i-1] & G[i-2]) | 
                            (P[i] & P[i-1] & P[i-2] & G[i-3]) | 
                            (P[i] & P[i-1] & P[i-2] & P[i-3] & C[i-4]);
            end
        end
    endgenerate
    
    assign C32 = C[32];
endmodule
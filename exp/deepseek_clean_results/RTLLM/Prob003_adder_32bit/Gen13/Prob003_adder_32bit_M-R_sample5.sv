module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [32:0] G, P, C;
    
    // Generate and Propagate terms
    assign C[0] = 1'b0;
    genvar i;
    generate
        for (i = 1; i <= 32; i = i + 1) begin : cla_terms
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] ^ B[i];
        end
    endgenerate
    
    // Carry computation (parallel lookahead)
    generate
        for (i = 1; i <= 32; i = i + 1) begin : carry_lookahead
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate
    
    // Sum computation
    assign S = P[32:1] ^ C[31:0];
    assign C32 = C[32];
endmodule
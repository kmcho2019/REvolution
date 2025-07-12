module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [32:0] C;
    wire [32:1] P, G;
    
    // Generate propagate and generate signals
    genvar i;
    generate
        for (i = 1; i <= 32; i = i + 1) begin : pg_gen
            assign P[i] = A[i] ^ B[i];
            assign G[i] = A[i] & B[i];
        end
    endgenerate
    
    // Carry computation
    assign C[0] = 1'b0;
    generate
        for (i = 1; i <= 32; i = i + 1) begin : carry_gen
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate
    
    // Sum computation
    assign S = P ^ C[31:0];
    assign C32 = C[32];
endmodule
module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [32:0] C;
    wire [32:1] P, G;
    
    // Generate propagate and generate signals
    assign P = A ^ B;
    assign G = A & B;
    
    // Carry computation (parallel)
    assign C[0] = 1'b0;
    genvar i;
    generate
        for (i = 1; i <= 32; i = i + 1) begin : carry_chain
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate
    
    // Sum computation
    assign S = P ^ C[32:1];
    
    // Final carry out
    assign C32 = C[32];
endmodule
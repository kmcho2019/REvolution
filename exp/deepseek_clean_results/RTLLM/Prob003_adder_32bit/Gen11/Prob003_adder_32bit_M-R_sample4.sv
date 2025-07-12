module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [32:0] G, P, C;
    
    // Generate and Propagate signals
    assign G[32:1] = A & B;
    assign P[32:1] = A ^ B;
    
    // Carry Lookahead Logic
    assign C[0] = 1'b0;
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & C[0]);
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & C[0]);
    
    // Expanded carry equations for remaining bits
    genvar i;
    generate
        for (i = 4; i <= 32; i = i + 1) begin : carry_gen
            assign C[i] = G[i] | (P[i] & G[i-1]) | (P[i] & P[i-1] & G[i-2]) |
                         (P[i] & P[i-1] & P[i-2] & G[i-3]) | 
                         (P[i] & P[i-1] & P[i-2] & P[i-3] & C[i-4]);
        end
    endgenerate
    
    // Sum calculation
    assign S = P[32:1] ^ C[31:0];
    assign C32 = C[32];
endmodule
module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [32:0] G = {1'b0, A & B};  // Generate terms
    wire [32:0] P = {1'b0, A ^ B};  // Propagate terms
    wire [32:0] C;                  // Carry terms
    
    // Carry computation
    assign C[0] = 1'b0;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    
    // Generate remaining carries using recursive lookahead
    genvar i;
    generate
        for (i = 4; i <= 32; i = i + 1) begin : carry_gen
            assign C[i] = G[i-1] | (P[i-1] & C[i-1]);
        end
    endgenerate
    
    // Sum computation
    assign S = P[32:1] ^ C[31:0];
    assign C32 = C[32];
endmodule
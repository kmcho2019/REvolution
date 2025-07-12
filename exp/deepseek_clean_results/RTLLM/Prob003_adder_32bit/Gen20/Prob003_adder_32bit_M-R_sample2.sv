module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Generate and propagate signals for all bits
    wire [32:0] P = {1'b0, A ^ B};
    wire [32:0] G = {1'b0, A & B};
    
    // Carry computation
    wire [32:0] C;
    assign C[0] = 1'b0;  // Initial carry-in
    
    // Carry lookahead computation
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    
    // Generate remaining carries using a loop
    genvar i;
    generate
        for (i = 4; i <= 32; i = i + 1) begin : carry_gen
            assign C[i] = G[i-1] | (P[i-1] & C[i-1]);
        end
    endgenerate
    
    // Sum computation
    assign S = P[32:1] ^ C[32:1];
    assign C32 = C[32];
endmodule
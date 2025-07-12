module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Generate and propagate signals
    wire [3:0] P, G;
    assign P = x ^ y;  // Propagate
    assign G = x & y;  // Generate
    
    // Carry lookahead logic
    wire [3:0] C;
    assign C[0] = G[0] | (P[0] & 1'b0);  // No carry-in
    assign C[1] = G[1] | (P[1] & G[0]);
    assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]);
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    
    // Calculate sum bits
    assign sum[0] = P[0] ^ 1'b0;  // No carry-in
    assign sum[1] = P[1] ^ C[0];
    assign sum[2] = P[2] ^ C[1];
    assign sum[3] = P[3] ^ C[2];
    
    // Final carry-out is the overflow bit
    assign sum[4] = C[3];
endmodule
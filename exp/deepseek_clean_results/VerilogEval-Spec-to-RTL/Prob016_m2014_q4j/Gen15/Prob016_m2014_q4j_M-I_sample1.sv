module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Generate (G) and Propagate (P) signals
    wire [3:0] G = x & y;
    wire [3:0] P = x ^ y;
    
    // Carry computation (CLA logic)
    wire C1 = G[0] | (P[0] & 1'b0);
    wire C2 = G[1] | (P[1] & G[0]) | (P[1] & P[0] & 1'b0);
    wire C3 = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & 1'b0);
    wire C4 = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & 1'b0);
    
    // Sum computation
    assign sum[0] = P[0] ^ 1'b0;
    assign sum[1] = P[1] ^ C1;
    assign sum[2] = P[2] ^ C2;
    assign sum[3] = P[3] ^ C3;
    assign sum[4] = C4; // Overflow bit
endmodule
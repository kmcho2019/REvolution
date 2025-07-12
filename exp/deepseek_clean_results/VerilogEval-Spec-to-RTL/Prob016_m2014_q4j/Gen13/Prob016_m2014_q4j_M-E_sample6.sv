module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Propagate and Generate terms
    wire [3:0] P = x ^ y;
    wire [3:0] G = x & y;
    
    // Carry computation with skip logic
    wire c0 = 1'b0;  // Initial carry-in
    wire c1 = G[0] | (P[0] & c0);
    wire c2 = G[1] | (P[1] & c1);
    wire c3 = G[2] | (P[2] & c2);
    
    // Skip logic: when all P bits are 1, carry skips
    wire all_P = &P[3:0];
    wire c4_skip = all_P ? c0 : (G[3] | (P[3] & c3));
    
    // Sum computation
    assign sum[0] = P[0] ^ c0;
    assign sum[1] = P[1] ^ c1;
    assign sum[2] = P[2] ^ c2;
    assign sum[3] = P[3] ^ c3;
    assign sum[4] = c4_skip;  // Overflow bit
    
endmodule
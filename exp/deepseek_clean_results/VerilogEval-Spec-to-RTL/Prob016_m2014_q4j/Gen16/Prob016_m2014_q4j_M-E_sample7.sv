module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Propagate and Generate signals for each bit
    wire [3:0] P = x ^ y;  // Propagate
    wire [3:0] G = x & y;  // Generate
    
    // Group 0 (bits 0-1) - Ripple carry
    wire c1 = G[0] | (P[0] & 1'b0);  // Initial carry-in is 0
    wire c2 = G[1] | (P[1] & c1);
    
    // Group 1 (bits 2-3) - Skip logic
    wire group_propagate = P[2] & P[3];
    wire skip_mux = group_propagate ? c2 : 1'b0;
    
    wire c3 = G[2] | (P[2] & c2);
    wire c4 = G[3] | (P[3] & c3);
    
    // Final carry selection
    wire carry_out = group_propagate ? c2 : c4;
    
    // Sum calculation
    assign sum[0] = P[0] ^ 1'b0;
    assign sum[1] = P[1] ^ c1;
    assign sum[2] = P[2] ^ (group_propagate ? skip_mux : c2);
    assign sum[3] = P[3] ^ (group_propagate ? skip_mux : c3);
    assign sum[4] = carry_out;
endmodule
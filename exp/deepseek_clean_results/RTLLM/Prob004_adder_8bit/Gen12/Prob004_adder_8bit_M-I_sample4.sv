module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Carry lookahead signals
    wire [7:0] g; // Generate
    wire [7:0] p; // Propagate
    wire [8:0] carry;

    assign carry[0] = cin;

    // Generate and propagate signals
    assign g = a & b;
    assign p = a ^ b;

    // 4-bit lookahead carry units (2 stages)
    // First 4-bit block
    assign carry[1] = g[0] | (p[0] & carry[0]);
    assign carry[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & carry[0]);
    assign carry[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | 
                     (p[2] & p[1] & p[0] & carry[0]);
    assign carry[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) |
                     (p[3] & p[2] & p[1] & g[0]) | 
                     (p[3] & p[2] & p[1] & p[0] & carry[0]);

    // Second 4-bit block
    assign carry[5] = g[4] | (p[4] & carry[4]);
    assign carry[6] = g[5] | (p[5] & g[4]) | (p[5] & p[4] & carry[4]);
    assign carry[7] = g[6] | (p[6] & g[5]) | (p[6] & p[5] & g[4]) | 
                     (p[6] & p[5] & p[4] & carry[4]);
    assign carry[8] = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) |
                     (p[7] & p[6] & p[5] & g[4]) | 
                     (p[7] & p[6] & p[5] & p[4] & carry[4]);

    // Sum computation
    assign sum = p ^ carry[7:0];
    assign cout = carry[8];

endmodule
module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Generate Propagate and Generate signals
    wire [7:0] p = a ^ b;
    wire [7:0] g = a & b;

    // Carry lookahead logic
    wire [7:0] carry;
    assign carry[0] = cin;
    assign carry[1] = g[0] | (p[0] & carry[0]);
    assign carry[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & carry[0]);
    assign carry[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & carry[0]);
    
    // Second level lookahead
    wire block0_carry = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | 
                       (p[3] & p[2] & p[1] & p[0] & carry[0]);
    
    assign carry[4] = g[4] | (p[4] & block0_carry);
    assign carry[5] = g[5] | (p[5] & g[4]) | (p[5] & p[4] & block0_carry);
    assign carry[6] = g[6] | (p[6] & g[5]) | (p[6] & p[5] & g[4]) | (p[6] & p[5] & p[4] & block0_carry);
    
    // Final carry out
    assign cout = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | 
                 (p[7] & p[6] & p[5] & g[4]) | (p[7] & p[6] & p[5] & p[4] & block0_carry);

    // Sum generation
    assign sum = p ^ carry;

endmodule
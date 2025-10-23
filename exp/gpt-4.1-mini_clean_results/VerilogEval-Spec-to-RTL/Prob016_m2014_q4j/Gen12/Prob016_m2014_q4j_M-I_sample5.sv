module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    // Generate and Propagate signals
    wire [3:0] g = x & y;      // generate
    wire [3:0] p = x ^ y;      // propagate

    // Carry signals
    wire c1, c2, c3, c4;

    // Compute carries using carry-lookahead logic
    assign c1 = g[0] | (p[0] & 1'b0);             // c0 = 0 (no initial carry-in)
    assign c2 = g[1] | (p[1] & g[0]) | (p[1] & p[0] & 1'b0);
    assign c3 = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & 1'b0);
    assign c4 = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & 1'b0);

    // Sum bits calculation: sum[i] = p[i] ^ carry_in
    assign sum[0] = p[0] ^ 1'b0; // carry_in = 0
    assign sum[1] = p[1] ^ c1;
    assign sum[2] = p[2] ^ c2;
    assign sum[3] = p[3] ^ c3;

    // Overflow bit is final carry-out
    assign sum[4] = c4;
endmodule
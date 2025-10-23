module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    // Propagate and generate signals per bit
    wire [7:0] p = a ^ b;
    wire [7:0] g = a & b;

    // Initial carry-in is zero
    wire c0 = 1'b0;

    // Group propagate and generate signals for bits [3:0]
    wire gp0 = &p[3:0];
    wire gg0 = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);

    // Group propagate and generate signals for bits [7:4]
    wire gp1 = &p[7:4];
    wire gg1 = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | (p[7] & p[6] & p[5] & g[4]);

    // Carry into group1 (bit 4)
    wire c4 = gg0 | (gp0 & c0);

    // Carry signals within group0
    wire c1 = g[0] | (p[0] & c0);
    wire c2 = g[1] | (p[1] & c1);
    wire c3 = g[2] | (p[2] & c2);

    // Carry signals within group1
    wire c5 = g[4] | (p[4] & c4);
    wire c6 = g[5] | (p[5] & c5);
    wire c7 = g[6] | (p[6] & c6);

    // Carry-out from MSB
    wire c8 = g[7] | (p[7] & c7);

    // Sum bits calculated directly
    assign s[0] = p[0] ^ c0;
    assign s[1] = p[1] ^ c1;
    assign s[2] = p[2] ^ c2;
    assign s[3] = p[3] ^ c3;
    assign s[4] = p[4] ^ c4;
    assign s[5] = p[5] ^ c5;
    assign s[6] = p[6] ^ c6;
    assign s[7] = p[7] ^ c7;

    // Overflow detection: XOR of carry into and out of MSB
    assign overflow = c7 ^ c8;

endmodule
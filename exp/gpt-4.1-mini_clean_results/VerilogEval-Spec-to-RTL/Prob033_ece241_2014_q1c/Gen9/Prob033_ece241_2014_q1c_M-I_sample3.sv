module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [7:0] g;  // Generate signals for each bit
    wire [7:0] p;  // Propagate signals for each bit
    wire [4:0] c;  // Carry signals for block level (c[0] is initial carry-in)
    wire [3:0] c_low;  // Carry signals within low 4-bit block
    wire [3:0] c_high; // Carry signals within high 4-bit block

    // Bitwise generate and propagate
    assign g = a & b;
    assign p = a ^ b;

    // Initial carry-in
    assign c[0] = 1'b0;

    // Block generate (G) and propagate (P) for low 4 bits
    wire G0 = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    wire P0 = p[3] & p[2] & p[1] & p[0];

    // Block generate (G) and propagate (P) for high 4 bits
    wire G1 = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | (p[7] & p[6] & p[5] & g[4]);
    wire P1 = p[7] & p[6] & p[5] & p[4];

    // Compute carries at block boundaries
    // c[1] = carry into bit 4 (high block), c[0] = initial carry-in (0)
    assign c[1] = G0 | (P0 & c[0]);
    assign c[2] = G1 | (P1 & c[1]);

    // Compute carries within low 4-bit block (bits 0-3)
    assign c_low[0] = c[0];
    assign c_low[1] = g[0] | (p[0] & c_low[0]);
    assign c_low[2] = g[1] | (p[1] & c_low[1]);
    assign c_low[3] = g[2] | (p[2] & c_low[2]);

    // Compute carry into bit 3 (c_low[3]) is carry into bit 3, so next is carry into bit 4 = c[1]

    // Compute carries within high 4-bit block (bits 4-7)
    assign c_high[0] = c[1]; // carry into bit 4
    assign c_high[1] = g[4] | (p[4] & c_high[0]);
    assign c_high[2] = g[5] | (p[5] & c_high[1]);
    assign c_high[3] = g[6] | (p[6] & c_high[2]);

    // Carry out of bit 7 (MSB carry-out)
    wire c_out = g[7] | (p[7] & c_high[3]);

    // Concatenate carries for sum calculation
    wire [7:0] carry_all;
    assign carry_all = {c_out, c_high[3:1], c_low[3:1], c_low[0]};

    // Sum calculation: s = p XOR carry_in
    assign s = p ^ carry_all;

    // Overflow detection: XOR of carry into MSB (c_high[3]) and carry out (c_out)
    assign overflow = c_high[3] ^ c_out;
endmodule
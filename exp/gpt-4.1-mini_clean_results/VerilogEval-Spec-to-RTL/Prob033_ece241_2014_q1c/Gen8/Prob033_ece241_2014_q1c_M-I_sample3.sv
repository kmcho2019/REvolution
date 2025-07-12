module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [7:0] p, g;       // propagate and generate signals for bits
    wire       gp0, gg0;   // group propagate and generate for lower nibble (bits 0-3)
    wire       gp1, gg1;   // group propagate and generate for upper nibble (bits 4-7)
    wire [8:0] c;          // carry signals: c[0] = 0 initial carry-in

    assign c[0] = 1'b0;

    // Bitwise propagate and generate
    assign p = a ^ b;
    assign g = a & b;

    // Group propagate and generate for lower nibble (bits 0-3)
    assign gp0 = &p[3:0]; // AND of propagate bits 0-3
    assign gg0 = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);

    // Group propagate and generate for upper nibble (bits 4-7)
    assign gp1 = &p[7:4];
    assign gg1 = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | (p[7] & p[6] & p[5] & g[4]);

    // Carry out of group 0 (bit 4)
    assign c[4] = gg0 | (gp0 & c[0]);

    // Carry out of group 1 (bit 8)
    assign c[8] = gg1 | (gp1 & c[4]);

    // Ripple carry within lower nibble (bits 0-3)
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);

    // Ripple carry within upper nibble (bits 4-7)
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & c[5]);
    assign c[7] = g[6] | (p[6] & c[6]);

    // Sum bits: s[i] = p[i] XOR c[i]
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : sum_bits
            assign s[i] = p[i] ^ c[i];
        end
    endgenerate

    // Overflow detection: XOR of carry into and out of MSB (bit 7)
    assign overflow = c[7] ^ c[8];

endmodule
module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    wire [7:0] p;   // propagate
    wire [7:0] g;   // generate
    wire [2:0] c;   // carry for groups and final carry out

    // propagate and generate per bit
    assign p = a ^ b;
    assign g = a & b;

    // Group propagate and generate for lower 4 bits
    wire p_lo = &p[3:0];
    wire g_lo = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);

    // Group propagate and generate for upper 4 bits
    wire p_hi = &p[7:4];
    wire g_hi = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | (p[7] & p[6] & p[5] & g[4]);

    // Carry signals
    assign c[0] = 1'b0;            // carry-in to LSB is zero
    assign c[1] = g_lo | (p_lo & c[0]);          // carry-out from lower 4 bits
    assign c[2] = g_hi | (p_hi & c[1]);          // carry-out from upper 4 bits (final carry out)

    // Now compute the carry bits for each bit from the group carries:
    wire [7:0] carry;

    // Lower 4 bits carry (ripple within group since only 4 bits)
    assign carry[0] = c[0];
    assign carry[1] = g[0] | (p[0] & carry[0]);
    assign carry[2] = g[1] | (p[1] & carry[1]);
    assign carry[3] = g[2] | (p[2] & carry[2]);
    // c[1] is carry-out from bit 3, so carry[4] = c[1]
    assign carry[4] = c[1];

    // Upper 4 bits carry (ripple within group)
    assign carry[5] = g[4] | (p[4] & carry[4]);
    assign carry[6] = g[5] | (p[5] & carry[5]);
    assign carry[7] = g[6] | (p[6] & carry[6]);
    // c[2] is carry-out from bit 7 (final carry)
    assign carry[8] = c[2];

    // sum bits
    assign s = p ^ carry[7:0];

    // overflow is xor of carry-in and carry-out of MSB
    assign overflow = carry[7] ^ carry[8];

endmodule
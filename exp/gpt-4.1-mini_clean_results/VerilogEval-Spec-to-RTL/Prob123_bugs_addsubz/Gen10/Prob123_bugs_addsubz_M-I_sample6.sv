module TopModule (
    input  wire       do_sub,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output wire [7:0] out,
    output wire       result_is_zero
);

    // Conditionally invert B bits based on do_sub (for subtraction)
    wire [7:0] b_invert = b ^ {8{do_sub}};
    wire [7:0] p; // propagate signals: a ^ b_invert
    wire [7:0] g; // generate signals: a & b_invert
    wire [8:0] c; // carries: c[0] = do_sub (carry_in), c[8] unused output carry

    assign p = a ^ b_invert;
    assign g = a & b_invert;
    assign c[0] = do_sub;

    // Carry-lookahead logic:
    // Carry bit i+1 = g[i] | (p[i] & c[i])
    // We calculate carries c[1] through c[8] in parallel using CLA logic.

    // Level 1: generate group propagate and generate signals for 4-bit groups
    wire g0 = g[0] | (p[0] & c[0]);
    wire g1 = g[1] | (p[1] & g0);
    wire g2 = g[2] | (p[2] & g1);
    wire g3 = g[3] | (p[3] & g2);

    wire g4 = g[4] | (p[4] & c[4]);
    wire g5 = g[5] | (p[5] & g4);
    wire g6 = g[6] | (p[6] & g5);
    wire g7 = g[7] | (p[7] & g6);

    // Precompute c[4] from lower bits:
    // c[1] = g0
    wire c1 = g0;
    // c[2] = g1
    wire c2 = g1;
    // c[3] = g2
    wire c3 = g2;
    // c[4] = g3
    wire c4 = g3;

    // Now compute carries c[5] to c[8] using c4 as carry-in to upper nibble
    // Redefine p and g for upper nibble:
    wire pg4 = p[4];
    wire pg5 = p[5];
    wire pg6 = p[6];
    wire pg7 = p[7];
    wire gg4 = g[4];
    wire gg5 = g[5];
    wire gg6 = g[6];
    wire gg7 = g[7];

    wire c5 = gg4 | (pg4 & c4);
    wire c6 = gg5 | (pg5 & c5);
    wire c7 = gg6 | (pg6 & c6);
    wire c8 = gg7 | (pg7 & c7);

    assign c[1] = c1;
    assign c[2] = c2;
    assign c[3] = c3;
    assign c[4] = c4;
    assign c[5] = c5;
    assign c[6] = c6;
    assign c[7] = c7;
    assign c[8] = c8; // final carry out, unused

    // Sum bits: sum = p ^ carry_in
    assign out = p ^ c[7:0];

    // Zero detection using reduction NOR
    assign result_is_zero = ~|out;

endmodule
module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    wire [7:0] p; // propagate signals
    wire [7:0] g; // generate signals

    // Group propagate and generate for lower and upper 4-bit halves
    wire p_lower, g_lower;
    wire p_upper, g_upper;

    // Carry signals: c[0] = carry-in, c[8] = carry-out
    wire [8:0] c;

    assign c[0] = 1'b0; // no initial carry-in

    // Propagate and generate signals for each bit
    assign p = a ^ b;
    assign g = a & b;

    // Group propagate and generate for lower 4 bits (bits 0 to 3)
    assign p_lower = &p[3:0];                 // AND of propagate bits in lower nibble
    assign g_lower = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);

    // Group propagate and generate for upper 4 bits (bits 4 to 7)
    assign p_upper = &p[7:4];                 // AND of propagate bits in upper nibble
    assign g_upper = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | (p[7] & p[6] & p[5] & g[4]);

    // Calculate carry[4] using lower group generate and propagate with c[0]
    assign c[4] = g_lower | (p_lower & c[0]);

    // Calculate carry[8] using upper group generate and propagate with c[4]
    assign c[8] = g_upper | (p_upper & c[4]);

    // Calculate carries c[1] to c[3] in lower half sequentially
    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin : lower_carry_loop
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate

    // Calculate carries c[5] to c[7] in upper half sequentially, starting from c[4]
    generate
        for (i = 4; i < 7; i = i + 1) begin : upper_carry_loop
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate

    // Sum bits: sum = propagate XOR carry-in
    assign s = p ^ c[7:0];

    // Signed overflow: XOR of carry into MSB and carry out of MSB
    assign overflow = c[7] ^ c[8];

endmodule
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire g,    // generate
    output wire p,    // propagate
    output wire cout  // carry out
);
    // generate and propagate signals
    assign g = a & b;
    assign p = a ^ b;
    // sum = p XOR cin
    assign sum = p ^ cin;
    // carry out: carry generate or propagate with carry in
    assign cout = g | (p & cin);
endmodule

module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [7:0] g;       // generate signals per bit
    wire [7:0] p;       // propagate signals per bit
    wire [8:0] c;       // carry signals for bits 0 to 8
    // Group generates and propagates (2 groups: bits 3:0 and 7:4)
    wire GG0, GG1;      // group generates
    wire PG0, PG1;      // group propagates

    assign c[0] = cin;

    // Instantiate bit-level full adders to get g, p and cout per bit
    // cout here is not used as final carry-out from bit (we compute carry externally)
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_bitfa
            bit_full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(c[i]),
                .sum(sum[i]),
                .g(g[i]),
                .p(p[i]),
                .cout()  // unused here because we manually compute carries
            );
        end
    endgenerate

    // Compute group propagate and generate for lower 4 bits (bits 3..0)
    assign PG0 = p[0] & p[1] & p[2] & p[3];
    assign GG0 = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);

    // Compute group propagate and generate for upper 4 bits (bits 7..4)
    assign PG1 = p[4] & p[5] & p[6] & p[7];
    assign GG1 = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | (p[7] & p[6] & p[5] & g[4]);

    // Compute carries at group boundaries using carry lookahead
    // c[4]: carry into bit 4 (upper block)
    assign c[4] = GG0 | (PG0 & c[0]);
    // c[8]: carry out of MSB (final cout)
    assign c[8] = GG1 | (PG1 & c[4]);

    // Compute carries inside lower group bits 1..3
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);

    // Compute carries inside upper group bits 5..7
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & c[5]);
    assign c[7] = g[6] | (p[6] & c[6]);

    assign cout = c[8];

endmodule
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire p,    // propagate = a ^ b
    output wire g     // generate  = a & b
);
    assign sum = a ^ b ^ cin;
    assign p   = a ^ b;
    assign g   = a & b;
endmodule

// 4-bit carry lookahead logic: calculates carry outputs c[1:4] from generate and propagate signals and carry-in c0
module cla_4bit (
    input  wire [3:0] p,    // propagate signals per bit
    input  wire [3:0] g,    // generate signals per bit
    input  wire       c0,   // input carry
    output wire [4:1] c     // carries for bits 1 to 4
);
    // Carry lookahead equations:
    // c1 = g0 | (p0 & c0)
    // c2 = g1 | (p1 & g0) | (p1 & p0 & c0)
    // c3 = g2 | (p2 & g1) | (p2 & p1 & g0) | (p2 & p1 & p0 & c0)
    // c4 = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0) | (p3 & p2 & p1 & p0 & c0)

    assign c[1] = g[0] | (p[0] & c0);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c0);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c0);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c0);
endmodule

module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    // Internal propagate and generate signals for each bit
    wire [7:0] p, g;

    // Instantiate bit full adders to generate sum partial (without carry-in) and propagate/generate signals
    // We'll calculate sum later once carries are computed

    bit_full_adder bfa0 (.a(a[0]), .b(b[0]), .cin(1'b0), .sum(), .p(p[0]), .g(g[0]));
    bit_full_adder bfa1 (.a(a[1]), .b(b[1]), .cin(1'b0), .sum(), .p(p[1]), .g(g[1]));
    bit_full_adder bfa2 (.a(a[2]), .b(b[2]), .cin(1'b0), .sum(), .p(p[2]), .g(g[2]));
    bit_full_adder bfa3 (.a(a[3]), .b(b[3]), .cin(1'b0), .sum(), .p(p[3]), .g(g[3]));
    bit_full_adder bfa4 (.a(a[4]), .b(b[4]), .cin(1'b0), .sum(), .p(p[4]), .g(g[4]));
    bit_full_adder bfa5 (.a(a[5]), .b(b[5]), .cin(1'b0), .sum(), .p(p[5]), .g(g[5]));
    bit_full_adder bfa6 (.a(a[6]), .b(b[6]), .cin(1'b0), .sum(), .p(p[6]), .g(g[6]));
    bit_full_adder bfa7 (.a(a[7]), .b(b[7]), .cin(1'b0), .sum(), .p(p[7]), .g(g[7]));

    // Carry outputs of lower and upper 4-bit blocks
    wire c4;      // carry into upper 4 bits
    wire c;       // final carry out

    // First 4-bit CLA block carry outputs: c1,c2,c3,c4
    wire [4:1] c_first4;
    cla_4bit cla0 (
        .p(p[3:0]),
        .g(g[3:0]),
        .c0(cin),
        .c(c_first4)
    );

    // Calculate carry-in for upper 4-bit block = c4 = carry out of bit 3
    assign c4 = c_first4[4];

    // Second 4-bit CLA block carry outputs: c5,c6,c7,cout
    wire [4:1] c_second4;
    cla_4bit cla1 (
        .p(p[7:4]),
        .g(g[7:4]),
        .c0(c4),
        .c(c_second4)
    );

    assign cout = c_second4[4];

    // Now calculate each bit sum using bit-level full adder formula: sum = p ^ carry_in
    assign sum[0] = p[0] ^ cin;
    assign sum[1] = p[1] ^ c_first4[1];
    assign sum[2] = p[2] ^ c_first4[2];
    assign sum[3] = p[3] ^ c_first4[3];
    assign sum[4] = p[4] ^ c_second4[1];
    assign sum[5] = p[5] ^ c_second4[2];
    assign sum[6] = p[6] ^ c_second4[3];
    assign sum[7] = p[7] ^ c_second4[4];

endmodule
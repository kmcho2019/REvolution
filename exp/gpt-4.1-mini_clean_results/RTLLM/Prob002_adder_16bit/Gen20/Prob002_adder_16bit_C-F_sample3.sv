module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire [7:0] p, g;     // propagate and generate signals
    wire [3:0] G_group;  // group generates
    wire [3:0] P_group;  // group propagates
    wire [4:0] c;        // carry signals: c[0] = Cin, c[8] = Cout

    // Compute bitwise propagate and generate
    assign p = a ^ b;
    assign g = a & b;

    // Group propagate and generate signals for 4 groups of 2 bits each
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : group_pg
            // For bits 2*i and 2*i+1:
            wire p0 = p[2*i];
            wire p1 = p[2*i+1];
            wire g0 = g[2*i];
            wire g1 = g[2*i+1];
            // Group propagate: both bits must propagate
            assign P_group[i] = p1 & p0;
            // Group generate: bit 1 generates or bit 0 generates and bit 1 propagates
            assign G_group[i] = g1 | (p1 & g0);
        end
    endgenerate

    // Carry lookahead logic for group-level carries
    // c[0] is input carry
    assign c[0] = Cin;

    // First level: carry into each group
    // c[1] = carry into group 0 (bits 1:0)
    assign c[1] = G_group[0] | (P_group[0] & c[0]);
    // c[2] = carry into group 1 (bits 3:2)
    assign c[2] = G_group[1] | (P_group[1] & c[1]);
    // c[3] = carry into group 2 (bits 5:4)
    assign c[3] = G_group[2] | (P_group[2] & c[2]);
    // c[4] = carry into group 3 (bits 7:6)
    assign c[4] = G_group[3] | (P_group[3] & c[3]);

    // Now generate carry for each bit inside groups using ripple carry, since only 2 bits per group:
    // For each group i:
    // bit 2*i carry in: c[2*i]
    // bit 2*i+1 carry in: c[2*i+1]

    // calculate c[2*i+1] = g[2*i] | (p[2*i] & c[2*i])
    wire [7:0] c_bit; // carry-in to bits 1..7; c_bit[0] is carry-in to bit 0 (c[0])
    assign c_bit[0] = c[0]; // carry-in to bit 0

    generate
        for (i=0; i<4; i=i+1) begin : bit_carries
            // carry into bit 2*i+1
            assign c_bit[2*i+1] = g[2*i] | (p[2*i] & c_bit[2*i]);
            // carry into bit 2*i+2 is c[i+1] = carry into next group or c[4] for last
            // But c[i+1] already assigned as c[1], c[2], c[3], c[4], so for bits 2*i+2 carry, use c[i+1] when i<3
            // For last bit 7 (i=3, bit 8 doesn't exist)
        end
    endgenerate

    // Now assign sum bits y[i] = p[i] ^ carry_in[i]
    assign y[0] = p[0] ^ c_bit[0];
    assign y[1] = p[1] ^ c_bit[1];
    assign y[2] = p[2] ^ c[1];
    assign y[3] = p[3] ^ c[1+ (3>0 ? 1 : 0)]; // careful with indexing, better just assign bitwise below

    // To avoid confusion, explicitly assign carries for each bit:

    // carry into bit 0 = c[0] = Cin
    // carry into bit 1 = c_bit[1] = g[0] | (p[0] & c[0])
    // carry into bit 2 = c[1] (carry into group 1)
    // carry into bit 3 = g[2] | (p[2] & c[1])
    // carry into bit 4 = c[2] (carry into group 2)
    // carry into bit 5 = g[4] | (p[4] & c[2])
    // carry into bit 6 = c[3] (carry into group 3)
    // carry into bit 7 = g[6] | (p[6] & c[3])

    wire c2_bit3, c2_bit5, c2_bit7;
    assign c2_bit3 = g[3] | (p[3] & c[1]);
    assign c2_bit5 = g[5] | (p[5] & c[2]);
    assign c2_bit7 = g[7] | (p[7] & c[3]);

    assign y[0] = p[0] ^ c[0];
    assign y[1] = p[1] ^ c_bit[1];
    assign y[2] = p[2] ^ c[1];
    assign y[3] = p[3] ^ c2_bit3;
    assign y[4] = p[4] ^ c[2];
    assign y[5] = p[5] ^ c2_bit5;
    assign y[6] = p[6] ^ c[3];
    assign y[7] = p[7] ^ c2_bit7;

    // Final carry-out from bit 7:
    assign Co = g[7] | (p[7] & c[3]);
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_mid;

    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_mid)
    );

    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule
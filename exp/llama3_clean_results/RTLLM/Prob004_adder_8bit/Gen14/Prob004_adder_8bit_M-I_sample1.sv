module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Internal signals for carry lookahead within 4-bit segments
wire [3:0] g1, p1; // Generate and propagate signals for lower 4 bits
wire [3:0] g2, p2; // Generate and propagate signals for upper 4 bits
wire [3:0] c1; // Carry signals for lower 4 bits
wire [3:0] c2; // Carry signals for upper 4 bits

// Generate and propagate signals for lower 4 bits
assign g1[0] = a[0] & b[0];
assign p1[0] = a[0] | b[0];
assign g1[1] = a[1] & b[1];
assign p1[1] = a[1] | b[1];
assign g1[2] = a[2] & b[2];
assign p1[2] = a[2] | b[2];
assign g1[3] = a[3] & b[3];
assign p1[3] = a[3] | b[3];

// Generate and propagate signals for upper 4 bits
assign g2[0] = a[4] & b[4];
assign p2[0] = a[4] | b[4];
assign g2[1] = a[5] & b[5];
assign p2[1] = a[5] | b[5];
assign g2[2] = a[6] & b[6];
assign p2[2] = a[6] | b[6];
assign g2[3] = a[7] & b[7];
assign p2[3] = a[7] | b[7];

// Carry signals for lower 4 bits using lookahead logic
assign c1[0] = g1[0] | (p1[0] & cin);
assign c1[1] = g1[1] | (p1[1] & c1[0]);
assign c1[2] = g1[2] | (p1[2] & c1[1]);
assign c1[3] = g1[3] | (p1[3] & c1[2]);

// Carry signals for upper 4 bits using lookahead logic
assign c2[0] = g2[0] | (p2[0] & c1[3]);
assign c2[1] = g2[1] | (p2[1] & c2[0]);
assign c2[2] = g2[2] | (p2[2] & c2[1]);
assign c2[3] = g2[3] | (p2[3] & c2[2]);

// Sum signals using half adders and full adders
assign sum[0] = a[0] ^ b[0] ^ cin;
assign sum[1] = a[1] ^ b[1] ^ c1[0];
assign sum[2] = a[2] ^ b[2] ^ c1[1];
assign sum[3] = a[3] ^ b[3] ^ c1[2];
assign sum[4] = a[4] ^ b[4] ^ c1[3];
assign sum[5] = a[5] ^ b[5] ^ c2[0];
assign sum[6] = a[6] ^ b[6] ^ c2[1];
assign sum[7] = a[7] ^ b[7] ^ c2[2];

// Carry out
assign cout = g2[3] | (p2[3] & c2[2]);

endmodule
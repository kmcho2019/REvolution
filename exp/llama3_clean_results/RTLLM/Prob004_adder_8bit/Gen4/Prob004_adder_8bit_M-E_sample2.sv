module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Internal signals for carry lookahead
wire c0, c1, c2, c3, c4, c5, c6, c7;
wire g0, g1, g2, g3, g4, g5, g6, g7; // Generate signals
wire p0, p1, p2, p3, p4, p5, p6, p7; // Propagate signals

// First bit
assign sum[0] = a[0] ^ b[0] ^ cin;
assign g0 = a[0] & b[0];
assign p0 = a[0] | b[0];
assign c0 = g0 | (p0 & cin);

// Subsequent bits
assign sum[1] = a[1] ^ b[1] ^ c0;
assign g1 = a[1] & b[1];
assign p1 = a[1] | b[1];
assign c1 = g1 | (p1 & c0);

assign sum[2] = a[2] ^ b[2] ^ c1;
assign g2 = a[2] & b[2];
assign p2 = a[2] | b[2];
assign c2 = g2 | (p2 & c1);

assign sum[3] = a[3] ^ b[3] ^ c2;
assign g3 = a[3] & b[3];
assign p3 = a[3] | b[3];
assign c3 = g3 | (p3 & c2);

assign sum[4] = a[4] ^ b[4] ^ c3;
assign g4 = a[4] & b[4];
assign p4 = a[4] | b[4];
assign c4 = g4 | (p4 & c3);

assign sum[5] = a[5] ^ b[5] ^ c4;
assign g5 = a[5] & b[5];
assign p5 = a[5] | b[5];
assign c5 = g5 | (p5 & c4);

assign sum[6] = a[6] ^ b[6] ^ c5;
assign g6 = a[6] & b[6];
assign p6 = a[6] | b[6];
assign c6 = g6 | (p6 & c5);

assign sum[7] = a[7] ^ b[7] ^ c6;
assign g7 = a[7] & b[7];
assign p7 = a[7] | b[7];
assign cout = g7 | (p7 & c6);

endmodule
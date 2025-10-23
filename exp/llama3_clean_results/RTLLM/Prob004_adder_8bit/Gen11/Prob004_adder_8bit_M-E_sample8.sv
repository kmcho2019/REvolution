module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Stage 1: Calculate generate and propagate signals
wire [7:0] g, p;
assign g[0] = a[0] & b[0];
assign p[0] = a[0] | b[0];
assign g[1] = a[1] & b[1];
assign p[1] = a[1] | b[1];
assign g[2] = a[2] & b[2];
assign p[2] = a[2] | b[2];
assign g[3] = a[3] & b[3];
assign p[3] = a[3] | b[3];
assign g[4] = a[4] & b[4];
assign p[4] = a[4] | b[4];
assign g[5] = a[5] & b[5];
assign p[5] = a[5] | b[5];
assign g[6] = a[6] & b[6];
assign p[6] = a[6] | b[6];
assign g[7] = a[7] & b[7];
assign p[7] = a[7] | b[7];

// Stage 2: Calculate carry signals
wire c0, c1, c2, c3, c4, c5, c6, c7;
assign c0 = g[0] | (p[0] & cin);
assign c1 = g[1] | (p[1] & c0);
assign c2 = g[2] | (p[2] & c1);
assign c3 = g[3] | (p[3] & c2);
assign c4 = g[4] | (p[4] & c3);
assign c5 = g[5] | (p[5] & c4);
assign c6 = g[6] | (p[6] & c5);
assign c7 = g[7] | (p[7] & c6);

// Stage 3: Calculate sum signals
assign sum[0] = a[0] ^ b[0] ^ cin;
assign sum[1] = a[1] ^ b[1] ^ c0;
assign sum[2] = a[2] ^ b[2] ^ c1;
assign sum[3] = a[3] ^ b[3] ^ c2;
assign sum[4] = a[4] ^ b[4] ^ c3;
assign sum[5] = a[5] ^ b[5] ^ c4;
assign sum[6] = a[6] ^ b[6] ^ c5;
assign sum[7] = a[7] ^ b[7] ^ c6;

// Calculate cout
assign cout = c7;

endmodule
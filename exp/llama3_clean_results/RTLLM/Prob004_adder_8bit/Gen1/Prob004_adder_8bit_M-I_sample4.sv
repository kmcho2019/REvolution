module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Internal signals for carry lookahead
wire [7:0] p, g;
wire [7:0] c;

// Generate p and g signals
assign p[0] = a[0] ^ b[0];
assign g[0] = a[0] & b[0];
assign c[0] = cin;

// Generate carry signals using carry lookahead
assign c[1] = g[0] | (p[0] & c[0]);
assign p[1] = a[1] ^ b[1];
assign g[1] = a[1] & b[1];

assign c[2] = g[1] | (p[1] & c[1]);
assign p[2] = a[2] ^ b[2];
assign g[2] = a[2] & b[2];

assign c[3] = g[2] | (p[2] & c[2]);
assign p[3] = a[3] ^ b[3];
assign g[3] = a[3] & b[3];

assign c[4] = g[3] | (p[3] & c[3]);
assign p[4] = a[4] ^ b[4];
assign g[4] = a[4] & b[4];

assign c[5] = g[4] | (p[4] & c[4]);
assign p[5] = a[5] ^ b[5];
assign g[5] = a[5] & b[5];

assign c[6] = g[5] | (p[5] & c[5]);
assign p[6] = a[6] ^ b[6];
assign g[6] = a[6] & b[6];

assign c[7] = g[6] | (p[6] & c[6]);

// Generate sum signals
assign sum[0] = p[0] ^ c[0];
assign sum[1] = p[1] ^ c[1];
assign sum[2] = p[2] ^ c[2];
assign sum[3] = p[3] ^ c[3];
assign sum[4] = p[4] ^ c[4];
assign sum[5] = p[5] ^ c[5];
assign sum[6] = p[6] ^ c[6];
assign sum[7] = a[7] ^ b[7] ^ c[7];

// Generate final carry out
assign cout = c[7];

endmodule
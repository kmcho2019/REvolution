module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Internal signals for carry lookahead in the first level 4-bit adders
wire [3:0] sum_lo, sum_hi;
wire c_lo, c_hi;
wire g0, g1, g2, g3, g4, g5, g6, g7; // Generate signals
wire p0, p1, p2, p3, p4, p5, p6, p7; // Propagate signals

// First level: Two parallel 4-bit adders with carry lookahead
// Lower 4-bit adder
assign sum_lo[0] = a[0] ^ b[0] ^ cin;
assign g0 = a[0] & b[0];
assign p0 = a[0] | b[0];
assign c_lo = g0 | (p0 & cin);

assign sum_lo[1] = a[1] ^ b[1] ^ c_lo;
assign g1 = a[1] & b[1];
assign p1 = a[1] | b[1];
assign c_lo = g1 | (p1 & c_lo);

assign sum_lo[2] = a[2] ^ b[2] ^ c_lo;
assign g2 = a[2] & b[2];
assign p2 = a[2] | b[2];
assign c_lo = g2 | (p2 & c_lo);

assign sum_lo[3] = a[3] ^ b[3] ^ c_lo;
assign g3 = a[3] & b[3];
assign p3 = a[3] | b[3];
assign c_lo = g3 | (p3 & c_lo);

// Upper 4-bit adder with input carry from lower 4-bit adder
assign sum_hi[0] = a[4] ^ b[4] ^ c_lo;
assign g4 = a[4] & b[4];
assign p4 = a[4] | b[4];
assign c_hi = g4 | (p4 & c_lo);

assign sum_hi[1] = a[5] ^ b[5] ^ c_hi;
assign g5 = a[5] & b[5];
assign p5 = a[5] | b[5];
assign c_hi = g5 | (p5 & c_hi);

assign sum_hi[2] = a[6] ^ b[6] ^ c_hi;
assign g6 = a[6] & b[6];
assign p6 = a[6] | b[6];
assign c_hi = g6 | (p6 & c_hi);

assign sum_hi[3] = a[7] ^ b[7] ^ c_hi;
assign g7 = a[7] & b[7];
assign p7 = a[7] | b[7];
assign cout = g7 | (p7 & c_hi);

// Combine the sums
assign sum[3:0] = sum_lo;
assign sum[7:4] = sum_hi;

endmodule
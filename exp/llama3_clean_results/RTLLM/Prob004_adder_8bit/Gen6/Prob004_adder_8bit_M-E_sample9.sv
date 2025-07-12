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

// First level: Two parallel 4-bit adders with carry lookahead
// Lower 4-bit adder
assign sum_lo[0] = a[0] ^ b[0] ^ cin;
assign sum_lo[1] = a[1] ^ b[1] ^ (a[0] & b[0] | (a[0] | b[0]) & cin);
assign sum_lo[2] = a[2] ^ b[2] ^ (a[1] & b[1] | (a[1] | b[1]) & (a[0] & b[0] | (a[0] | b[0]) & cin));
assign sum_lo[3] = a[3] ^ b[3] ^ (a[2] & b[2] | (a[2] | b[2]) & (a[1] & b[1] | (a[1] | b[1]) & (a[0] & b[0] | (a[0] | b[0]) & cin)));
assign c_lo = (a[3] & b[3]) | (a[3] | b[3]) & (a[2] & b[2] | (a[2] | b[2]) & (a[1] & b[1] | (a[1] | b[1]) & (a[0] & b[0] | (a[0] | b[0]) & cin)));

// Upper 4-bit adder
assign sum_hi[0] = a[4] ^ b[4] ^ c_lo;
assign sum_hi[1] = a[5] ^ b[5] ^ (a[4] & b[4] | (a[4] | b[4]) & c_lo);
assign sum_hi[2] = a[6] ^ b[6] ^ (a[5] & b[5] | (a[5] | b[5]) & (a[4] & b[4] | (a[4] | b[4]) & c_lo));
assign sum_hi[3] = a[7] ^ b[7] ^ (a[6] & b[6] | (a[6] | b[6]) & (a[5] & b[5] | (a[5] | b[5]) & (a[4] & b[4] | (a[4] | b[4]) & c_lo)));
assign c_hi = (a[7] & b[7]) | (a[7] | b[7]) & (a[6] & b[6] | (a[6] | b[6]) & (a[5] & b[5] | (a[5] | b[5]) & (a[4] & b[4] | (a[4] | b[4]) & c_lo)));

// Combine the sums and propagate the carry
assign sum[3:0] = sum_lo;
assign sum[7:4] = sum_hi;
assign cout = c_hi;

endmodule
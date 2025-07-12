module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Internal signals for carry propagation
wire c0, c1, c2, c3, c4, c5, c6, c7;
wire [3:0] sum_lo;
wire [3:0] sum_hi;

// Lower 4-bit adder
assign sum_lo[0] = a[0] ^ b[0] ^ cin;
assign c0 = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);
assign sum_lo[1] = a[1] ^ b[1] ^ c0;
assign c1 = (a[1] & b[1]) | (a[1] & c0) | (b[1] & c0);
assign sum_lo[2] = a[2] ^ b[2] ^ c1;
assign c2 = (a[2] & b[2]) | (a[2] & c1) | (b[2] & c1);
assign sum_lo[3] = a[3] ^ b[3] ^ c2;
assign c3 = (a[3] & b[3]) | (a[3] & c2) | (b[3] & c2);

// Upper 4-bit adder
assign sum_hi[0] = a[4] ^ b[4] ^ c3;
assign c4 = (a[4] & b[4]) | (a[4] & c3) | (b[4] & c3);
assign sum_hi[1] = a[5] ^ b[5] ^ c4;
assign c5 = (a[5] & b[5]) | (a[5] & c4) | (b[5] & c4);
assign sum_hi[2] = a[6] ^ b[6] ^ c5;
assign c6 = (a[6] & b[6]) | (a[6] & c5) | (b[6] & c5);
assign sum_hi[3] = a[7] ^ b[7] ^ c6;
assign c7 = (a[7] & b[7]) | (a[7] & c6) | (b[7] & c6);

// Combine the sums and propagate the carry
assign sum[3:0] = sum_lo;
assign sum[7:4] = sum_hi;
assign cout = c7;

endmodule
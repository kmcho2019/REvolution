module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

wire c0, c1, c2, c3, c4, c5, c6, c7;

// Full adder for bit 0
assign sum[0] = a[0] ^ b[0] ^ cin;
assign c0 = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);

// Full adder for bit 1
assign sum[1] = a[1] ^ b[1] ^ c0;
assign c1 = (a[1] & b[1]) | (a[1] & c0) | (b[1] & c0);

// Full adder for bit 2
assign sum[2] = a[2] ^ b[2] ^ c1;
assign c2 = (a[2] & b[2]) | (a[2] & c1) | (b[2] & c1);

// Full adder for bit 3
assign sum[3] = a[3] ^ b[3] ^ c2;
assign c3 = (a[3] & b[3]) | (a[3] & c2) | (b[3] & c2);

// Full adder for bit 4
assign sum[4] = a[4] ^ b[4] ^ c3;
assign c4 = (a[4] & b[4]) | (a[4] & c3) | (b[4] & c3);

// Full adder for bit 5
assign sum[5] = a[5] ^ b[5] ^ c4;
assign c5 = (a[5] & b[5]) | (a[5] & c4) | (b[5] & c4);

// Full adder for bit 6
assign sum[6] = a[6] ^ b[6] ^ c5;
assign c6 = (a[6] & b[6]) | (a[6] & c5) | (b[6] & c5);

// Full adder for bit 7
assign sum[7] = a[7] ^ b[7] ^ c6;
assign cout = (a[7] & b[7]) | (a[7] & c6) | (b[7] & c6);

endmodule
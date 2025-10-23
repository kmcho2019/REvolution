module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

wire [7:0] c;

assign sum[0] = a[0] ^ b[0] ^ cin;
assign c[0]   = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);

assign sum[1] = a[1] ^ b[1] ^ c[0];
assign c[1]   = (a[1] & b[1]) | (a[1] & c[0]) | (b[1] & c[0]);

assign sum[2] = a[2] ^ b[2] ^ c[1];
assign c[2]   = (a[2] & b[2]) | (a[2] & c[1]) | (b[2] & c[1]);

assign sum[3] = a[3] ^ b[3] ^ c[2];
assign c[3]   = (a[3] & b[3]) | (a[3] & c[2]) | (b[3] & c[2]);

assign sum[4] = a[4] ^ b[4] ^ c[3];
assign c[4]   = (a[4] & b[4]) | (a[4] & c[3]) | (b[4] & c[3]);

assign sum[5] = a[5] ^ b[5] ^ c[4];
assign c[5]   = (a[5] & b[5]) | (a[5] & c[4]) | (b[5] & c[4]);

assign sum[6] = a[6] ^ b[6] ^ c[5];
assign c[6]   = (a[6] & b[6]) | (a[6] & c[5]) | (b[6] & c[5]);

assign sum[7] = a[7] ^ b[7] ^ c[6];
assign cout   = (a[7] & b[7]) | (a[7] & c[6]) | (b[7] & c[6]);

endmodule
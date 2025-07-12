module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Directly calculate sum using XOR operation
assign sum[0] = a[0] ^ b[0] ^ cin;
assign sum[1] = a[1] ^ b[1] ^ (a[0] & b[0] | (a[0] ^ b[0]) & cin);
assign sum[2] = a[2] ^ b[2] ^ (a[1] & b[1] | (a[1] ^ b[1]) & (a[0] & b[0] | (a[0] ^ b[0]) & cin));
assign sum[3] = a[3] ^ b[3] ^ (a[2] & b[2] | (a[2] ^ b[2]) & (a[1] & b[1] | (a[1] ^ b[1]) & (a[0] & b[0] | (a[0] ^ b[0]) & cin)));
assign sum[4] = a[4] ^ b[4] ^ (a[3] & b[3] | (a[3] ^ b[3]) & (a[2] & b[2] | (a[2] ^ b[2]) & (a[1] & b[1] | (a[1] ^ b[1]) & (a[0] & b[0] | (a[0] ^ b[0]) & cin))));
assign sum[5] = a[5] ^ b[5] ^ (a[4] & b[4] | (a[4] ^ b[4]) & (a[3] & b[3] | (a[3] ^ b[3]) & (a[2] & b[2] | (a[2] ^ b[2]) & (a[1] & b[1] | (a[1] ^ b[1]) & (a[0] & b[0] | (a[0] ^ b[0]) & cin)))));
assign sum[6] = a[6] ^ b[6] ^ (a[5] & b[5] | (a[5] ^ b[5]) & (a[4] & b[4] | (a[4] ^ b[4]) & (a[3] & b[3] | (a[3] ^ b[3]) & (a[2] & b[2] | (a[2] ^ b[2]) & (a[1] & b[1] | (a[1] ^ b[1]) & (a[0] & b[0] | (a[0] ^ b[0]) & cin))))))
);
assign sum[7] = a[7] ^ b[7] ^ (a[6] & b[6] | (a[6] ^ b[6]) & (a[5] & b[5] | (a[5] ^ b[5]) & (a[4] & b[4] | (a[4] ^ b[4]) & (a[3] & b[3] | (a[3] ^ b[3]) & (a[2] & b[2] | (a[2] ^ b[2]) & (a[1] & b[1] | (a[1] ^ b[1]) & (a[0] & b[0] | (a[0] ^ b[0]) & cin)))))));

// Calculate carry-out
assign cout = (a[7] & b[7]) | ((a[7] ^ b[7]) & (a[6] & b[6] | (a[6] ^ b[6]) & (a[5] & b[5] | (a[5] ^ b[5]) & (a[4] & b[4] | (a[4] ^ b[4]) & (a[3] & b[3] | (a[3] ^ b[3]) & (a[2] & b[2] | (a[2] ^ b[2]) & (a[1] & b[1] | (a[1] ^ b[1]) & (a[0] & b[0] | (a[0] ^ b[0]) & cin)))))));

endmodule
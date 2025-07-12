module TopModule (
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

// Perform 4-bit addition using full adders
wire c0, c1, c2;
assign sum[0] = x[0] ^ y[0] ^ c0;
assign sum[1] = x[1] ^ y[1] ^ c1;
assign sum[2] = x[2] ^ y[2] ^ c2;
assign sum[3] = x[3] ^ y[3] ^ sum[2];

// Calculate carry bits
assign c0 = x[0] & y[0];
assign c1 = (x[1] & y[1]) | (x[1] & c0) | (y[1] & c0);
assign c2 = (x[2] & y[2]) | (x[2] & c1) | (y[2] & c1);
assign sum[4] = (x[3] & y[3]) | (x[3] & sum[2]) | (y[3] & sum[2]);

endmodule
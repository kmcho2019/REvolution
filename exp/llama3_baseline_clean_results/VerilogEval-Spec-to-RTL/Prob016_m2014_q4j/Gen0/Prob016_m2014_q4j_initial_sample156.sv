module TopModule (
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

// Internal carry signals
wire c1, c2, c3;

// Full adder 1 (bit 0)
assign sum[0] = x[0] ^ y[0] ^ 0; // sum output
assign c1 = x[0] & y[0] | x[0] & 0 | y[0] & 0; // carry output

// Full adder 2 (bit 1)
assign sum[1] = x[1] ^ y[1] ^ c1; // sum output
assign c2 = x[1] & y[1] | x[1] & c1 | y[1] & c1; // carry output

// Full adder 3 (bit 2)
assign sum[2] = x[2] ^ y[2] ^ c2; // sum output
assign c3 = x[2] & y[2] | x[2] & c2 | y[2] & c2; // carry output

// Full adder 4 (bit 3)
assign sum[3] = x[3] ^ y[3] ^ c3; // sum output
assign sum[4] = x[3] & y[3] | x[3] & c3 | y[3] & c3; // overflow bit

endmodule
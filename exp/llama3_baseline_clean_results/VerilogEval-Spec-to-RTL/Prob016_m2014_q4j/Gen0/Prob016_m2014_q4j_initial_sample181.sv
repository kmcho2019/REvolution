module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

// Define the internal wires
wire c0, c1, c2, c3;

// The first full adder
assign sum[0] = x[0] ^ y[0] ^ c0;
assign c1 = (x[0] & y[0]) | (x[0] & c0) | (y[0] & c0);

// The second full adder
assign sum[1] = x[1] ^ y[1] ^ c1;
assign c2 = (x[1] & y[1]) | (x[1] & c1) | (y[1] & c1);

// The third full adder
assign sum[2] = x[2] ^ y[2] ^ c2;
assign c3 = (x[2] & y[2]) | (x[2] & c2) | (y[2] & c2);

// The fourth full adder
assign sum[3] = x[3] ^ y[3] ^ c3;
assign sum[4] = c3;

// The initial carry is 0
assign c0 = 0;

endmodule
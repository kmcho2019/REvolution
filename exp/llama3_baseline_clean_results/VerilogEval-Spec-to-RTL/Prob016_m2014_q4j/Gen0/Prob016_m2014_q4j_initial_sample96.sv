module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

// Internal wires for the carry signals
wire c1, c2, c3;

// Full adder 0 (least significant bit)
full_adder fa0(x[0], y[0], 1'b0, sum[0], c1);

// Full adder 1
full_adder fa1(x[1], y[1], c1, sum[1], c2);

// Full adder 2
full_adder fa2(x[2], y[2], c2, sum[2], c3);

// Full adder 3 (most significant bit)
full_adder fa3(x[3], y[3], c3, sum[3], sum[4]);

endmodule

// Define a full adder module
module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

// Sum calculation
assign sum = a ^ b ^ cin;

// Carry calculation
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule
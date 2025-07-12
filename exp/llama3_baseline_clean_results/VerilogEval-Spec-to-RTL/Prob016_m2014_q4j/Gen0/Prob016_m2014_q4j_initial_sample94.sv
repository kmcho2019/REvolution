module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

// Define the internal signals for the full adders
wire c1, c2, c3, sum0, sum1, sum2, sum3;

// First full adder
full_adder fa0(x[0], y[0], 1'b0, sum0, c1);

// Second full adder
full_adder fa1(x[1], y[1], c1, sum1, c2);

// Third full adder
full_adder fa2(x[2], y[2], c2, sum2, c3);

// Fourth full adder
full_adder fa3(x[3], y[3], c3, sum3, sum[4]);

// Assign the sum bits
assign sum[0] = sum0;
assign sum[1] = sum1;
assign sum[2] = sum2;
assign sum[3] = sum3;

endmodule

// Full adder module
module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule
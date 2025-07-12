module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);

wire carry1, carry2, carry3;

// Instantiate the first full adder
full_adder fa1(x[0], y[0], 1'b0, sum[0], carry1);

// Instantiate the second full adder
full_adder fa2(x[1], y[1], carry1, sum[1], carry2);

// Instantiate the third full adder
full_adder fa3(x[2], y[2], carry2, sum[2], carry3);

// Instantiate the fourth full adder
full_adder fa4(x[3], y[3], carry3, sum[3], sum[4]);

endmodule

// Define the full adder module
module full_adder(
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);

assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule
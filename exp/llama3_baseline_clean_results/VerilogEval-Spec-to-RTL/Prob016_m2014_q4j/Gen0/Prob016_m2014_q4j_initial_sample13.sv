module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

wire c1, c2, c3;

// First full adder
full_adder fa1(x[0], y[0], 1'b0, sum[0], c1);

// Second full adder
full_adder fa2(x[1], y[1], c1, sum[1], c2);

// Third full adder
full_adder fa3(x[2], y[2], c2, sum[2], c3);

// Fourth full adder
full_adder fa4(x[3], y[3], c3, sum[3], sum[4]);

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
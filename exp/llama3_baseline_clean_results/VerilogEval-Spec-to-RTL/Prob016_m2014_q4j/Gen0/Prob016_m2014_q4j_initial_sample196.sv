module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

// Full adder module
module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Instantiate full adders for each bit position
wire [2:0] carry;
FullAdder fa0(x[0], y[0], 1'b0, sum[0], carry[0]);
FullAdder fa1(x[1], y[1], carry[0], sum[1], carry[1]);
FullAdder fa2(x[2], y[2], carry[1], sum[2], carry[2]);
FullAdder fa3(x[3], y[3], carry[2], sum[3], sum[4]);

endmodule
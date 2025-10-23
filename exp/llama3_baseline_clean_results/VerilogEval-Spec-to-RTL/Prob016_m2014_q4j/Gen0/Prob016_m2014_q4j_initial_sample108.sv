module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

// internal signal for carry
wire [3:0] carry;

// calculate sum and carry using full adder for each bit
full_adder fa0(x[0], y[0], 1'b0, sum[0], carry[0]);
full_adder fa1(x[1], y[1], carry[0], sum[1], carry[1]);
full_adder fa2(x[2], y[2], carry[1], sum[2], carry[2]);
full_adder fa3(x[3], y[3], carry[2], sum[3], carry[3]);

// assign the final carry as the overflow bit
assign sum[4] = carry[3];

endmodule

// full adder module
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
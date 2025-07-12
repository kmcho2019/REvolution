// Define a full adder module
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

// TopModule with simplified instantiation of full adders
module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    full_adder fa0(x[0], y[0], 1'b0, sum[0], sum[1]);
    full_adder fa1(x[1], y[1], sum[1], sum[1], sum[2]);
    full_adder fa2(x[2], y[2], sum[2], sum[2], sum[3]);
    full_adder fa3(x[3], y[3], sum[3], sum[3], sum[4]);
endmodule
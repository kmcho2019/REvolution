module FullAdder(a, b, carryIn, sum, carryOut);
    input a;
    input b;
    input carryIn;
    output sum;
    output carryOut;

    assign sum = a ^ b ^ carryIn;
    assign carryOut = (a & b) | (a & carryIn) | (b & carryIn);
endmodule

module TopModule(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;

    wire carry1, carry2, carry3;

    FullAdder fa0(x[0], y[0], 1'b0, sum[0], carry1);
    FullAdder fa1(x[1], y[1], carry1, sum[1], carry2);
    FullAdder fa2(x[2], y[2], carry2, sum[2], carry3);
    FullAdder fa3(x[3], y[3], carry3, sum[3], sum[4]);
endmodule
// FullAdder module remains the same
module FullAdder(
    input   a,
    input   b,
    input   cin,
    output  sum,
    output  cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Refactored TopModule
module TopModule(
    input   [3:0] x,
    input   [3:0] y,
    output  [4:0] sum
);
    wire carry;

    FullAdder fa_0(x[0], y[0], 1'b0, sum[0], carry);
    FullAdder fa_1(x[1], y[1], carry, sum[1], carry);
    FullAdder fa_2(x[2], y[2], carry, sum[2], carry);
    FullAdder fa_3(x[3], y[3], carry, sum[3], sum[4]);
endmodule
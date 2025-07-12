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

module TopModule(
    input   [3:0] x,
    input   [3:0] y,
    output  [4:0] sum
);

    FullAdder fa0(x[0], y[0], 1'b0, sum[0], sum[4]);
    FullAdder fa1(x[1], y[1], sum[4], sum[1], sum[4]);
    FullAdder fa2(x[2], y[2], sum[4], sum[2], sum[4]);
    FullAdder fa3(x[3], y[3], sum[4], sum[3], sum[4]);

endmodule
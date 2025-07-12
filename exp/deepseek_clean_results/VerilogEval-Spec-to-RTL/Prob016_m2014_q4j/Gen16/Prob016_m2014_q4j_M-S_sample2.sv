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

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Directly chain carry signals between adders without explicit wire declarations
    FullAdder fa0 (x[0], y[0], 1'b0, sum[0], c1);
    FullAdder fa1 (x[1], y[1], fa0.cout, sum[1], c2);
    FullAdder fa2 (x[2], y[2], fa1.cout, sum[2], c3);
    FullAdder fa3 (x[3], y[3], fa2.cout, sum[3], sum[4]);
endmodule
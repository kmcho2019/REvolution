// Define a module for a full adder
module FullAdder(
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

// Define the top module with the 4-bit adder
module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);

    wire c0, c1, c2;

    // Instantiate the full adders
    FullAdder fa0(x[0], y[0], 1'b0, sum[0], c0);
    FullAdder fa1(x[1], y[1], c0, sum[1], c1);
    FullAdder fa2(x[2], y[2], c1, sum[2], c2);
    FullAdder fa3(x[3], y[3], c2, sum[3], sum[4]);

endmodule
// Simplified FullAdder module
module FullAdder(
    input   logic a,
    input   logic b,
    input   logic cin,
    output  logic sum,
    output  logic cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

// Simplified TopModule using FullAdder instances
module TopModule(
    input   logic [3:0] x,
    input   logic [3:0] y,
    output  logic [4:0] sum
);

    logic carry_1, carry_2, carry_3; // Declare carry wires

    FullAdder fa0(x[0], y[0], 1'b0, sum[0], carry_1);
    FullAdder fa1(x[1], y[1], carry_1, sum[1], carry_2);
    FullAdder fa2(x[2], y[2], carry_2, sum[2], carry_3);
    FullAdder fa3(x[3], y[3], carry_3, sum[3], sum[4]);

endmodule
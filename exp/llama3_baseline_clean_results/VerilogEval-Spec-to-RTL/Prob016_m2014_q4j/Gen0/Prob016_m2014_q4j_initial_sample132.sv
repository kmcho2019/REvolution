module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);

    wire carry_0, carry_1, carry_2, carry_3;

    full_adder fa0(x[0], y[0], 1'b0, sum[0], carry_0);
    full_adder fa1(x[1], y[1], carry_0, sum[1], carry_1);
    full_adder fa2(x[2], y[2], carry_1, sum[2], carry_2);
    full_adder fa3(x[3], y[3], carry_2, sum[3], carry_3);

    assign sum[4] = carry_3;

endmodule

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
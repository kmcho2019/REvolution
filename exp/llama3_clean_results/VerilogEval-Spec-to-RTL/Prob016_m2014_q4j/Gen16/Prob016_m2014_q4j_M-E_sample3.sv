module KoggeStoneAdder2(
    input   [1:0] a,
    input   [1:0] b,
    output  [1:0] sum,
    output  cout
);

    wire p0, p1, g0, g1;
    wire c0, c1;

    assign p0 = a[0] ^ b[0];
    assign g0 = a[0] & b[0];

    assign sum[0] = p0;
    assign c0 = g0;

    assign p1 = a[1] ^ b[1];
    assign g1 = a[1] & b[1];

    assign sum[1] = p1 ^ c0;
    assign c1 = g1 | (p1 & c0);

    assign cout = c1;

endmodule

module TopModule(
    input   [3:0] x,
    input   [3:0] y,
    output  [4:0] sum
);

    wire [1:0] x_lower, x_upper, y_lower, y_upper;
    wire [1:0] sum_lower, sum_upper;
    wire cout_lower, cout_upper;

    assign x_lower = x[1:0];
    assign x_upper = x[3:2];
    assign y_lower = y[1:0];
    assign y_upper = y[3:2];

    KoggeStoneAdder2 adder_lower(
        .a(x_lower),
        .b(y_lower),
        .sum(sum_lower),
        .cout(cout_lower)
    );

    KoggeStoneAdder2 adder_upper(
        .a(x_upper),
        .b(y_upper),
        .sum(sum_upper),
        .cout(cout_upper)
    );

    assign sum[1:0] = sum_lower;
    assign sum[3:2] = sum_upper ^ {2{cout_lower}};
    assign sum[4] = cout_upper | (sum_upper[1] & cout_lower);

endmodule
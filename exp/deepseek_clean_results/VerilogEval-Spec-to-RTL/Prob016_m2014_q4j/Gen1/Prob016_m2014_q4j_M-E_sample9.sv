module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

    wire [1:0] sum_low;
    wire carry_low;
    wire [1:0] sum_high_0, sum_high_1;
    wire carry_high_0, carry_high_1;

    // Lower 2-bit ripple carry adder
    full_adder fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum_low[0]),
        .cout(carry0)
    );

    full_adder fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(carry0),
        .sum(sum_low[1]),
        .cout(carry_low)
    );

    // Upper 2-bit adders (both carry scenarios)
    // Case when carry-in is 0
    full_adder fa2_0(
        .a(x[2]),
        .b(y[2]),
        .cin(1'b0),
        .sum(sum_high_0[0]),
        .cout(carry1_0)
    );

    full_adder fa3_0(
        .a(x[3]),
        .b(y[3]),
        .cin(carry1_0),
        .sum(sum_high_0[1]),
        .cout(carry_high_0)
    );

    // Case when carry-in is 1
    full_adder fa2_1(
        .a(x[2]),
        .b(y[2]),
        .cin(1'b1),
        .sum(sum_high_1[0]),
        .cout(carry1_1)
    );

    full_adder fa3_1(
        .a(x[3]),
        .b(y[3]),
        .cin(carry1_1),
        .sum(sum_high_1[1]),
        .cout(carry_high_1)
    );

    // Combine results
    assign sum[0] = sum_low[0];
    assign sum[1] = sum_low[1];
    assign sum[2] = carry_low ? sum_high_1[0] : sum_high_0[0];
    assign sum[3] = carry_low ? sum_high_1[1] : sum_high_0[1];
    assign sum[4] = carry_low ? carry_high_1 : carry_high_0;

endmodule

// Full adder module remains the same
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
module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [3:0] sum_low_0, sum_low_1;
    wire [3:0] sum_high_0, sum_high_1;
    wire carry_mid_0, carry_mid_1;
    wire carry_mid;

    // Lower 4 bits (0-3) - ripple carry adder
    ripple_adder_4bit adder_low_0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(1'b0),
        .sum(sum_low_0),
        .cout(carry_mid_0)
    );

    ripple_adder_4bit adder_low_1 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(1'b1),
        .sum(sum_low_1),
        .cout(carry_mid_1)
    );

    // Select lower sum and middle carry based on actual cin
    assign sum[3:0] = cin ? sum_low_1 : sum_low_0;
    assign carry_mid = cin ? carry_mid_1 : carry_mid_0;

    // Upper 4 bits (4-7) - carry-select blocks
    ripple_adder_4bit adder_high_0 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b0),
        .sum(sum_high_0),
        .cout(cout_0)
    );

    ripple_adder_4bit adder_high_1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b1),
        .sum(sum_high_1),
        .cout(cout_1)
    );

    // Select upper sum and final carry based on middle carry
    assign sum[7:4] = carry_mid ? sum_high_1 : sum_high_0;
    assign cout = carry_mid ? cout_1 : cout_0;

endmodule

// 4-bit ripple carry adder module
module ripple_adder_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire [2:0] carry;

    full_adder fa0 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(carry[0]));
    full_adder fa1 (.a(a[1]), .b(b[1]), .cin(carry[0]), .sum(sum[1]), .cout(carry[1]));
    full_adder fa2 (.a(a[2]), .b(b[2]), .cin(carry[1]), .sum(sum[2]), .cout(carry[2]));
    full_adder fa3 (.a(a[3]), .b(b[3]), .cin(carry[2]), .sum(sum[3]), .cout(cout));
endmodule

// Full adder module
module full_adder (
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule
module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [3:0] sum_low;
    wire [3:0] sum_high0, sum_high1;
    wire carry_low;
    wire carry_high0, carry_high1;

    // Lower 4-bit ripple-carry adder
    adder_4bit lower_adder (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum_low),
        .cout(carry_low)
    );

    // Upper 4-bit adders (parallel)
    adder_4bit upper_adder0 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b0),
        .sum(sum_high0),
        .cout(carry_high0)
    );

    adder_4bit upper_adder1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b1),
        .sum(sum_high1),
        .cout(carry_high1)
    );

    // Mux for selecting correct upper sum and carry
    assign sum[3:0] = sum_low;
    assign sum[7:4] = carry_low ? sum_high1 : sum_high0;
    assign cout = carry_low ? carry_high1 : carry_high0;

endmodule

// 4-bit ripple-carry adder module
module adder_4bit (
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
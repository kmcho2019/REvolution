module adder_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire [4:0] carry;
    
    assign carry[0] = cin;
    assign sum = a ^ b ^ carry[3:0];
    assign carry[4:1] = (a & b) | (a & carry[3:0]) | (b & carry[3:0]);
    assign cout = carry[4];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // First 4-bit adder (ripple carry)
    wire cout0;
    adder_4bit adder0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(Cin),
        .sum(y[3:0]),
        .cout(cout0)
    );

    // Next three 4-bit adders (carry-select)
    wire [3:0] sum1_0, sum1_1;
    wire cout1_0, cout1_1;
    adder_4bit adder1_0 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b0),
        .sum(sum1_0),
        .cout(cout1_0)
    );
    adder_4bit adder1_1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b1),
        .sum(sum1_1),
        .cout(cout1_1)
    );
    assign y[7:4] = cout0 ? sum1_1 : sum1_0;
    wire cout1 = cout0 ? cout1_1 : cout1_0;

    wire [3:0] sum2_0, sum2_1;
    wire cout2_0, cout2_1;
    adder_4bit adder2_0 (
        .a(a[11:8]),
        .b(b[11:8]),
        .cin(1'b0),
        .sum(sum2_0),
        .cout(cout2_0)
    );
    adder_4bit adder2_1 (
        .a(a[11:8]),
        .b(b[11:8]),
        .cin(1'b1),
        .sum(sum2_1),
        .cout(cout2_1)
    );
    assign y[11:8] = cout1 ? sum2_1 : sum2_0;
    wire cout2 = cout1 ? cout2_1 : cout2_0;

    wire [3:0] sum3_0, sum3_1;
    wire cout3_0, cout3_1;
    adder_4bit adder3_0 (
        .a(a[15:12]),
        .b(b[15:12]),
        .cin(1'b0),
        .sum(sum3_0),
        .cout(cout3_0)
    );
    adder_4bit adder3_1 (
        .a(a[15:12]),
        .b(b[15:12]),
        .cin(1'b1),
        .sum(sum3_1),
        .cout(cout3_1)
    );
    assign y[15:12] = cout2 ? sum3_1 : sum3_0;
    assign Co = cout2 ? cout3_1 : cout3_0;
endmodule
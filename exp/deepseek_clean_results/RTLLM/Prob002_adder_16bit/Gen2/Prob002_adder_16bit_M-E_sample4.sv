module adder_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire [3:0] carry;

    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign carry[0] = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);

    assign sum[1] = a[1] ^ b[1] ^ carry[0];
    assign carry[1] = (a[1] & b[1]) | (a[1] & carry[0]) | (b[1] & carry[0]);

    assign sum[2] = a[2] ^ b[2] ^ carry[1];
    assign carry[2] = (a[2] & b[2]) | (a[2] & carry[1]) | (b[2] & carry[1]);

    assign sum[3] = a[3] ^ b[3] ^ carry[2];
    assign cout = (a[3] & b[3]) | (a[3] & carry[2]) | (b[3] & carry[2]);
endmodule

module carry_select_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire [3:0] sum0, sum1;
    wire cout0, cout1;

    // Compute both possible sums (cin=0 and cin=1)
    adder_4bit adder_c0 (.a(a), .b(b), .cin(1'b0), .sum(sum0), .cout(cout0));
    adder_4bit adder_c1 (.a(a), .b(b), .cin(1'b1), .sum(sum1), .cout(cout1));

    // Select correct result based on actual carry-in
    assign sum = cin ? sum1 : sum0;
    assign cout = cin ? cout1 : cout0;
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire [3:0] carry;

    // First 4-bit block (regular ripple-carry)
    adder_4bit block0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(Cin),
        .sum(y[3:0]),
        .cout(carry[0])
    );

    // Remaining blocks use carry-select
    carry_select_4bit block1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(carry[0]),
        .sum(y[7:4]),
        .cout(carry[1])
    );

    carry_select_4bit block2 (
        .a(a[11:8]),
        .b(b[11:8]),
        .cin(carry[1]),
        .sum(y[11:8]),
        .cout(carry[2])
    );

    carry_select_4bit block3 (
        .a(a[15:12]),
        .b(b[15:12]),
        .cin(carry[2]),
        .sum(y[15:12]),
        .cout(Co)
    );
endmodule
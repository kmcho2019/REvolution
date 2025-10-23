// 2-bit carry lookahead adder module
module cla_2bit (
    input  wire [1:0] a,     // 2-bit operand A
    input  wire [1:0] b,     // 2-bit operand B
    input  wire       cin,   // carry-in
    output wire [1:0] sum,   // 2-bit sum output
    output wire       cout   // carry-out
);
    wire g0, g1; // generate signals
    wire p0, p1; // propagate signals
    wire c1;     // internal carry between bit0 and bit1

    // Generate and propagate for bit 0
    assign g0 = a[0] & b[0];
    assign p0 = a[0] ^ b[0];
    // Generate and propagate for bit 1
    assign g1 = a[1] & b[1];
    assign p1 = a[1] ^ b[1];

    // Carry lookahead logic
    assign c1  = g0 | (p0 & cin);
    assign cout = g1 | (p1 & c1);

    // Sum bits
    assign sum[0] = p0 ^ cin;
    assign sum[1] = p1 ^ c1;

endmodule

// 8-bit adder using four 2-bit CLA blocks chained together
module adder_8bit (
    input  wire [7:0] a,     // 8-bit operand A
    input  wire [7:0] b,     // 8-bit operand B
    input  wire       cin,   // carry-in input
    output wire [7:0] sum,   // 8-bit sum output
    output wire       cout   // carry-out output
);
    wire c1, c2, c3; // internal carries between 2-bit blocks

    // Instantiate four 2-bit CLA blocks
    cla_2bit cla0 (
        .a(a[1:0]),
        .b(b[1:0]),
        .cin(cin),
        .sum(sum[1:0]),
        .cout(c1)
    );

    cla_2bit cla1 (
        .a(a[3:2]),
        .b(b[3:2]),
        .cin(c1),
        .sum(sum[3:2]),
        .cout(c2)
    );

    cla_2bit cla2 (
        .a(a[5:4]),
        .b(b[5:4]),
        .cin(c2),
        .sum(sum[5:4]),
        .cout(c3)
    );

    cla_2bit cla3 (
        .a(a[7:6]),
        .b(b[7:6]),
        .cin(c3),
        .sum(sum[7:6]),
        .cout(cout)
    );

endmodule
// 2-bit carry lookahead adder module with direct p and g calculation
module cla_2bit (
    input  wire [1:0] a,     // 2-bit operand A
    input  wire [1:0] b,     // 2-bit operand B
    input  wire       cin,   // carry-in
    output wire [1:0] sum,   // 2-bit sum output
    output wire       cout   // carry-out
);
    wire [1:0] p; // propagate signals
    wire [1:0] g; // generate signals
    wire       c1; // internal carry between bit0 and bit1

    // Compute propagate and generate for each bit
    assign p = a ^ b;
    assign g = a & b;

    // Carry lookahead logic within 2-bit block
    assign c1  = g[0] | (p[0] & cin);
    assign cout = g[1] | (p[1] & c1);

    // Sum bits computed by XORing propagate and carry-in
    assign sum[0] = p[0] ^ cin;
    assign sum[1] = p[1] ^ c1;
endmodule

// Top-level 8-bit adder composed of four 2-bit CLA blocks chained together
module adder_8bit (
    input  wire [7:0] a,     // 8-bit operand A
    input  wire [7:0] b,     // 8-bit operand B
    input  wire       cin,   // carry-in input
    output wire [7:0] sum,   // 8-bit sum output
    output wire       cout   // carry-out output
);
    wire c1, c2, c3; // intermediate carries between 2-bit blocks

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
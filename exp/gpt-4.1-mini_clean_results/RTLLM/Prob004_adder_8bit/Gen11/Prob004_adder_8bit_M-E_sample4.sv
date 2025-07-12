// 4-bit carry lookahead adder module
module cla_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout
);
    wire [3:0] p;   // propagate signals
    wire [3:0] g;   // generate signals
    wire [4:1] c;   // carry signals internal to CLA

    // Propagate and generate
    assign p = a ^ b;
    assign g = a & b;

    // Carry lookahead logic
    assign c[1] = g[0] | (p[0] & cin);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign cout = g[3] | (p[3] & c[3]);

    // Sum computation
    assign sum = p ^ {c[3], c[2], c[1], cin};
endmodule

// Top-level 8-bit adder using two 4-bit CLA blocks
module adder_8bit (
    input  wire [7:0] a,    // 8-bit operand A
    input  wire [7:0] b,    // 8-bit operand B
    input  wire       cin,  // carry-in input
    output wire [7:0] sum,  // 8-bit sum output
    output wire       cout  // carry-out output
);
    wire c4;  // carry between lower and upper 4-bit CLA blocks

    // Lower 4-bit CLA block (bits 0 to 3)
    cla_4bit cla_low (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum[3:0]),
        .cout(c4)
    );

    // Upper 4-bit CLA block (bits 4 to 7)
    cla_4bit cla_high (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(c4),
        .sum(sum[7:4]),
        .cout(cout)
    );
endmodule
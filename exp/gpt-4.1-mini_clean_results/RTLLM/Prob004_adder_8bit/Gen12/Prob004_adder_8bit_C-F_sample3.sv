// Single bit full adder module
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    wire axb;
    assign axb  = a ^ b;
    assign sum  = axb ^ cin;
    assign cout = (a & b) | (axb & cin);
endmodule

// 4-bit carry lookahead adder with bit-level full adders
module cla_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout
);
    wire [3:0] p;      // propagate signals
    wire [3:0] g;      // generate signals
    wire [4:1] carry;  // internal carry signals

    // Compute propagate and generate signals for each bit
    assign p = a ^ b;
    assign g = a & b;

    // Carry lookahead logic
    assign carry[1] = g[0] | (p[0] & cin);
    assign carry[2] = g[1] | (p[1] & carry[1]);
    assign carry[3] = g[2] | (p[2] & carry[2]);
    assign cout     = g[3] | (p[3] & carry[3]);

    // Instantiate bit_full_adders for each bit with appropriate carry-in
    bit_full_adder fa0 (.a(a[0]), .b(b[0]), .cin(cin),         .sum(sum[0]), .cout());
    bit_full_adder fa1 (.a(a[1]), .b(b[1]), .cin(carry[1]),    .sum(sum[1]), .cout());
    bit_full_adder fa2 (.a(a[2]), .b(b[2]), .cin(carry[2]),    .sum(sum[2]), .cout());
    bit_full_adder fa3 (.a(a[3]), .b(b[3]), .cin(carry[3]),    .sum(sum[3]), .cout());

endmodule

// Top-level 8-bit adder using two 4-bit CLA blocks composed of bit_full_adders
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
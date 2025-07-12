// Single bit full adder with minimal and balanced combinational logic
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

// 4-bit ripple carry adder block using explicit bit_full_adder instantiations
module adder_4bit (
    input  wire [3:0] a,    // 4-bit operand A
    input  wire [3:0] b,    // 4-bit operand B
    input  wire       cin,  // carry-in input
    output wire [3:0] sum,  // 4-bit sum output
    output wire       cout  // carry-out output
);
    wire [3:0] carry;

    // Bit 0
    bit_full_adder fa0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(carry[0])
    );

    // Bit 1
    bit_full_adder fa1 (
        .a(a[1]),
        .b(b[1]),
        .cin(carry[0]),
        .sum(sum[1]),
        .cout(carry[1])
    );

    // Bit 2
    bit_full_adder fa2 (
        .a(a[2]),
        .b(b[2]),
        .cin(carry[1]),
        .sum(sum[2]),
        .cout(carry[2])
    );

    // Bit 3
    bit_full_adder fa3 (
        .a(a[3]),
        .b(b[3]),
        .cin(carry[2]),
        .sum(sum[3]),
        .cout(cout)
    );
endmodule

// Top-level 8-bit adder using two 4-bit ripple carry adder blocks
module adder_8bit (
    input  wire [7:0] a,    // 8-bit operand A
    input  wire [7:0] b,    // 8-bit operand B
    input  wire       cin,  // carry-in input
    output wire [7:0] sum,  // 8-bit sum output
    output wire       cout  // carry-out output
);
    wire c4;  // carry between lower and upper 4-bit blocks

    // Lower 4 bits addition
    adder_4bit lower_block (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum[3:0]),
        .cout(c4)
    );

    // Upper 4 bits addition
    adder_4bit upper_block (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(c4),
        .sum(sum[7:4]),
        .cout(cout)
    );
endmodule
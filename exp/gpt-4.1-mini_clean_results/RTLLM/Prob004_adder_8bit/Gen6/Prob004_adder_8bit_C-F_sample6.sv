// Single-bit full adder module
module full_adder_bit (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

// 4-bit ripple carry adder using four full_adder_bit instances
module adder_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout
);
    wire c1, c2, c3;

    full_adder_bit fa0 (
        .a(a[0]), .b(b[0]), .cin(cin),
        .sum(sum[0]), .cout(c1)
    );

    full_adder_bit fa1 (
        .a(a[1]), .b(b[1]), .cin(c1),
        .sum(sum[1]), .cout(c2)
    );

    full_adder_bit fa2 (
        .a(a[2]), .b(b[2]), .cin(c2),
        .sum(sum[2]), .cout(c3)
    );

    full_adder_bit fa3 (
        .a(a[3]), .b(b[3]), .cin(c3),
        .sum(sum[3]), .cout(cout)
    );
endmodule

// 8-bit adder chaining two 4-bit adders for full 8-bit addition
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire c4;

    // Lower 4-bit adder (bits 0-3)
    adder_4bit lower_adder (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum[3:0]),
        .cout(c4)
    );

    // Upper 4-bit adder (bits 4-7)
    adder_4bit upper_adder (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(c4),
        .sum(sum[7:4]),
        .cout(cout)
    );
endmodule
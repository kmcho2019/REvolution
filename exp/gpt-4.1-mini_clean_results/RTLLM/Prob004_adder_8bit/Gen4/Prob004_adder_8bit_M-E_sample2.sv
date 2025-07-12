// Single bit full adder module
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

// 4-bit ripple carry adder using 4 bit_full_adders
module adder_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout
);
    wire c1, c2, c3;

    bit_full_adder fa0 (
        .a(a[0]), .b(b[0]), .cin(cin),
        .sum(sum[0]), .cout(c1)
    );

    bit_full_adder fa1 (
        .a(a[1]), .b(b[1]), .cin(c1),
        .sum(sum[1]), .cout(c2)
    );

    bit_full_adder fa2 (
        .a(a[2]), .b(b[2]), .cin(c2),
        .sum(sum[2]), .cout(c3)
    );

    bit_full_adder fa3 (
        .a(a[3]), .b(b[3]), .cin(c3),
        .sum(sum[3]), .cout(cout)
    );
endmodule

// 8-bit adder built by chaining two 4-bit adders
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire carry_mid;

    // Lower 4 bits adder
    adder_4bit lower_adder (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum[3:0]),
        .cout(carry_mid)
    );

    // Upper 4 bits adder
    adder_4bit upper_adder (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(carry_mid),
        .sum(sum[7:4]),
        .cout(cout)
    );
endmodule
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    // Full adder gate-level implementation for minimal logic
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire carry0, carry1, carry2, carry3, carry4, carry5, carry6;

    // Bit 0 full adder
    bit_full_adder fa0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(carry0)
    );

    // Bit 1 full adder
    bit_full_adder fa1 (
        .a(a[1]),
        .b(b[1]),
        .cin(carry0),
        .sum(sum[1]),
        .cout(carry1)
    );

    // Bit 2 full adder
    bit_full_adder fa2 (
        .a(a[2]),
        .b(b[2]),
        .cin(carry1),
        .sum(sum[2]),
        .cout(carry2)
    );

    // Bit 3 full adder
    bit_full_adder fa3 (
        .a(a[3]),
        .b(b[3]),
        .cin(carry2),
        .sum(sum[3]),
        .cout(carry3)
    );

    // Bit 4 full adder
    bit_full_adder fa4 (
        .a(a[4]),
        .b(b[4]),
        .cin(carry3),
        .sum(sum[4]),
        .cout(carry4)
    );

    // Bit 5 full adder
    bit_full_adder fa5 (
        .a(a[5]),
        .b(b[5]),
        .cin(carry4),
        .sum(sum[5]),
        .cout(carry5)
    );

    // Bit 6 full adder
    bit_full_adder fa6 (
        .a(a[6]),
        .b(b[6]),
        .cin(carry5),
        .sum(sum[6]),
        .cout(carry6)
    );

    // Bit 7 full adder
    bit_full_adder fa7 (
        .a(a[7]),
        .b(b[7]),
        .cin(carry6),
        .sum(sum[7]),
        .cout(cout)
    );

endmodule
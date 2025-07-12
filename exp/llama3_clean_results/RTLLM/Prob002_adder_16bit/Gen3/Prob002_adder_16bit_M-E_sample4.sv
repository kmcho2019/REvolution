// Novel 4-bit full adder module using a Booth multiplier-inspired approach
module adder_4bit_novel(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);

    // Calculate sum (y) and carry (Co) directly
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign y[1] = a[1] ^ b[1] ^ (a[0] & b[0] | (a[0] ^ b[0]) & Cin);
    assign y[2] = a[2] ^ b[2] ^ (a[1] & b[1] | (a[1] ^ b[1]) & (a[0] & b[0] | (a[0] ^ b[0]) & Cin));
    assign y[3] = a[3] ^ b[3] ^ (a[2] & b[2] | (a[2] ^ b[2]) & (a[1] & b[1] | (a[1] ^ b[1]) & (a[0] & b[0] | (a[0] ^ b[0]) & Cin)));
    assign Co = (a[3] & b[3]) | (a[3] ^ b[3]) & (a[2] & b[2] | (a[2] ^ b[2]) & (a[1] & b[1] | (a[1] ^ b[1]) & (a[0] & b[0] | (a[0] ^ b[0]) & Cin)));

endmodule

// 16-bit full adder module using the novel 4-bit adder
module adder_16bit_novel(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire C4, C8, C12;

    // Instantiate four novel 4-bit adders
    adder_4bit_novel adder_lower(
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(C4)
    );

    adder_4bit_novel adder_4_7(
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(C4),
        .y(y[7:4]),
        .Co(C8)
    );

    adder_4bit_novel adder_8_11(
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(C8),
        .y(y[11:8]),
        .Co(C12)
    );

    adder_4bit_novel adder_upper(
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(C12),
        .y(y[15:12]),
        .Co(Co)
    );

endmodule
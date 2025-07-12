// Define the module for a 4-bit carry-lookahead adder
module adder_4bit_cla(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);

    // Generate signals for carry-lookahead logic
    wire g0, g1, g2, g3; // Generate signals
    wire p0, p1, p2, p3; // Propagate signals
    wire c1, c2, c3; // Internal carry signals

    assign g0 = a[0] & b[0];
    assign p0 = a[0] ^ b[0];
    assign y[0] = p0 ^ Cin;

    assign g1 = a[1] & b[1];
    assign p1 = a[1] ^ b[1];
    assign c1 = g0 | (p0 & Cin);
    assign y[1] = p1 ^ c1;

    assign g2 = a[2] & b[2];
    assign p2 = a[2] ^ b[2];
    assign c2 = g1 | (p1 & c1);
    assign y[2] = p2 ^ c2;

    assign g3 = a[3] & b[3];
    assign p3 = a[3] ^ b[3];
    assign c3 = g2 | (p2 & c2);
    assign y[3] = p3 ^ c3;

    assign Co = g3 | (p3 & c3);

endmodule

// Define the module for a 16-bit full adder using the segmented carry-lookahead approach
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire carry_4bit_1, carry_4bit_2, carry_4bit_3;

    // Instantiate the first 4-bit carry-lookahead adder
    adder_4bit_cla adder_4bit_1_inst(
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(carry_4bit_1)
    );

    // Instantiate the second 4-bit carry-lookahead adder
    adder_4bit_cla adder_4bit_2_inst(
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(carry_4bit_1),
        .y(y[7:4]),
        .Co(carry_4bit_2)
    );

    // Instantiate the third 4-bit carry-lookahead adder
    adder_4bit_cla adder_4bit_3_inst(
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(carry_4bit_2),
        .y(y[11:8]),
        .Co(carry_4bit_3)
    );

    // Instantiate the fourth 4-bit carry-lookahead adder
    adder_4bit_cla adder_4bit_4_inst(
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(carry_4bit_3),
        .y(y[15:12]),
        .Co(Co)
    );

endmodule
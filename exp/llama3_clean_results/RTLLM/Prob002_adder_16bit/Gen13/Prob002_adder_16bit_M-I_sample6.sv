// Define the module for a 1-bit full adder
module adder_1bit(
    input a,
    input b,
    input Cin,
    output y,
    output Co
);
    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// Define the module for a 4-bit full adder using ripple-carry
module adder_4bit(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);
    wire c1, c2, c3;

    // Instantiate the least significant 1-bit adder
    adder_1bit adder_ls(
        .a(a[0]),
        .b(b[0]),
        .Cin(Cin),
        .y(y[0]),
        .Co(c1)
    );

    // Instantiate the second 1-bit adder
    adder_1bit adder_2(
        .a(a[1]),
        .b(b[1]),
        .Cin(c1),
        .y(y[1]),
        .Co(c2)
    );

    // Instantiate the third 1-bit adder
    adder_1bit adder_3(
        .a(a[2]),
        .b(b[2]),
        .Cin(c2),
        .y(y[2]),
        .Co(c3)
    );

    // Instantiate the most significant 1-bit adder
    adder_1bit adder_ms(
        .a(a[3]),
        .b(b[3]),
        .Cin(c3),
        .y(y[3]),
        .Co(Co)
    );
endmodule

// Define the module for a 16-bit full adder using four 4-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry_4bit_1, carry_4bit_2, carry_4bit_3;

    // Instantiate the least significant 4-bit adder
    adder_4bit adder_ls(
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(carry_4bit_1)
    );

    // Instantiate the second 4-bit adder
    adder_4bit adder_2(
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(carry_4bit_1),
        .y(y[7:4]),
        .Co(carry_4bit_2)
    );

    // Instantiate the third 4-bit adder
    adder_4bit adder_3(
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(carry_4bit_2),
        .y(y[11:8]),
        .Co(carry_4bit_3)
    );

    // Instantiate the most significant 4-bit adder
    adder_4bit adder_ms(
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(carry_4bit_3),
        .y(y[15:12]),
        .Co(Co)
    );
endmodule
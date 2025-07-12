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

// Define the module for a 4-bit full adder
module adder_4bit(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);

    wire [3:0] carry;

    // Calculate carry signals
    assign carry[0] = Cin;
    assign carry[1] = (a[0] & b[0]) | (a[0] & carry[0]) | (b[0] & carry[0]);
    assign carry[2] = (a[1] & b[1]) | (a[1] & carry[1]) | (b[1] & carry[1]);
    assign carry[3] = (a[2] & b[2]) | (a[2] & carry[2]) | (b[2] & carry[2]);

    // Calculate output sum
    assign y[0] = a[0] ^ b[0] ^ carry[0];
    assign y[1] = a[1] ^ b[1] ^ carry[1];
    assign y[2] = a[2] ^ b[2] ^ carry[2];
    assign y[3] = a[3] ^ b[3] ^ carry[3];

    // Calculate final carry-out
    assign Co = (a[3] & b[3]) | (a[3] & carry[3]) | (b[3] & carry[3]);

endmodule

// Define the module for a 16-bit full adder using four 4-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    // Internal signals for carry
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
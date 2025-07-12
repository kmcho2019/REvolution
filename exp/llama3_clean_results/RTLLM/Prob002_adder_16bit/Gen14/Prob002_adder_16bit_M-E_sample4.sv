// Define the module for a 4-bit full adder
module adder_4bit(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);

    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign y[1] = a[1] ^ b[1] ^ (a[0] & b[0] | (a[0] ^ b[0]) & Cin);
    assign y[2] = a[2] ^ b[2] ^ (a[1] & b[1] | (a[1] ^ b[1]) & (a[0] & b[0] | (a[0] ^ b[0]) & Cin));
    assign y[3] = a[3] ^ b[3] ^ (a[2] & b[2] | (a[2] ^ b[2]) & (a[1] & b[1] | (a[1] ^ b[1]) & (a[0] & b[0] | (a[0] ^ b[0]) & Cin)));
    assign Co = (a[3] & b[3]) | (a[3] ^ b[3]) & (a[2] & b[2] | (a[2] ^ b[2]) & (a[1] & b[1] | (a[1] ^ b[1]) & (a[0] & b[0] | (a[0] ^ b[0]) & Cin)));

endmodule

// Define the module for an 8-bit full adder using Kogge-Stone adder concept
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    // Internal signals for carries
    wire c0, c1, c2, c3;

    // Calculate sum and carry for the least significant 4-bit segment
    adder_4bit adder_ls(
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(c0)
    );

    // Calculate sum and carry for the second 4-bit segment
    adder_4bit adder_2(
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(c0),
        .y(y[7:4]),
        .Co(c1)
    );

    // Calculate carry for the 8-bit segment
    assign c2 = c1;

    // Calculate the final carry
    assign Co = c2;

endmodule

// Define the module for a 16-bit full adder using two 8-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    // Internal signals for carries
    wire c8;

    // Instantiate the least significant 8-bit adder
    adder_8bit adder_ls(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(c8)
    );

    // Instantiate the most significant 8-bit adder
    adder_8bit adder_ms(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c8),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule
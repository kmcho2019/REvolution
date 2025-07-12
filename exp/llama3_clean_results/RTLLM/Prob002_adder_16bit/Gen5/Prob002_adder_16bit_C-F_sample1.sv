// Define the module for a 4-bit full adder
module adder_4bit(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);

    // Internal signal for carry
    wire [3:0] carry;

    // First bit (bit 0) adder
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign carry[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);

    // Bits 1 to 3 adders
    assign y[1] = a[1] ^ b[1] ^ carry[0];
    assign carry[1] = (a[1] & b[1]) | (a[1] & carry[0]) | (b[1] & carry[0]);

    assign y[2] = a[2] ^ b[2] ^ carry[1];
    assign carry[2] = (a[2] & b[2]) | (a[2] & carry[1]) | (b[2] & carry[1]);

    assign y[3] = a[3] ^ b[3] ^ carry[2];
    assign Co = (a[3] & b[3]) | (a[3] & carry[2]) | (b[3] & carry[2]);

endmodule

// Define the module for an 8-bit full adder using two 4-bit adders
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    wire C1;

    // Instantiate two 4-bit adders
    adder_4bit adder_ls(
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(C1)
    );

    adder_4bit adder_ms(
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(C1),
        .y(y[7:4]),
        .Co(Co)
    );

endmodule

// Define the module for a 16-bit full adder using two 8-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire C1;

    // Instantiate two 8-bit adders
    adder_8bit adder_lower(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(C1)
    );

    adder_8bit adder_upper(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(C1),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule
// Define the module for an 8-bit full adder
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    // Internal signals for carry
    wire [7:1] carry;

    // First bit (bit 0) adder
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign carry[1] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);

    // Bits 1 to 7 adders
    assign y[1] = a[1] ^ b[1] ^ carry[1];
    assign carry[2] = (a[1] & b[1]) | (a[1] & carry[1]) | (b[1] & carry[1]);

    assign y[2] = a[2] ^ b[2] ^ carry[2];
    assign carry[3] = (a[2] & b[2]) | (a[2] & carry[2]) | (b[2] & carry[2]);

    assign y[3] = a[3] ^ b[3] ^ carry[3];
    assign carry[4] = (a[3] & b[3]) | (a[3] & carry[3]) | (b[3] & carry[3]);

    assign y[4] = a[4] ^ b[4] ^ carry[4];
    assign carry[5] = (a[4] & b[4]) | (a[4] & carry[4]) | (b[4] & carry[4]);

    assign y[5] = a[5] ^ b[5] ^ carry[5];
    assign carry[6] = (a[5] & b[5]) | (a[5] & carry[5]) | (b[5] & carry[5]);

    assign y[6] = a[6] ^ b[6] ^ carry[6];
    assign carry[7] = (a[6] & b[6]) | (a[6] & carry[6]) | (b[6] & carry[6]);

    assign y[7] = a[7] ^ b[7] ^ carry[7];

    // Assign Co
    assign Co = carry[7];

endmodule

// Define the module for a 16-bit full adder using two 8-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire carry_8bit;

    // Instantiate the least significant 8-bit adder
    adder_8bit adder_ls(
       .a(a[7:0]),
       .b(b[7:0]),
       .Cin(Cin),
       .y(y[7:0]),
       .Co(carry_8bit)
    );

    // Instantiate the most significant 8-bit adder
    adder_8bit adder_ms(
       .a(a[15:8]),
       .b(b[15:8]),
       .Cin(carry_8bit),
       .y(y[15:8]),
       .Co(Co)
    );

endmodule
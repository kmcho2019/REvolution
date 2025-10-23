// Define the 8-bit full adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    // Initialize the carry-out
    wire [7:0] carry;

    // Calculate the sum and carry for each bit
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign carry[0] = a[0] & b[0] | a[0] & Cin | b[0] & Cin;

    // For each bit from 1 to 7, calculate the sum and carry
    assign y[1] = a[1] ^ b[1] ^ carry[0];
    assign carry[1] = a[1] & b[1] | a[1] & carry[0] | b[1] & carry[0];

    assign y[2] = a[2] ^ b[2] ^ carry[1];
    assign carry[2] = a[2] & b[2] | a[2] & carry[1] | b[2] & carry[1];

    assign y[3] = a[3] ^ b[3] ^ carry[2];
    assign carry[3] = a[3] & b[3] | a[3] & carry[2] | b[3] & carry[2];

    assign y[4] = a[4] ^ b[4] ^ carry[3];
    assign carry[4] = a[4] & b[4] | a[4] & carry[3] | b[4] & carry[3];

    assign y[5] = a[5] ^ b[5] ^ carry[4];
    assign carry[5] = a[5] & b[5] | a[5] & carry[4] | b[5] & carry[4];

    assign y[6] = a[6] ^ b[6] ^ carry[5];
    assign carry[6] = a[6] & b[6] | a[6] & carry[5] | b[6] & carry[5];

    assign y[7] = a[7] ^ b[7] ^ carry[6];
    assign Co = a[7] & b[7] | a[7] & carry[6] | b[7] & carry[6];

endmodule

// Define the 16-bit full adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    // Instantiate two 8-bit adders
    wire carry_out;

    adder_8bit adder_lower(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_out)
    );

    adder_8bit adder_upper(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_out),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule
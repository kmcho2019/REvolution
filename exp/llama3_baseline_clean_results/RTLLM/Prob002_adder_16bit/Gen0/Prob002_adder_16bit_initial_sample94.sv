// Define the 8-bit full adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    // Use a temporary variable to store the carry
    wire [7:0] carry;

    // Generate the carry bits for each bit position
    assign carry[0] = a[0] & b[0] | a[0] & Cin | b[0] & Cin;
    assign carry[1] = a[1] & b[1] | a[1] & carry[0] | b[1] & carry[0];
    assign carry[2] = a[2] & b[2] | a[2] & carry[1] | b[2] & carry[1];
    assign carry[3] = a[3] & b[3] | a[3] & carry[2] | b[3] & carry[2];
    assign carry[4] = a[4] & b[4] | a[4] & carry[3] | b[4] & carry[3];
    assign carry[5] = a[5] & b[5] | a[5] & carry[4] | b[5] & carry[4];
    assign carry[6] = a[6] & b[6] | a[6] & carry[5] | b[6] & carry[5];
    assign carry[7] = a[7] & b[7] | a[7] & carry[6] | b[7] & carry[6];

    // Generate the sum bits for each bit position
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign y[1] = a[1] ^ b[1] ^ carry[0];
    assign y[2] = a[2] ^ b[2] ^ carry[1];
    assign y[3] = a[3] ^ b[3] ^ carry[2];
    assign y[4] = a[4] ^ b[4] ^ carry[3];
    assign y[5] = a[5] ^ b[5] ^ carry[4];
    assign y[6] = a[6] ^ b[6] ^ carry[5];
    assign y[7] = a[7] ^ b[7] ^ carry[6];

    // The final carry-out
    assign Co = carry[7];

endmodule

// Define the 16-bit full adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    // Instantiate the 8-bit adder for the lower 8 bits
    wire Co1;
    adder_8bit adder_lower(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(Co1)
    );

    // Instantiate the 8-bit adder for the upper 8 bits
    adder_8bit adder_upper(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(Co1),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule
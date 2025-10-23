// Define the 8-bit full adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    // Internal carry signal
    wire [7:0] carry;

    // Assign the carry-out of each bit to the carry-in of the next bit
    assign carry[0] = Cin;
    assign Co = carry[7];

    // Use the full adder equation for each bit
    assign y[0] = a[0] ^ b[0] ^ carry[0];
    assign carry[1] = (a[0] & b[0]) | (a[0] & carry[0]) | (b[0] & carry[0]);

    // Instantiate the same logic for the remaining 7 bits
    assign y[1] = a[1] ^ b[1] ^ carry[1];
    assign carry[2] = (a[1] & b[1]) | (a[1] & carry[1]) | (b[1] & carry[1]);

    assign y[2] = a[2] ^ b[2] ^ carry[2];
    assign carry[3] = (a[2] & b[2]) | (a[2] & carry[2]) | (b[2] & carry[3]);

    assign y[3] = a[3] ^ b[3] ^ carry[3];
    assign carry[4] = (a[3] & b[3]) | (a[3] & carry[3]) | (b[3] & carry[3]);

    assign y[4] = a[4] ^ b[4] ^ carry[4];
    assign carry[5] = (a[4] & b[4]) | (a[4] & carry[4]) | (b[4] & carry[4]);

    assign y[5] = a[5] ^ b[5] ^ carry[5];
    assign carry[6] = (a[5] & b[5]) | (a[5] & carry[5]) | (b[5] & carry[5]);

    assign y[6] = a[6] ^ b[6] ^ carry[6];
    assign carry[7] = (a[6] & b[6]) | (a[6] & carry[6]) | (b[6] & carry[6]);

    assign y[7] = a[7] ^ b[7] ^ carry[7];

endmodule

// Define the 16-bit full adder module using the 8-bit adder
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    // Internal carry signal from the lower 8-bit adder
    wire lower_co;

    // Instantiate the 8-bit adder for the lower 8 bits
    adder_8bit lower_adder(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(lower_co)
    );

    // Instantiate the 8-bit adder for the upper 8 bits
    adder_8bit upper_adder(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(lower_co),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule
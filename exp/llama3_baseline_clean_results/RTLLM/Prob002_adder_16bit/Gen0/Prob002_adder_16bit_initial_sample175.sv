// Define the 8-bit full adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    // Internal signal to hold the carry
    wire [7:0] carry;

    // The first bit (least significant) does not have a carry-in from a previous bit
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign carry[0] = a[0] & b[0] | a[0] & Cin | b[0] & Cin;

    // For the remaining bits, use the carry from the previous bit as the carry-in
    generate
        for (genvar i = 1; i < 8; i++) begin
            assign y[i] = a[i] ^ b[i] ^ carry[i-1];
            assign carry[i] = a[i] & b[i] | a[i] & carry[i-1] | b[i] & carry[i-1];
        end
    endgenerate

    // The carry-out is the carry from the most significant bit
    assign Co = carry[7];

endmodule

// Now define the 16-bit full adder module using the 8-bit adder
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    // Internal signal to hold the carry between the two 8-bit adders
    wire carry_8bit;

    // Use the 8-bit adder for the least significant 8 bits
    adder_8bit adder_ls(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_8bit)
    );

    // Use the 8-bit adder for the most significant 8 bits, with the carry from the previous stage
    adder_8bit adder_ms(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_8bit),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule
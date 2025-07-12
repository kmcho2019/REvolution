// Define the 8-bit full adder module
module adder_8bit(
    input   [7:0] a,  // 8-bit input operand A
    input   [7:0] b,  // 8-bit input operand B
    input         Cin,  // Carry-in input
    output  [7:0] y,  // 8-bit output representing the sum of A and B
    output        Co   // Carry-out output
);

    // Internal wires to handle carry chain
    wire [7:0] carry;

    // The first bit's sum and carry
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign carry[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);

    // For each bit from 1 to 7, calculate the sum and carry
    generate
        for (genvar i = 1; i < 8; i++) begin
            assign y[i] = a[i] ^ b[i] ^ carry[i-1];
            assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
        end
    endgenerate

    // The final carry-out is the carry from the most significant bit
    assign Co = carry[7];

endmodule

// Define the 16-bit full adder module
module adder_16bit(
    input   [15:0] a,  // 16-bit input operand A
    input   [15:0] b,  // 16-bit input operand B
    input         Cin,  // Carry-in input
    output  [15:0] y,  // 16-bit output representing the sum of A and B
    output        Co   // Carry-out output
);

    // Instantiate the 8-bit adder twice for lower and upper 8 bits
    wire        mid_carry;
    wire  [7:0] lower_sum, upper_sum;

    adder_8bit lower_adder(
        .a(a[7:0]),  // Lower 8 bits of A
        .b(b[7:0]),  // Lower 8 bits of B
        .Cin(Cin),  // Carry-in to the lower 8-bit adder
        .y(lower_sum),  // Sum of lower 8 bits
        .Co(mid_carry)  // Carry from lower 8 bits to upper 8 bits
    );

    adder_8bit upper_adder(
        .a(a[15:8]),  // Upper 8 bits of A
        .b(b[15:8]),  // Upper 8 bits of B
        .Cin(mid_carry),  // Carry-in to the upper 8-bit adder
        .y(upper_sum),  // Sum of upper 8 bits
        .Co(Co)  // Final carry-out
    );

    // Combine the sums of the lower and upper 8 bits
    assign y[7:0] = lower_sum;
    assign y[15:8] = upper_sum;

endmodule
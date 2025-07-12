// Define the 8-bit full adder module
module adder_8bit(
    input [7:0] a,  // 8-bit input operand A
    input [7:0] b,  // 8-bit input operand B
    input Cin,      // Carry-in input
    output [7:0] y, // 8-bit output representing the sum of A and B
    output Co        // Carry-out output
);

    // Internal wire to hold the carry signals
    wire [7:0] carry;

    // Assign the carry-out of each bit to the carry-in of the next bit
    assign carry[0] = Cin;
    assign y[0] = a[0] ^ b[0] ^ carry[0];
    assign Co = a[7] ^ b[7] ^ carry[7];

    // Generate the sum and carry for each bit
    generate
        for (genvar i = 1; i < 8; i++) begin
            assign carry[i] = (a[i-1] & b[i-1]) | (a[i-1] & carry[i-1]) | (b[i-1] & carry[i-1]);
            assign y[i] = a[i] ^ b[i] ^ carry[i];
        end
    endgenerate

endmodule

// Define the 16-bit full adder module
module adder_16bit(
    input [15:0] a,  // 16-bit input operand A
    input [15:0] b,  // 16-bit input operand B
    input Cin,       // Carry-in input
    output [15:0] y, // 16-bit output representing the sum of A and B
    output Co         // Carry-out output
);

    // Instantiate two 8-bit adders
    wire Co_8bit;
    adder_8bit adder_low(
        .a(a[7:0]),   // Lower 8 bits of A
        .b(b[7:0]),   // Lower 8 bits of B
        .Cin(Cin),    // Carry-in
        .y(y[7:0]),   // Lower 8 bits of the sum
        .Co(Co_8bit)  // Carry-out of the lower 8 bits
    );

    adder_8bit adder_high(
        .a(a[15:8]),  // Upper 8 bits of A
        .b(b[15:8]),  // Upper 8 bits of B
        .Cin(Co_8bit),// Carry-in from the lower 8 bits
        .y(y[15:8]),  // Upper 8 bits of the sum
        .Co(Co)       // Carry-out of the upper 8 bits
    );

endmodule
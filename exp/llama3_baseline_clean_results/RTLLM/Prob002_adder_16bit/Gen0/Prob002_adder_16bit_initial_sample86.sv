// Module for an 8-bit full adder
module adder_8bit(
    input  [7:0] a,  // 8-bit input operand A
    input  [7:0] b,  // 8-bit input operand B
    input        Cin, // Carry-in input
    output [7:0] y,   // 8-bit output representing the sum of A and B
    output       Co   // Carry-out output
);
    wire [8:0] sum; // Temporary wire to hold the sum

    // Calculate the sum using the addition operator
    assign sum = {1'b0, a} + {1'b0, b} + Cin;

    // Assign the lower 8 bits of sum to output y
    assign y = sum[7:0];

    // Assign the most significant bit of sum to carry-out Co
    assign Co = sum[8];
endmodule

// Module for a 16-bit full adder using two 8-bit adders
module adder_16bit(
    input  [15:0] a,  // 16-bit input operand A
    input  [15:0] b,  // 16-bit input operand B
    input        Cin, // Carry-in input
    output [15:0] y,  // 16-bit output representing the sum of A and B
    output       Co   // Carry-out output
);
    wire        c_mid; // Carry signal between the two 8-bit adders

    // Instantiate the first 8-bit adder for the lower 8 bits
    adder_8bit u_adder_0(
       .a(a[7:0]),   // Lower 8 bits of input A
       .b(b[7:0]),   // Lower 8 bits of input B
       .Cin(Cin),    // Carry-in
       .y(y[7:0]),   // Lower 8 bits of output
       .Co(c_mid)    // Carry-out to the next adder
    );

    // Instantiate the second 8-bit adder for the upper 8 bits
    adder_8bit u_adder_1(
       .a(a[15:8]),  // Upper 8 bits of input A
       .b(b[15:8]),  // Upper 8 bits of input B
       .Cin(c_mid),  // Carry-in from the previous adder
       .y(y[15:8]),  // Upper 8 bits of output
       .Co(Co)       // Final carry-out
    );
endmodule
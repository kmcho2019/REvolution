// Define the 8-bit full adder module
module adder_8bit(
    input [7:0] a,  // 8-bit input operand A
    input [7:0] b,  // 8-bit input operand B
    input Cin,      // Carry-in input
    output [7:0] y, // 8-bit output representing the sum of A and B
    output Co       // Carry-out output
);

    wire [7:0] sum;  // Internal wire for the sum
    assign sum = a + b + Cin;  // Calculate sum
    assign y = sum[7:0];       // Output the sum
    assign Co = sum[8];        // Carry-out is the 8th bit of the sum (which is the carry)

endmodule

// Define the 16-bit full adder module using the 8-bit adder
module adder_16bit(
    input [15:0] a,  // 16-bit input operand A
    input [15:0] b,  // 16-bit input operand B
    input Cin,        // Carry-in input
    output [15:0] y, // 16-bit output representing the sum of A and B
    output Co         // Carry-out output
);

    wire Cmid;  // Internal wire for the carry from the first 8-bit adder to the second

    // Instantiate the first 8-bit adder for the lower 8 bits
    adder_8bit u_adder_lower(
        .a(a[7:0]),   // Lower 8 bits of A
        .b(b[7:0]),   // Lower 8 bits of B
        .Cin(Cin),    // Carry-in
        .y(y[7:0]),   // Lower 8 bits of the output
        .Co(Cmid)     // Carry-out to the next adder
    );

    // Instantiate the second 8-bit adder for the upper 8 bits
    adder_8bit u_adder_upper(
        .a(a[15:8]),  // Upper 8 bits of A
        .b(b[15:8]),  // Upper 8 bits of B
        .Cin(Cmid),   // Carry-in from the previous adder
        .y(y[15:8]),  // Upper 8 bits of the output
        .Co(Co)       // Final carry-out
    );

endmodule
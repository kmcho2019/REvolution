// Define an 8-bit adder module
module adder_8bit(
    input [7:0] a,  // 8-bit input operand A
    input [7:0] b,  // 8-bit input operand B
    input Cin,      // Carry-in input
    output [7:0] y, // 8-bit output representing the sum of A and B
    output Co        // Carry-out output
);

    // Perform addition bit by bit and generate carry
    assign {Co, y} = a + b + Cin;

endmodule

// Define the 16-bit adder module using the 8-bit adder
module adder_16bit(
    input [15:0] a,  // 16-bit input operand A
    input [15:0] b,  // 16-bit input operand B
    input Cin,       // Carry-in input
    output [15:0] y, // 16-bit output representing the sum of A and B
    output Co         // Carry-out output
);

    wire [7:0] a_low, b_low, y_low;  // Lower 8 bits
    wire [7:0] a_high, b_high, y_high;  // Higher 8 bits
    wire carry_middle;  // Carry from lower 8 bits to higher 8 bits

    assign a_low = a[7:0];
    assign b_low = b[7:0];
    assign a_high = a[15:8];
    assign b_high = b[15:8];

    // Instantiate the 8-bit adder for the lower 8 bits
    adder_8bit adder_low(
        .a(a_low),
        .b(b_low),
        .Cin(Cin),
        .y(y_low),
        .Co(carry_middle)
    );

    // Instantiate the 8-bit adder for the higher 8 bits
    adder_8bit adder_high(
        .a(a_high),
        .b(b_high),
        .Cin(carry_middle),
        .y(y_high),
        .Co(Co)
    );

    // Combine the results of the two 8-bit adders
    assign y[7:0] = y_low;
    assign y[15:8] = y_high;

endmodule
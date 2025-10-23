// Define an 8-bit full adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    assign {Co, y} = a + b + Cin;
endmodule

// Define the 16-bit full adder module using two 8-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire [7:0] y_low;  // Lower 8 bits of the sum
    wire Cmiddle;      // Carry from the lower 8 bits to the upper 8 bits

    // Instantiate the first 8-bit adder for the lower 8 bits
    adder_8bit adder_low(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y_low),
        .Co(Cmiddle)
    );

    // Instantiate the second 8-bit adder for the upper 8 bits
    adder_8bit adder_high(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(Cmiddle),
        .y(y[15:8]),
        .Co(Co)
    );

    // Assign the lower 8 bits of the output
    assign y[7:0] = y_low;
endmodule
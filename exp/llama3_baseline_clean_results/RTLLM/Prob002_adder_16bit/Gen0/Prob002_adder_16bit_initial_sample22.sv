// Define the 8-bit adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    // Calculate the sum of a and b with carry-in
    assign {Co, y} = a + b + Cin;

endmodule

// Define the 16-bit adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    // Define wires for the carry-out of the first 8-bit adder
    wire C_out1;

    // Instantiate the first 8-bit adder for the lower 8 bits
    adder_8bit u1(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(C_out1)
    );

    // Instantiate the second 8-bit adder for the upper 8 bits
    adder_8bit u2(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(C_out1),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule
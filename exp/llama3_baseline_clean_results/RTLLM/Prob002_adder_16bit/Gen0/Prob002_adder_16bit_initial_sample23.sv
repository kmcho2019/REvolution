// Define a module for an 8-bit full adder
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    assign {Co, y} = a + b + Cin;
endmodule

// Define a module for a 16-bit full adder using the 8-bit adder
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire [7:0] lower_y;
    wire [7:0] upper_y;
    wire lower_Co;

    // Instantiate the 8-bit adder for the lower 8 bits
    adder_8bit lower_adder(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(lower_y),
        .Co(lower_Co)
    );

    // Instantiate the 8-bit adder for the upper 8 bits
    adder_8bit upper_adder(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(lower_Co),
        .y(upper_y),
        .Co(Co)
    );

    // Concatenate the results of the lower and upper adders
    assign y = {upper_y, lower_y};
endmodule
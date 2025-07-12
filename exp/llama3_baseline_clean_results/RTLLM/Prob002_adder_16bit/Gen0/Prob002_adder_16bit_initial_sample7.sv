// Define an 8-bit full adder module
module adder_8bit(a, b, Cin, y, Co);
    input [7:0] a;
    input [7:0] b;
    input Cin;
    output [7:0] y;
    output Co;

    wire [7:0] y_int;
    wire Co_int;

    // Perform bit-wise addition and calculate carry
    assign {Co, y_int[7:0]} = a + b + Cin;

    // Assign outputs
    assign y = y_int;
    assign Co = Co_int;
endmodule

// Define the 16-bit full adder module using the 8-bit adder
module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a;
    input [15:0] b;
    input Cin;
    output [15:0] y;
    output Co;

    wire Co_8bit;

    // Instantiate the 8-bit adder for the lower 8 bits
    adder_8bit adder_lower(
        .a(a[7:0]), 
        .b(b[7:0]), 
        .Cin(Cin), 
        .y(y[7:0]), 
        .Co(Co_8bit)
    );

    // Instantiate the 8-bit adder for the upper 8 bits
    adder_8bit adder_upper(
        .a(a[15:8]), 
        .b(b[15:8]), 
        .Cin(Co_8bit), 
        .y(y[15:8]), 
        .Co(Co)
    );
endmodule
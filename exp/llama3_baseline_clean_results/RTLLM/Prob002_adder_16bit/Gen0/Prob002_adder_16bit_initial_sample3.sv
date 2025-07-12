// Define a module for an 8-bit adder
module adder_8bit(a, b, Cin, y, Co);
    input [7:0] a;
    input [7:0] b;
    input Cin;
    output [7:0] y;
    output Co;

    // Calculate the sum and carry out for 8-bit inputs
    assign {Co, y} = a + b + Cin;
endmodule

// Define the main 16-bit adder module
module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a;
    input [15:0] b;
    input Cin;
    output [15:0] y;
    output Co;

    // Internal wire for carry from the first 8-bit adder
    wire carry_8bit;

    // Instantiate two 8-bit adders for high and low 8 bits
    adder_8bit u_adder_low(
        .a(a[7:0]), 
        .b(b[7:0]), 
        .Cin(Cin), 
        .y(y[7:0]), 
        .Co(carry_8bit)
    );

    adder_8bit u_adder_high(
        .a(a[15:8]), 
        .b(b[15:8]), 
        .Cin(carry_8bit), 
        .y(y[15:8]), 
        .Co(Co)
    );
endmodule
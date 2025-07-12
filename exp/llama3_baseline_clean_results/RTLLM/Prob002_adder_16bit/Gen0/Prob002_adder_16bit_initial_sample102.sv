// Define the 8-bit full adder module
module adder_8bit(a, b, Cin, y, Co);
    input [7:0] a, b;
    input Cin;
    output [7:0] y;
    output Co;

    assign {Co, y} = a + b + Cin;
endmodule

// Define the 16-bit full adder module using the 8-bit adder
module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a, b;
    input Cin;
    output [15:0] y;
    output Co;

    wire [7:0] sum_lower;
    wire Co_lower;

    // Lower 8-bit adder
    adder_8bit u_adder_lower(
        .a(a[7:0]), 
        .b(b[7:0]), 
        .Cin(Cin), 
        .y(sum_lower), 
        .Co(Co_lower)
    );

    // Upper 8-bit adder
    adder_8bit u_adder_upper(
        .a(a[15:8]), 
        .b(b[15:8]), 
        .Cin(Co_lower), 
        .y(y[15:8]), 
        .Co(Co)
    );

    // Assign the lower 8 bits of the output
    assign y[7:0] = sum_lower;
endmodule
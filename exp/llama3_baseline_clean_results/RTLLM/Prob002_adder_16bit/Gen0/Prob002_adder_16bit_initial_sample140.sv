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

// Define the 16-bit full adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // Declare wires to connect the 8-bit adders
    wire Co_8;
    
    // Instantiate two 8-bit adders
    adder_8bit u_adder_8bit_0(
        .a(a[7:0]),  // Lower 8 bits of a
        .b(b[7:0]),  // Lower 8 bits of b
        .Cin(Cin),  // Carry-in
        .y(y[7:0]),  // Lower 8 bits of the sum
        .Co(Co_8)    // Carry-out from the lower 8-bit adder
    );
    
    adder_8bit u_adder_8bit_1(
        .a(a[15:8]),  // Upper 8 bits of a
        .b(b[15:8]),  // Upper 8 bits of b
        .Cin(Co_8),   // Carry-in from the lower 8-bit adder
        .y(y[15:8]),  // Upper 8 bits of the sum
        .Co(Co)      // Final carry-out
    );
endmodule
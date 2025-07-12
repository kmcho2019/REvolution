// Define the module for an 8-bit full adder
module adder_8bit(
    input [7:0] a,  // 8-bit input operand A
    input [7:0] b,  // 8-bit input operand B
    input Cin,      // Carry-in input
    output [7:0] y, // 8-bit output representing the sum of A and B
    output Co        // Carry-out output
);
    assign {Co, y} = a + b + Cin;
endmodule

// Define the module for a 16-bit full adder
module adder_16bit(
    input [15:0] a, // 16-bit input operand A
    input [15:0] b, // 16-bit input operand B
    input Cin,      // Carry-in input
    output [15:0] y, // 16-bit output representing the sum of A and B
    output Co        // Carry-out output
);
    wire C1; // Internal carry signal
    adder_8bit u1( // Instance of 8-bit full adder for lower 8 bits
        .a(a[7:0]), 
        .b(b[7:0]), 
        .Cin(Cin), 
        .y(y[7:0]), 
        .Co(C1)
    );
    adder_8bit u2( // Instance of 8-bit full adder for upper 8 bits
        .a(a[15:8]), 
        .b(b[15:8]), 
        .Cin(C1), 
        .y(y[15:8]), 
        .Co(Co)
    );
endmodule
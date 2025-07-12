// Define the module for an 8-bit full adder
module adder_8bit(
    input [7:0] a, 
    input [7:0] b, 
    input Cin, 
    output [7:0] y, 
    output Co
);

    // Internal carry signals
    wire [6:0] carry;

    // Full adder for each bit
    full_adder fa0(a[0], b[0], Cin, y[0], carry[0]);
    full_adder fa1(a[1], b[1], carry[0], y[1], carry[1]);
    full_adder fa2(a[2], b[2], carry[1], y[2], carry[2]);
    full_adder fa3(a[3], b[3], carry[2], y[3], carry[3]);
    full_adder fa4(a[4], b[4], carry[3], y[4], carry[4]);
    full_adder fa5(a[5], b[5], carry[4], y[5], carry[5]);
    full_adder fa6(a[6], b[6], carry[5], y[6], carry[6]);
    full_adder fa7(a[7], b[7], carry[6], y[7], Co);

endmodule

// Define the module for a 1-bit full adder
module full_adder(
    input a, 
    input b, 
    input Cin, 
    output y, 
    output Co
);

    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);

endmodule

// Define the module for a 16-bit full adder using two 8-bit adders
module adder_16bit(
    input [15:0] a, 
    input [15:0] b, 
    input Cin, 
    output [15:0] y, 
    output Co
);

    // Internal carry signal from the lower 8 bits to the upper 8 bits
    wire carry_middle;

    // Instantiate two 8-bit adders
    adder_8bit lower_bits(a[7:0], b[7:0], Cin, y[7:0], carry_middle);
    adder_8bit upper_bits(a[15:8], b[15:8], carry_middle, y[15:8], Co);

endmodule
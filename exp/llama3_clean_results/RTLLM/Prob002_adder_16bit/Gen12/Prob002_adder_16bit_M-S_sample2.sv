// Define the module for a 16-bit full adder
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    // Calculate the sum
    assign {Co, y} = a + b + Cin;

endmodule
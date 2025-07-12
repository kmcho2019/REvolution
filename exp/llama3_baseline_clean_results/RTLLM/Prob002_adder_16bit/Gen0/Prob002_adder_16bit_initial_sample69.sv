// Define the module for an 8-bit full adder
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

// Use the built-in addition operator to calculate the sum
assign {Co, y} = a + b + Cin;

endmodule

// Define the module for a 16-bit full adder
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

// Instantiate two 8-bit adders for the lower and upper 8 bits
wire Cout_lower;
adder_8bit u_adder_lower(
   .a(a[7:0]),
   .b(b[7:0]),
   .Cin(Cin),
   .y(y[7:0]),
   .Co(Cout_lower)
);

adder_8bit u_adder_upper(
   .a(a[15:8]),
   .b(b[15:8]),
   .Cin(Cout_lower),
   .y(y[15:8]),
   .Co(Co)
);

endmodule
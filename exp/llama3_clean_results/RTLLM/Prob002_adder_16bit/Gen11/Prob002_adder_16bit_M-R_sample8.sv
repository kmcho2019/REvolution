// Define the module for an 8-bit full adder
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

// Calculate sum and carry using vector addition
wire [8:0] sum = {Cin, a} + {1'b0, b};

// Assign sum and carry-out
assign y = sum[7:0];
assign Co = sum[8];

endmodule

// Define the module for a 16-bit full adder using two 8-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

// Internal signal for carry from the least significant 8-bit adder
wire carry_8bit;

// Instantiate the least significant 8-bit adder
adder_8bit adder_ls(
   .a(a[7:0]),
   .b(b[7:0]),
   .Cin(Cin),
   .y(y[7:0]),
   .Co(carry_8bit)
);

// Instantiate the most significant 8-bit adder
adder_8bit adder_ms(
   .a(a[15:8]),
   .b(b[15:8]),
   .Cin(carry_8bit),
   .y(y[15:8]),
   .Co(Co)
);

endmodule
// Define the module for a 1-bit full adder
module adder_1bit(
    input a,
    input b,
    input Cin,
    output y,
    output Co
);
    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// Define the module for an 8-bit full adder
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    wire [7:1] carry;
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign carry[1] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);
    for (genvar i = 1; i < 8; i++) begin
        assign y[i] = a[i] ^ b[i] ^ carry[i];
        assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
    end
    assign Co = carry[8];
endmodule

// Define the module for a 16-bit full adder using two 8-bit adders
module adder_16bit(
    input clk,
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry_8bit;
    wire enable;
    assign enable = clk; // clock gating
    adder_8bit adder_ls(
       .a(a[7:0]),
       .b(b[7:0]),
       .Cin(Cin),
       .y(y[7:0]),
       .Co(carry_8bit)
    );
    adder_8bit adder_ms(
       .a(a[15:8]),
       .b(b[15:8]),
       .Cin(carry_8bit),
       .y(y[15:8]),
       .Co(Co)
    );
endmodule
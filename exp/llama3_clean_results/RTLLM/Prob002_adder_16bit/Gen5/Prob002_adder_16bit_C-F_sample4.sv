// Define the module for an 8-bit full adder
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

// Internal signal for carry
wire [7:0] carry;

// First bit (bit 0) adder
assign y[0] = a[0] ^ b[0] ^ Cin;
assign carry[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);

// Bits 1 to 7 adders
genvar i;
generate
    for (i = 1; i < 8; i++) begin
        assign y[i] = a[i] ^ b[i] ^ carry[i-1];
        assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
    end
endgenerate

// Assign Co
assign Co = carry[7];

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
// Define the module for a half adder
module half_adder(
    input a,
    input b,
    output sum,
    output carry
);

assign sum = a ^ b;
assign carry = a & b;

endmodule

// Define the module for a full adder
module full_adder(
    input a,
    input b,
    input Cin,
    output sum,
    output Co
);

wire sum_half, carry_half;

half_adder ha1(
   .a(a),
   .b(b),
   .sum(sum_half),
   .carry(carry_half)
);

half_adder ha2(
   .a(sum_half),
   .b(Cin),
   .sum(sum),
   .carry(Co)
);

assign Co = carry_half | (sum_half & Cin);

endmodule

// Define the module for a 4-bit full adder
module adder_4bit(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);

// Internal signal for carry
wire [2:0] carry;

// First bit (bit 0) adder
full_adder fa0(
   .a(a[0]),
   .b(b[0]),
   .Cin(Cin),
   .sum(y[0]),
   .Co(carry[0])
);

// Bits 1 to 3 adders
genvar i;
generate
    for (i = 1; i < 4; i++) begin
        full_adder fa(
           .a(a[i]),
           .b(b[i]),
           .Cin(carry[i-1]),
           .sum(y[i]),
           .Co(carry[i])
        );
    end
endgenerate

// Assign Co
assign Co = carry[2];

endmodule

// Define the module for a 16-bit full adder using four 4-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

// Internal signal for carry from the least significant 4-bit adder
wire carry_4bit1, carry_4bit2, carry_4bit3;

// Instantiate the least significant 4-bit adder
adder_4bit adder_ls1(
   .a(a[3:0]),
   .b(b[3:0]),
   .Cin(Cin),
   .y(y[3:0]),
   .Co(carry_4bit1)
);

// Instantiate the second 4-bit adder
adder_4bit adder_ls2(
   .a(a[7:4]),
   .b(b[7:4]),
   .Cin(carry_4bit1),
   .y(y[7:4]),
   .Co(carry_4bit2)
);

// Instantiate the third 4-bit adder
adder_4bit adder_ls3(
   .a(a[11:8]),
   .b(b[11:8]),
   .Cin(carry_4bit2),
   .y(y[11:8]),
   .Co(carry_4bit3)
);

// Instantiate the most significant 4-bit adder
adder_4bit adder_ms(
   .a(a[15:12]),
   .b(b[15:12]),
   .Cin(carry_4bit3),
   .y(y[15:12]),
   .Co(Co)
);

endmodule
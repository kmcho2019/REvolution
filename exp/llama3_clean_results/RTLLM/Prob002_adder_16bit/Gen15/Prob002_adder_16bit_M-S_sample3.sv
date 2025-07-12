// Define a basic 1-bit full adder module
module full_adder_1bit(
    input a,
    input b,
    input Cin,
    output Cout,
    output sum
);

assign sum = a ^ b ^ Cin;
assign Cout = (a & b) | (a & Cin) | (b & Cin);

endmodule

// Define an 8-bit full adder module using the 1-bit full adder
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

// Internal signals for carry
wire [7:1] carry;

// Generate block for bits 0 to 7
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        if (i == 0) begin
            // First bit (bit 0) adder
            full_adder_1bit fa0(
                .a(a[i]),
                .b(b[i]),
                .Cin(Cin),
                .Cout(carry[i]),
                .sum(y[i])
            );
        end else begin
            // Bits 1 to 7 adders
            full_adder_1bit fa(
                .a(a[i]),
                .b(b[i]),
                .Cin(carry[i-1]),
                .Cout(carry[i]),
                .sum(y[i])
            );
        end
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
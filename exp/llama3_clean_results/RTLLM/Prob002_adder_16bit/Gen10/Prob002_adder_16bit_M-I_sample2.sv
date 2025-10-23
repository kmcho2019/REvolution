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

// Define the module for an 8-bit full adder using carry-ripple architecture
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

// Internal signals for carry
wire [7:0] carry;

// Instantiate 8 1-bit full adders
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        if (i == 0) begin
            adder_1bit adder(
                .a(a[i]),
                .b(b[i]),
                .Cin(Cin),
                .y(y[i]),
                .Co(carry[i])
            );
        end else begin
            adder_1bit adder(
                .a(a[i]),
                .b(b[i]),
                .Cin(carry[i-1]),
                .y(y[i]),
                .Co(carry[i])
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
// Define the module for an 8-bit full adder
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

// Internal signals for carry
wire [7:0] carry;

// First bit adder
full_adder fa0(a[0], b[0], Cin, y[0], carry[0]);

// Subsequent bit adders
generate
    for (genvar i = 1; i < 8; i++) begin
        full_adder fa(
            .a(a[i]),
            .b(b[i]),
            .Cin(carry[i-1]),
            .y(y[i]),
            .Co(carry[i])
        );
    end
endgenerate

// Last carry-out
assign Co = carry[7];

endmodule

// Define the module for a full adder (1 bit)
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

// Internal signals
wire carry8;

// Lower 8 bits adder
adder_8bit adder_lower(
    .a(a[7:0]),
    .b(b[7:0]),
    .Cin(Cin),
    .y(y[7:0]),
    .Co(carry8)
);

// Upper 8 bits adder
adder_8bit adder_upper(
    .a(a[15:8]),
    .b(b[15:8]),
    .Cin(carry8),
    .y(y[15:8]),
    .Co(Co)
);

endmodule
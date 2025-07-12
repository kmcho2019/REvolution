// Define the module for an 8-bit full adder
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

// Calculate sum and carry using XOR and AND operators
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        assign y[i] = (i == 0) ? a[0] ^ b[0] ^ Cin : a[i] ^ b[i] ^ (i > 0 ? (a[i-1] & b[i-1]) | (a[i-1] & (i > 1 ? (a[i-2] & b[i-2]) | (a[i-2] & (i > 2 ? (a[i-3] & b[i-3]) | (a[i-3] & Cin) | (b[i-3] & Cin) | (a[i-2] & Cin) | (b[i-2] & Cin) : Cin) | (b[i-2] & Cin) | (a[i-1] & Cin) | (b[i-1] & Cin)) : Cin) | (b[i-1] & Cin) : Cin);
        if (i == 7) begin
            assign Co = (a[i] & b[i]) | (a[i] & Cin) | (b[i] & Cin);
        end
    end
endgenerate

endmodule

// Define the module for a 16-bit full adder using two 8-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

// Instantiate the least significant 8-bit adder
adder_8bit adder_ls(
    .a(a[7:0]),
    .b(b[7:0]),
    .Cin(Cin),
    .y(y[7:0]),
    .Co(y[8])
);

// Instantiate the most significant 8-bit adder
adder_8bit adder_ms(
    .a(a[15:8]),
    .b(b[15:8]),
    .Cin(y[8]),
    .y(y[15:9]),
    .Co(Co)
);

endmodule
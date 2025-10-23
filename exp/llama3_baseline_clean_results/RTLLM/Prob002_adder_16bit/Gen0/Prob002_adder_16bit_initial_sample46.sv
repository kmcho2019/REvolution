// Define the module for an 8-bit full adder
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    // Internal carry signals
    wire [6:0] carry;

    // First bit (bit 0) calculation
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign carry[0] = a[0] & b[0] | a[0] & Cin | b[0] & Cin;

    // Bits 1 through 6 calculation
    generate
        for (genvar i = 1; i < 7; i++) begin
            assign y[i] = a[i] ^ b[i] ^ carry[i-1];
            assign carry[i] = a[i] & b[i] | a[i] & carry[i-1] | b[i] & carry[i-1];
        end
    endgenerate

    // Last bit (bit 7) calculation
    assign y[7] = a[7] ^ b[7] ^ carry[6];
    assign Co = a[7] & b[7] | a[7] & carry[6] | b[7] & carry[6];
endmodule

// Define the module for a 16-bit full adder using two 8-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // Internal carry signal from lower 8 bits to upper 8 bits
    wire carry_8bit;

    // Instantiate an 8-bit adder for the lower 8 bits
    adder_8bit u_adder_lower(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_8bit)
    );

    // Instantiate an 8-bit adder for the upper 8 bits
    adder_8bit u_adder_upper(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_8bit),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule
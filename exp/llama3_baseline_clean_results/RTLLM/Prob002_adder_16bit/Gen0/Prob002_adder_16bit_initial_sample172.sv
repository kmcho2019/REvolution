// Define the 8-bit full adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    // Internal signals for carry
    logic [7:0] carry;

    // First bit addition (no carry-in for the first bit)
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign carry[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);

    // Generate carries for subsequent bits using a for loop
    generate
        for (genvar i = 1; i < 8; i++) begin
            assign y[i] = a[i] ^ b[i] ^ carry[i-1];
            assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
        end
    endgenerate

    // Carry-out
    assign Co = carry[7];
endmodule

// Define the 16-bit full adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // Instantiate two 8-bit adders
    logic carry_to_upper_8bits;

    adder_8bit lower_8bit_adder(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_to_upper_8bits)
    );

    adder_8bit upper_8bit_adder(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_to_upper_8bits),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule
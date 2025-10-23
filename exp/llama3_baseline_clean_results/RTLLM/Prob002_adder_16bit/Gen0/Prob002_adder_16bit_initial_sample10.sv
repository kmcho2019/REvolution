// Define the 8-bit adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    // Internal wires for carry
    wire [6:0] c;

    // First bit (LSB) addition
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign c[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);

    // Remaining bits addition
    generate
        for (genvar i = 1; i < 8; i++) begin
            assign y[i] = a[i] ^ b[i] ^ c[i-1];
            assign c[i] = (a[i] & b[i]) | (a[i] & c[i-1]) | (b[i] & c[i-1]);
        end
    endgenerate

    // Carry out
    assign Co = c[7];

endmodule

// Define the 16-bit adder module using two 8-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    // Internal wire for carry between 8-bit adders
    wire c8;

    // Instantiate the first 8-bit adder for the lower bits
    adder_8bit adder_lower(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(c8)
    );

    // Instantiate the second 8-bit adder for the upper bits
    adder_8bit adder_upper(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c8),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule
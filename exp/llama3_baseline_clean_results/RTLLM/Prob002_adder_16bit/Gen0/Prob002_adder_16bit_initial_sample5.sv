// Module for an 8-bit full adder
module adder_8bit(
    input   [7:0]  a,
    input   [7:0]  b,
    input           Cin,
    output  [7:0]  y,
    output          Co
);
    wire    [7:0]  carry;

    // Compute carry for each bit position
    assign carry[0] = Cin;
    assign Co = carry[7];

    // Generate the sum bits and carry signals using full adder logic
    assign y[0] = a[0] ^ b[0] ^ carry[0];
    assign carry[1] = (a[0] & b[0]) | (a[0] & carry[0]) | (b[0] & carry[0]);

    // Repeat for each bit position
    genvar i;
    generate
        for (i = 1; i < 7; i++) begin
            assign y[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
        // Handle the last bit
        assign y[7] = a[7] ^ b[7] ^ carry[7];
    endgenerate
endmodule

// Module for a 16-bit full adder using the 8-bit adder
module adder_16bit(
    input   [15:0] a,
    input   [15:0] b,
    input           Cin,
    output  [15:0] y,
    output          Co
);
    wire    lower_Co;

    // Instance of 8-bit adder for the lower 8 bits
    adder_8bit adder_lower(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(lower_Co)
    );

    // Instance of 8-bit adder for the upper 8 bits
    adder_8bit adder_upper(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(lower_Co),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule
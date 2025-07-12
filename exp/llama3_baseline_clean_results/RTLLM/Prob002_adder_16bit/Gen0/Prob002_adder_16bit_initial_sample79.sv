// Define the 8-bit full adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    // Initialize carry and result
    wire [7:0] carry;
    reg [7:0] result;

    // Compute sum and carry for each bit position
    assign carry[0] = Cin;
    assign y[0] = a[0] ^ b[0] ^ carry[0];
    assign result[0] = (a[0] & b[0]) | (a[0] & carry[0]) | (b[0] & carry[0]);

    // Use full adder logic for remaining bits
    genvar i;
    generate
        for (i = 1; i < 8; i++) begin
            assign carry[i] = (a[i-1] & b[i-1]) | (a[i-1] & carry[i-1]) | (b[i-1] & carry[i-1]);
            assign y[i] = a[i] ^ b[i] ^ carry[i];
            assign result[i] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate

    // Final carry-out
    assign Co = result[7];

endmodule

// Define the 16-bit full adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    // Instantiate two 8-bit full adders
    wire carry_8bit;

    adder_8bit lower_8bit_adder(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_8bit)
    );

    adder_8bit upper_8bit_adder(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_8bit),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule
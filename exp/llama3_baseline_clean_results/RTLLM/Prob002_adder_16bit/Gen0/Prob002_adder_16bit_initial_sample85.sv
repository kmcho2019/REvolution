// 8-bit full adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    wire [7:0] carry;

    // Calculate the sum and carry for each bit position
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign carry[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);

    // For each bit position from 1 to 7
    genvar i;
    generate
        for (i = 1; i < 8; i++) begin
            assign y[i] = a[i] ^ b[i] ^ carry[i-1];
            assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
        end
    endgenerate

    // The final carry-out is the carry from the most significant bit
    assign Co = carry[7];

endmodule

// 16-bit full adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    // Instantiate two 8-bit adders
    wire carry_out_lower;

    adder_8bit lower_adder(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_out_lower)
    );

    adder_8bit upper_adder(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_out_lower),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule
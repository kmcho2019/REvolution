// 8-bit full adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    wire [7:0] carry;
    assign carry[0] = Cin;
    assign y[0] = a[0] ^ b[0] ^ Cin;

    // Ripple carry adder for the remaining bits
    generate
        for (genvar i = 1; i < 8; i++) begin
            assign carry[i] = a[i] & b[i] | a[i] & carry[i-1] | b[i] & carry[i-1];
            assign y[i] = a[i] ^ b[i] ^ carry[i-1];
        end
    endgenerate

    // Carry-out
    assign Co = carry[7];

endmodule

// 16-bit full adder module using two 8-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire Cmid; // Carry from lower 8 bits to upper 8 bits

    // Lower 8 bits
    adder_8bit lower_bits(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(Cmid)
    );

    // Upper 8 bits
    adder_8bit upper_bits(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(Cmid),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule
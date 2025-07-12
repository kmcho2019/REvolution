// Define the 8-bit full adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    wire [6:0] carry;

    // Calculate the sum and carry for each bit position
    full_adder fa0(a[0], b[0], Cin, y[0], carry[0]);
    full_adder fa1(a[1], b[1], carry[0], y[1], carry[1]);
    full_adder fa2(a[2], b[2], carry[1], y[2], carry[2]);
    full_adder fa3(a[3], b[3], carry[2], y[3], carry[3]);
    full_adder fa4(a[4], b[4], carry[3], y[4], carry[4]);
    full_adder fa5(a[5], b[5], carry[4], y[5], carry[5]);
    full_adder fa6(a[6], b[6], carry[5], y[6], carry[6]);
    full_adder fa7(a[7], b[7], carry[6], y[7], Co);

endmodule

// Define the 1-bit full adder module
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

// Define the 16-bit full adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire carry_mid;

    // Instantiate two 8-bit adders to handle the 16-bit input
    adder_8bit adder_low(a[7:0], b[7:0], Cin, y[7:0], carry_mid);
    adder_8bit adder_high(a[15:8], b[15:8], carry_mid, y[15:8], Co);

endmodule
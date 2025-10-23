// Define the 8-bit full adder module
module adder_8bit(
    input   [7:0] a,  // 8-bit input operand A
    input   [7:0] b,  // 8-bit input operand B
    input         Cin,  // Carry-in input
    output  [7:0] y,  // 8-bit output representing the sum of A and B
    output        Co   // Carry-out output
);

    // Internal signals to handle carry propagation
    wire [7:1] carry;

    // Full adder for each bit position
    full_adder fa0(a[0], b[0], Cin, y[0], carry[1]);
    full_adder fa1(a[1], b[1], carry[1], y[1], carry[2]);
    full_adder fa2(a[2], b[2], carry[2], y[2], carry[3]);
    full_adder fa3(a[3], b[3], carry[3], y[3], carry[4]);
    full_adder fa4(a[4], b[4], carry[4], y[4], carry[5]);
    full_adder fa5(a[5], b[5], carry[5], y[5], carry[6]);
    full_adder fa6(a[6], b[6], carry[6], y[6], carry[7]);
    full_adder fa7(a[7], b[7], carry[7], y[7], Co);

endmodule

// Define the full adder for a single bit
module full_adder(
    input   a,  // Input bit A
    input   b,  // Input bit B
    input   Cin,  // Carry-in input
    output  y,  // Output bit representing the sum of A and B
    output  Co   // Carry-out output
);

    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);

endmodule

// Define the 16-bit full adder module
module adder_16bit(
    input   [15:0] a,  // 16-bit input operand A
    input   [15:0] b,  // 16-bit input operand B
    input         Cin,  // Carry-in input
    output  [15:0] y,  // 16-bit output representing the sum of A and B
    output        Co   // Carry-out output
);

    // Instantiate two 8-bit adders
    wire         carry_8bit;
    adder_8bit  adder_lower(a[7:0], b[7:0], Cin, y[7:0], carry_8bit);
    adder_8bit  adder_upper(a[15:8], b[15:8], carry_8bit, y[15:8], Co);

endmodule
// 8-bit full adder module
module adder_8bit(
    input  [7:0] a,  // 8-bit input operand A
    input  [7:0] b,  // 8-bit input operand B
    input        Cin,  // Carry-in input
    output [7:0] y,  // 8-bit output representing the sum of A and B
    output       Co  // Carry-out output
);

    wire [7:0] carry;  // internal carry signals

    // calculate sum and carry for each bit
    fulladder fa0(a[0], b[0], Cin, y[0], carry[0]);
    fulladder fa1(a[1], b[1], carry[0], y[1], carry[1]);
    fulladder fa2(a[2], b[2], carry[1], y[2], carry[2]);
    fulladder fa3(a[3], b[3], carry[2], y[3], carry[3]);
    fulladder fa4(a[4], b[4], carry[3], y[4], carry[4]);
    fulladder fa5(a[5], b[5], carry[4], y[5], carry[5]);
    fulladder fa6(a[6], b[6], carry[5], y[6], carry[6]);
    fulladder fa7(a[7], b[7], carry[6], y[7], carry[7]);

    // assign carry-out output
    assign Co = carry[7];

endmodule

// 1-bit full adder module
module fulladder(
    input  a,  // 1-bit input operand A
    input  b,  // 1-bit input operand B
    input  Cin,  // Carry-in input
    output y,  // 1-bit output representing the sum of A and B
    output Co  // Carry-out output
);

    // calculate sum and carry
    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);

endmodule

// 16-bit full adder module
module adder_16bit(
    input  [15:0] a,  // 16-bit input operand A
    input  [15:0] b,  // 16-bit input operand B
    input        Cin,  // Carry-in input
    output [15:0] y,  // 16-bit output representing the sum of A and B
    output       Co  // Carry-out output
);

    // instantiate 8-bit adder for lower 8 bits
    wire        carry;
    adder_8bit adder_lower(a[7:0], b[7:0], Cin, y[7:0], carry);

    // instantiate 8-bit adder for upper 8 bits
    adder_8bit adder_upper(a[15:8], b[15:8], carry, y[15:8], Co);

endmodule
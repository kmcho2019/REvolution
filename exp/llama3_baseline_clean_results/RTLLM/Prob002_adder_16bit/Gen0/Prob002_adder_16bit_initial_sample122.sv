// Define the 8-bit full adder module
module adder_8bit(a, b, Cin, y, Co);
    input [7:0] a, b;
    input Cin;
    output [7:0] y;
    output Co;

    wire [7:0] a_int, b_int, y_int;
    wire Cin_int, Co_int;

    assign a_int = a;
    assign b_int = b;

    // Perform the addition bit by bit
    full_adder fa0(a_int[0], b_int[0], Cin, y_int[0], Cin_int);
    full_adder fa1(a_int[1], b_int[1], Cin_int, y_int[1], Cin_int);
    full_adder fa2(a_int[2], b_int[2], Cin_int, y_int[2], Cin_int);
    full_adder fa3(a_int[3], b_int[3], Cin_int, y_int[3], Cin_int);
    full_adder fa4(a_int[4], b_int[4], Cin_int, y_int[4], Cin_int);
    full_adder fa5(a_int[5], b_int[5], Cin_int, y_int[5], Cin_int);
    full_adder fa6(a_int[6], b_int[6], Cin_int, y_int[6], Cin_int);
    full_adder fa7(a_int[7], b_int[7], Cin_int, y_int[7], Co_int);

    assign y = y_int;
    assign Co = Co_int;
endmodule

// Define the 1-bit full adder module
module full_adder(a, b, Cin, y, Co);
    input a, b, Cin;
    output y, Co;

    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// Define the 16-bit full adder module
module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a, b;
    input Cin;
    output [15:0] y;
    output Co;

    wire [7:0] a_lo, b_lo, y_lo;
    wire [7:0] a_hi, b_hi, y_hi;
    wire Co_lo;

    assign a_lo = a[7:0];
    assign b_lo = b[7:0];
    assign a_hi = a[15:8];
    assign b_hi = b[15:8];

    adder_8bit adder_lo(a_lo, b_lo, Cin, y_lo, Co_lo);
    adder_8bit adder_hi(a_hi, b_hi, Co_lo, y_hi, Co);

    assign y[7:0] = y_lo;
    assign y[15:8] = y_hi;
endmodule
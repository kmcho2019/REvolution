// 1-bit full adder module
module full_adder(a, b, Cin, S, Cout);
    input a, b, Cin;
    output S, Cout;
    assign S = a ^ b ^ Cin;
    assign Cout = (a & b) | (a & Cin) | (b & Cin);
endmodule

// 8-bit adder module using 1-bit full adders
module adder_8bit(a, b, Cin, y, Cout);
    input [7:0] a, b;
    input Cin;
    output [7:0] y;
    output Cout;
    wire [7:0] carry;
    assign carry[0] = Cin;
    full_adder fa0(a[0], b[0], carry[0], y[0], carry[1]);
    full_adder fa1(a[1], b[1], carry[1], y[1], carry[2]);
    full_adder fa2(a[2], b[2], carry[2], y[2], carry[3]);
    full_adder fa3(a[3], b[3], carry[3], y[3], carry[4]);
    full_adder fa4(a[4], b[4], carry[4], y[4], carry[5]);
    full_adder fa5(a[5], b[5], carry[5], y[5], carry[6]);
    full_adder fa6(a[6], b[6], carry[6], y[6], carry[7]);
    full_adder fa7(a[7], b[7], carry[7], y[7], Cout);
endmodule

// 16-bit adder module using two 8-bit adders
module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a, b;
    input Cin;
    output [15:0] y;
    output Co;
    wire Cout_8bit;
    adder_8bit adder_low(a[7:0], b[7:0], Cin, y[7:0], Cout_8bit);
    adder_8bit adder_high(a[15:8], b[15:8], Cout_8bit, y[15:8], Co);
endmodule
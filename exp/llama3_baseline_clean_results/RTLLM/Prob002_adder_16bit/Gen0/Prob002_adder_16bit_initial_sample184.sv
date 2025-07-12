// Module for a 1-bit full adder
module full_adder_1bit(
    input a,
    input b,
    input Cin,
    output reg sum,
    output reg Cout
);
    always @(*) begin
        sum = a ^ b ^ Cin;
        Cout = (a & b) | (a & Cin) | (b & Cin);
    end
endmodule

// Module for an 8-bit adder using the 1-bit full adder
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    wire [7:0] carry;
    assign carry[0] = Cin;

    full_adder_1bit fa0(a[0], b[0], Cin, y[0], carry[1]);
    full_adder_1bit fa1(a[1], b[1], carry[1], y[1], carry[2]);
    full_adder_1bit fa2(a[2], b[2], carry[2], y[2], carry[3]);
    full_adder_1bit fa3(a[3], b[3], carry[3], y[3], carry[4]);
    full_adder_1bit fa4(a[4], b[4], carry[4], y[4], carry[5]);
    full_adder_1bit fa5(a[5], b[5], carry[5], y[5], carry[6]);
    full_adder_1bit fa6(a[6], b[6], carry[6], y[6], carry[7]);
    full_adder_1bit fa7(a[7], b[7], carry[7], y[7], Co);
endmodule

// Module for a 16-bit adder using two 8-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire Cmid;
    adder_8bit adderLow(a[7:0], b[7:0], Cin, y[7:0], Cmid);
    adder_8bit adderHigh(a[15:8], b[15:8], Cmid, y[15:8], Co);
endmodule
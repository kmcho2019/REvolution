// 1-bit full adder
module adder_1bit(
    input a,
    input b,
    input Cin,
    output sum,
    output Co
);
    assign sum = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// 8-bit full adder
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    wire [7:0] carry;
    
    assign carry[0] = Cin;
    adder_1bit adder0(a[0], b[0], carry[0], y[0], carry[1]);
    adder_1bit adder1(a[1], b[1], carry[1], y[1], carry[2]);
    adder_1bit adder2(a[2], b[2], carry[2], y[2], carry[3]);
    adder_1bit adder3(a[3], b[3], carry[3], y[3], carry[4]);
    adder_1bit adder4(a[4], b[4], carry[4], y[4], carry[5]);
    adder_1bit adder5(a[5], b[5], carry[5], y[5], carry[6]);
    adder_1bit adder6(a[6], b[6], carry[6], y[6], carry[7]);
    adder_1bit adder7(a[7], b[7], carry[7], y[7], Co);
endmodule

// 16-bit full adder
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire Co8;
    
    adder_8bit adderLow(a[7:0], b[7:0], Cin, y[7:0], Co8);
    adder_8bit adderHigh(a[15:8], b[15:8], Co8, y[15:8], Co);
endmodule
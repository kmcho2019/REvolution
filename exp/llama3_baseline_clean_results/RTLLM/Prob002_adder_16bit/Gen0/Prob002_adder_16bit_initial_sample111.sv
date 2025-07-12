// Full Adder (FA) module
module FA(a, b, Cin, sum, Cout);
    input a, b, Cin;
    output sum, Cout;
    
    assign sum = a ^ b ^ Cin;
    assign Cout = (a & b) | (a & Cin) | (b & Cin);
endmodule

// 8-bit full adder module
module adder_8bit(a, b, Cin, y, Co);
    input [7:0] a;
    input [7:0] b;
    input Cin;
    output [7:0] y;
    output Co;
    
    wire [7:0] carry;
    
    // Instantiate FA modules
    FA fa0(a[0], b[0], Cin, y[0], carry[0]);
    FA fa1(a[1], b[1], carry[0], y[1], carry[1]);
    FA fa2(a[2], b[2], carry[1], y[2], carry[2]);
    FA fa3(a[3], b[3], carry[2], y[3], carry[3]);
    FA fa4(a[4], b[4], carry[3], y[4], carry[4]);
    FA fa5(a[5], b[5], carry[4], y[5], carry[5]);
    FA fa6(a[6], b[6], carry[5], y[6], carry[6]);
    FA fa7(a[7], b[7], carry[6], y[7], carry[7]);
    
    assign Co = carry[7];
endmodule

// 16-bit full adder module
module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a;
    input [15:0] b;
    input Cin;
    output [15:0] y;
    output Co;
    
    wire Co_8bit;
    
    // Instantiate 8-bit adder modules
    adder_8bit adder_8bit_0(a[7:0], b[7:0], Cin, y[7:0], Co_8bit);
    adder_8bit adder_8bit_1(a[15:8], b[15:8], Co_8bit, y[15:8], Co);
endmodule
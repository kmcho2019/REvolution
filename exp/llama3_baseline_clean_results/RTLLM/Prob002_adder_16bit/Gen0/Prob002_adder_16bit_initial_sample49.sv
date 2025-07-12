// Full adder cell module
module full_adder(a, b, Cin, y, Co);
    input a, b, Cin;
    output y, Co;
    
    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// 8-bit adder module
module adder_8bit(a, b, Cin, y, Co);
    input [7:0] a;
    input [7:0] b;
    input Cin;
    output [7:0] y;
    output Co;
    
    wire [7:0] carry;
    
    assign carry[0] = Cin;
    full_adder fa0(a[0], b[0], carry[0], y[0], carry[1]);
    full_adder fa1(a[1], b[1], carry[1], y[1], carry[2]);
    full_adder fa2(a[2], b[2], carry[2], y[2], carry[3]);
    full_adder fa3(a[3], b[3], carry[3], y[3], carry[4]);
    full_adder fa4(a[4], b[4], carry[4], y[4], carry[5]);
    full_adder fa5(a[5], b[5], carry[5], y[5], carry[6]);
    full_adder fa6(a[6], b[6], carry[6], y[6], carry[7]);
    full_adder fa7(a[7], b[7], carry[7], y[7], Co);
endmodule

// 16-bit adder module
module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a;
    input [15:0] b;
    input Cin;
    output [15:0] y;
    output Co;
    
    wire Cmid;
    
    adder_8bit adder_lo(a[7:0], b[7:0], Cin, y[7:0], Cmid);
    adder_8bit adder_hi(a[15:8], b[15:8], Cmid, y[15:8], Co);
endmodule
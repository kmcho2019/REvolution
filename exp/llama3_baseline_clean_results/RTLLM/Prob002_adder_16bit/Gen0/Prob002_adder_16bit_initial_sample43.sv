module adder_8bit(a, b, Cin, y, Co);
    input [7:0] a, b;
    input Cin;
    output [7:0] y;
    output Co;
    
    wire [7:0] y_temp;
    wire [7:0] carry;
    
    full_adder fa0(a[0], b[0], Cin, y_temp[0], carry[0]);
    full_adder fa1(a[1], b[1], carry[0], y_temp[1], carry[1]);
    full_adder fa2(a[2], b[2], carry[1], y_temp[2], carry[2]);
    full_adder fa3(a[3], b[3], carry[2], y_temp[3], carry[3]);
    full_adder fa4(a[4], b[4], carry[3], y_temp[4], carry[4]);
    full_adder fa5(a[5], b[5], carry[4], y_temp[5], carry[5]);
    full_adder fa6(a[6], b[6], carry[5], y_temp[6], carry[6]);
    full_adder fa7(a[7], b[7], carry[6], y_temp[7], carry[7]);
    
    assign y = y_temp;
    assign Co = carry[7];
endmodule

module full_adder(a, b, Cin, y, Co);
    input a, b, Cin;
    output y, Co;
    
    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a, b;
    input Cin;
    output [15:0] y;
    output Co;
    
    wire C1;
    
    adder_8bit adder0(a[7:0], b[7:0], Cin, y[7:0], C1);
    adder_8bit adder1(a[15:8], b[15:8], C1, y[15:8], Co);
endmodule
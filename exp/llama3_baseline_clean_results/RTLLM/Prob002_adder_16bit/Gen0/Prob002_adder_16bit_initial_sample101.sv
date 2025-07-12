// Basic full adder cell
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
    
    wire [7:1] carry;
    
    full_adder fa0(a[0], b[0], Cin, y[0], carry[1]);
    generate
        for (genvar i = 1; i < 8; i++) begin
            full_adder fa(a[i], b[i], carry[i], y[i], carry[i+1]);
        end
    endgenerate
    assign Co = carry[8];
endmodule

// 16-bit adder module using two 8-bit adders
module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a;
    input [15:0] b;
    input Cin;
    output [15:0] y;
    output Co;
    
    wire carry;
    
    adder_8bit adder_low(a[7:0], b[7:0], Cin, y[7:0], carry);
    adder_8bit adder_high(a[15:8], b[15:8], carry, y[15:8], Co);
endmodule
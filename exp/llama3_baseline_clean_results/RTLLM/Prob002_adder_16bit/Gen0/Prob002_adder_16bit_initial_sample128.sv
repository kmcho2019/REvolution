// Define a 1-bit full adder
module full_adder(a, b, Cin, y, Co);
    input a, b, Cin;
    output y, Co;
    
    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// Define an 8-bit adder using the 1-bit full adder
module adder_8bit(a, b, Cin, y, Co);
    input [7:0] a, b;
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
    full_adder fa7(a[7], b[7], carry[7], y[7], Co);
endmodule

// Define the 16-bit adder using two 8-bit adders
module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a, b;
    input Cin;
    output [15:0] y;
    output Co;
    
    wire Co_8bit;
    
    adder_8bit adder_low(a[7:0], b[7:0], Cin, y[7:0], Co_8bit);
    adder_8bit adder_high(a[15:8], b[15:8], Co_8bit, y[15:8], Co);
endmodule
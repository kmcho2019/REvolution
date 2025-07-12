module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    // Combined carry and sum calculation
    assign y[0] = a[0] ^ b[0] ^ Cin;
    wire c1 = (a[0] & b[0]) | ((a[0] | b[0]) & Cin);
    
    assign y[1] = a[1] ^ b[1] ^ c1;
    wire c2 = (a[1] & b[1]) | ((a[1] | b[1]) & c1);
    
    assign y[2] = a[2] ^ b[2] ^ c2;
    wire c3 = (a[2] & b[2]) | ((a[2] | b[2]) & c2);
    
    assign y[3] = a[3] ^ b[3] ^ c3;
    wire c4 = (a[3] & b[3]) | ((a[3] | b[3]) & c3);
    
    assign y[4] = a[4] ^ b[4] ^ c4;
    wire c5 = (a[4] & b[4]) | ((a[4] | b[4]) & c4);
    
    assign y[5] = a[5] ^ b[5] ^ c5;
    wire c6 = (a[5] & b[5]) | ((a[5] | b[5]) & c5);
    
    assign y[6] = a[6] ^ b[6] ^ c6;
    wire c7 = (a[6] & b[6]) | ((a[6] | b[6]) & c6);
    
    assign y[7] = a[7] ^ b[7] ^ c7;
    assign Co = (a[7] & b[7]) | ((a[7] | b[7]) & c7);
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry_middle;
    
    adder_8bit adder_low (a[7:0], b[7:0], Cin, y[7:0], carry_middle);
    adder_8bit adder_high (a[15:8], b[15:8], carry_middle, y[15:8], Co);
endmodule
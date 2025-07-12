module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    // Explicit carry chain wiring
    wire c1, c2, c3, c4, c5, c6, c7, c8;
    
    // Bit 0
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign c1 = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);
    
    // Bit 1
    assign y[1] = a[1] ^ b[1] ^ c1;
    assign c2 = (a[1] & b[1]) | (a[1] & c1) | (b[1] & c1);
    
    // Bit 2
    assign y[2] = a[2] ^ b[2] ^ c2;
    assign c3 = (a[2] & b[2]) | (a[2] & c2) | (b[2] & c2);
    
    // Bit 3
    assign y[3] = a[3] ^ b[3] ^ c3;
    assign c4 = (a[3] & b[3]) | (a[3] & c3) | (b[3] & c3);
    
    // Bit 4
    assign y[4] = a[4] ^ b[4] ^ c4;
    assign c5 = (a[4] & b[4]) | (a[4] & c4) | (b[4] & c4);
    
    // Bit 5
    assign y[5] = a[5] ^ b[5] ^ c5;
    assign c6 = (a[5] & b[5]) | (a[5] & c5) | (b[5] & c5);
    
    // Bit 6
    assign y[6] = a[6] ^ b[6] ^ c6;
    assign c7 = (a[6] & b[6]) | (a[6] & c6) | (b[6] & c6);
    
    // Bit 7
    assign y[7] = a[7] ^ b[7] ^ c7;
    assign Co = (a[7] & b[7]) | (a[7] & c7) | (b[7] & c7);
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire low_to_high_carry;  // Explicitly named intermediate carry
    
    // Lower 8 bits
    adder_8bit adder_low (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(low_to_high_carry)
    );
    
    // Upper 8 bits
    adder_8bit adder_high (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(low_to_high_carry),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule
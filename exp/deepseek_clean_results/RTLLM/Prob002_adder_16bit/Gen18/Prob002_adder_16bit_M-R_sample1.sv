module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    // Carry signals for each bit position
    wire c1, c2, c3, c4, c5, c6, c7, c8;
    
    // Bit 0
    assign c1 = (a[0] & b[0]) | ((a[0] | b[0]) & cin);
    assign sum[0] = a[0] ^ b[0] ^ cin;
    
    // Bit 1
    assign c2 = (a[1] & b[1]) | ((a[1] | b[1]) & c1);
    assign sum[1] = a[1] ^ b[1] ^ c1;
    
    // Bit 2
    assign c3 = (a[2] & b[2]) | ((a[2] | b[2]) & c2);
    assign sum[2] = a[2] ^ b[2] ^ c2;
    
    // Bit 3
    assign c4 = (a[3] & b[3]) | ((a[3] | b[3]) & c3);
    assign sum[3] = a[3] ^ b[3] ^ c3;
    
    // Bit 4
    assign c5 = (a[4] & b[4]) | ((a[4] | b[4]) & c4);
    assign sum[4] = a[4] ^ b[4] ^ c4;
    
    // Bit 5
    assign c6 = (a[5] & b[5]) | ((a[5] | b[5]) & c5);
    assign sum[5] = a[5] ^ b[5] ^ c5;
    
    // Bit 6
    assign c7 = (a[6] & b[6]) | ((a[6] | b[6]) & c6);
    assign sum[6] = a[6] ^ b[6] ^ c6;
    
    // Bit 7
    assign c8 = (a[7] & b[7]) | ((a[7] | b[7]) & c7);
    assign sum[7] = a[7] ^ b[7] ^ c7;
    
    // Final carry out
    assign cout = c8;
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry_middle;
    
    adder_8bit adder_low (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(Cin),
        .sum(y[7:0]),
        .cout(carry_middle)
    );
    
    adder_8bit adder_high (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(carry_middle),
        .sum(y[15:8]),
        .cout(Co)
    );
endmodule
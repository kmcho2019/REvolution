module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Carry signals between bit positions
    wire c0, c1, c2, c3, c4, c5, c6, c7;
    
    // Bit 0 adder
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign c0 = (a[0] & b[0]) | (cin & (a[0] | b[0]));
    
    // Bit 1 adder
    assign sum[1] = a[1] ^ b[1] ^ c0;
    assign c1 = (a[1] & b[1]) | (c0 & (a[1] | b[1]));
    
    // Bit 2 adder
    assign sum[2] = a[2] ^ b[2] ^ c1;
    assign c2 = (a[2] & b[2]) | (c1 & (a[2] | b[2]));
    
    // Bit 3 adder
    assign sum[3] = a[3] ^ b[3] ^ c2;
    assign c3 = (a[3] & b[3]) | (c2 & (a[3] | b[3]));
    
    // Bit 4 adder
    assign sum[4] = a[4] ^ b[4] ^ c3;
    assign c4 = (a[4] & b[4]) | (c3 & (a[4] | b[4]));
    
    // Bit 5 adder
    assign sum[5] = a[5] ^ b[5] ^ c4;
    assign c5 = (a[5] & b[5]) | (c4 & (a[5] | b[5]));
    
    // Bit 6 adder
    assign sum[6] = a[6] ^ b[6] ^ c5;
    assign c6 = (a[6] & b[6]) | (c5 & (a[6] | b[6]));
    
    // Bit 7 adder
    assign sum[7] = a[7] ^ b[7] ^ c6;
    assign c7 = (a[7] & b[7]) | (c6 & (a[7] | b[7]));
    
    // Final carry out
    assign cout = c7;

endmodule
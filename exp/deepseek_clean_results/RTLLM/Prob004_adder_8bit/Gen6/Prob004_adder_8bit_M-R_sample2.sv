module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Explicit carry signals between stages
    wire carry0, carry1, carry2, carry3, carry4, carry5, carry6, carry7;
    
    // Bit 0 adder
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign carry0 = (a[0] & b[0]) | (cin & (a[0] | b[0]));
    
    // Bit 1 adder
    assign sum[1] = a[1] ^ b[1] ^ carry0;
    assign carry1 = (a[1] & b[1]) | (carry0 & (a[1] | b[1]));
    
    // Bit 2 adder
    assign sum[2] = a[2] ^ b[2] ^ carry1;
    assign carry2 = (a[2] & b[2]) | (carry1 & (a[2] | b[2]));
    
    // Bit 3 adder
    assign sum[3] = a[3] ^ b[3] ^ carry2;
    assign carry3 = (a[3] & b[3]) | (carry2 & (a[3] | b[3]));
    
    // Bit 4 adder
    assign sum[4] = a[4] ^ b[4] ^ carry3;
    assign carry4 = (a[4] & b[4]) | (carry3 & (a[4] | b[4]));
    
    // Bit 5 adder
    assign sum[5] = a[5] ^ b[5] ^ carry4;
    assign carry5 = (a[5] & b[5]) | (carry4 & (a[5] | b[5]));
    
    // Bit 6 adder
    assign sum[6] = a[6] ^ b[6] ^ carry5;
    assign carry6 = (a[6] & b[6]) | (carry5 & (a[6] | b[6]));
    
    // Bit 7 adder
    assign sum[7] = a[7] ^ b[7] ^ carry6;
    assign carry7 = (a[7] & b[7]) | (carry6 & (a[7] | b[7]));
    
    // Final carry out
    assign cout = carry7;

endmodule
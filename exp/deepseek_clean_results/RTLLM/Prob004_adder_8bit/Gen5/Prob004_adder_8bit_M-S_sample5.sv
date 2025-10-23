module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [8:0] c;
    assign c[0] = cin;
    
    assign sum[0] = a[0] ^ b[0] ^ c[0];
    assign c[1] = (a[0] & b[0]) | (c[0] & (a[0] | b[0]));
    
    assign sum[1] = a[1] ^ b[1] ^ c[1];
    assign c[2] = (a[1] & b[1]) | (c[1] & (a[1] | b[1]));
    
    assign sum[2] = a[2] ^ b[2] ^ c[2];
    assign c[3] = (a[2] & b[2]) | (c[2] & (a[2] | b[2]));
    
    assign sum[3] = a[3] ^ b[3] ^ c[3];
    assign c[4] = (a[3] & b[3]) | (c[3] & (a[3] | b[3]));
    
    assign sum[4] = a[4] ^ b[4] ^ c[4];
    assign c[5] = (a[4] & b[4]) | (c[4] & (a[4] | b[4]));
    
    assign sum[5] = a[5] ^ b[5] ^ c[5];
    assign c[6] = (a[5] & b[5]) | (c[5] & (a[5] | b[5]));
    
    assign sum[6] = a[6] ^ b[6] ^ c[6];
    assign c[7] = (a[6] & b[6]) | (c[6] & (a[6] | b[6]));
    
    assign sum[7] = a[7] ^ b[7] ^ c[7];
    assign c[8] = (a[7] & b[7]) | (c[7] & (a[7] | b[7]));
    
    assign cout = c[8];
    
endmodule
module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire carry;  // Propagating carry through all bits
    
    // Bit 0
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign carry = (a[0] & b[0]) | (cin & (a[0] | b[0]));
    
    // Bit 1
    assign sum[1] = a[1] ^ b[1] ^ carry;
    assign carry = (a[1] & b[1]) | (carry & (a[1] | b[1]));
    
    // Bit 2
    assign sum[2] = a[2] ^ b[2] ^ carry;
    assign carry = (a[2] & b[2]) | (carry & (a[2] | b[2]));
    
    // Bit 3
    assign sum[3] = a[3] ^ b[3] ^ carry;
    assign carry = (a[3] & b[3]) | (carry & (a[3] | b[3]));
    
    // Bit 4
    assign sum[4] = a[4] ^ b[4] ^ carry;
    assign carry = (a[4] & b[4]) | (carry & (a[4] | b[4]));
    
    // Bit 5
    assign sum[5] = a[5] ^ b[5] ^ carry;
    assign carry = (a[5] & b[5]) | (carry & (a[5] | b[5]));
    
    // Bit 6
    assign sum[6] = a[6] ^ b[6] ^ carry;
    assign carry = (a[6] & b[6]) | (carry & (a[6] | b[6]));
    
    // Bit 7 (final carry becomes cout)
    assign sum[7] = a[7] ^ b[7] ^ carry;
    assign cout = (a[7] & b[7]) | (carry & (a[7] | b[7]));

endmodule
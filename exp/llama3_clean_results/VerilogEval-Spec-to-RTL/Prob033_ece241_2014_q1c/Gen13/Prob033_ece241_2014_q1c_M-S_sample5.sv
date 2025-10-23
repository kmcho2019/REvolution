module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    wire carry;

    assign s[0] = a[0] ^ b[0];
    assign carry = a[0] & b[0];

    assign s[1] = a[1] ^ b[1] ^ carry;
    assign carry = (a[1] & b[1]) | (a[1] & carry) | (b[1] & carry);

    assign s[2] = a[2] ^ b[2] ^ carry;
    assign carry = (a[2] & b[2]) | (a[2] & carry) | (b[2] & carry);

    assign s[3] = a[3] ^ b[3] ^ carry;
    assign carry = (a[3] & b[3]) | (a[3] & carry) | (b[3] & carry);

    assign s[4] = a[4] ^ b[4] ^ carry;
    assign carry = (a[4] & b[4]) | (a[4] & carry) | (b[4] & carry);

    assign s[5] = a[5] ^ b[5] ^ carry;
    assign carry = (a[5] & b[5]) | (a[5] & carry) | (b[5] & carry);

    assign s[6] = a[6] ^ b[6] ^ carry;
    assign carry = (a[6] & b[6]) | (a[6] & carry) | (b[6] & carry);

    assign s[7] = a[7] ^ b[7] ^ carry;
    assign overflow = (a[7] == b[7] && a[7]!= s[7]);

endmodule
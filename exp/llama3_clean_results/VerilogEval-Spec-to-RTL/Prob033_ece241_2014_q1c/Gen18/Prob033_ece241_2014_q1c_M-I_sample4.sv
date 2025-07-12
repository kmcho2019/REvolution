module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    wire carry;
    assign s[0] = a[0] ^ b[0];
    assign carry = a[0] & b[0];

    wire [6:0] carries;
    assign s[1] = a[1] ^ b[1] ^ carry;
    assign carries[0] = (a[1] & b[1]) | (a[1] & carry) | (b[1] & carry);

    // Implementing a simple ripple-carry adder for the rest
    assign s[2] = a[2] ^ b[2] ^ carries[0];
    assign carries[1] = (a[2] & b[2]) | (a[2] & carries[0]) | (b[2] & carries[0]);

    assign s[3] = a[3] ^ b[3] ^ carries[1];
    assign carries[2] = (a[3] & b[3]) | (a[3] & carries[1]) | (b[3] & carries[1]);

    assign s[4] = a[4] ^ b[4] ^ carries[2];
    assign carries[3] = (a[4] & b[4]) | (a[4] & carries[2]) | (b[4] & carries[2]);

    assign s[5] = a[5] ^ b[5] ^ carries[3];
    assign carries[4] = (a[5] & b[5]) | (a[5] & carries[3]) | (b[5] & carries[3]);

    assign s[6] = a[6] ^ b[6] ^ carries[4];
    assign carries[5] = (a[6] & b[6]) | (a[6] & carries[4]) | (b[6] & carries[4]);

    assign s[7] = a[7] ^ b[7] ^ carries[5];

    // Overflow detection logic integrated directly
    assign overflow = (a[7] == b[7] && a[7] != s[7]);

endmodule
module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Bit 0
    assign sum[0] = a[0] ^ b[0] ^ cin;
    wire c0 = (a[0] & b[0]) | (cin & (a[0] | b[0]));

    // Bit 1
    assign sum[1] = a[1] ^ b[1] ^ c0;
    wire c1 = (a[1] & b[1]) | (c0 & (a[1] | b[1]));

    // Bit 2
    assign sum[2] = a[2] ^ b[2] ^ c1;
    wire c2 = (a[2] & b[2]) | (c1 & (a[2] | b[2]));

    // Bit 3
    assign sum[3] = a[3] ^ b[3] ^ c2;
    wire c3 = (a[3] & b[3]) | (c2 & (a[3] | b[3]));

    // Bit 4
    assign sum[4] = a[4] ^ b[4] ^ c3;
    wire c4 = (a[4] & b[4]) | (c3 & (a[4] | b[4]));

    // Bit 5
    assign sum[5] = a[5] ^ b[5] ^ c4;
    wire c5 = (a[5] & b[5]) | (c4 & (a[5] | b[5]));

    // Bit 6
    assign sum[6] = a[6] ^ b[6] ^ c5;
    wire c6 = (a[6] & b[6]) | (c5 & (a[6] | b[6]));

    // Bit 7
    assign sum[7] = a[7] ^ b[7] ^ c6;
    assign cout = (a[7] & b[7]) | (c6 & (a[7] | b[7]));

endmodule
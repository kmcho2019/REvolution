module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire c1, c2, c3, c4, c5, c6, c7;

    // Bit 0 sum and carry
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign c1     = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);

    // Bit 1 sum and carry
    assign sum[1] = a[1] ^ b[1] ^ c1;
    assign c2     = (a[1] & b[1]) | (a[1] & c1) | (b[1] & c1);

    // Bit 2 sum and carry
    assign sum[2] = a[2] ^ b[2] ^ c2;
    assign c3     = (a[2] & b[2]) | (a[2] & c2) | (b[2] & c2);

    // Bit 3 sum and carry
    assign sum[3] = a[3] ^ b[3] ^ c3;
    assign c4     = (a[3] & b[3]) | (a[3] & c3) | (b[3] & c3);

    // Bit 4 sum and carry
    assign sum[4] = a[4] ^ b[4] ^ c4;
    assign c5     = (a[4] & b[4]) | (a[4] & c4) | (b[4] & c4);

    // Bit 5 sum and carry
    assign sum[5] = a[5] ^ b[5] ^ c5;
    assign c6     = (a[5] & b[5]) | (a[5] & c5) | (b[5] & c5);

    // Bit 6 sum and carry
    assign sum[6] = a[6] ^ b[6] ^ c6;
    assign c7     = (a[6] & b[6]) | (a[6] & c6) | (b[6] & c6);

    // Bit 7 sum and carry out
    assign sum[7] = a[7] ^ b[7] ^ c7;
    assign cout   = (a[7] & b[7]) | (a[7] & c7) | (b[7] & c7);

endmodule
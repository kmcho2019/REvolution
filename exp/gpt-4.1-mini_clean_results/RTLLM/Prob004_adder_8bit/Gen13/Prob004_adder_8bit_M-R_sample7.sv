module adder_8bit (
    input  wire [7:0] a,    // 8-bit operand A
    input  wire [7:0] b,    // 8-bit operand B
    input  wire       cin,  // carry-in input
    output wire [7:0] sum,  // 8-bit sum output
    output wire       cout  // carry-out output
);
    // Internal carry signals between bits
    wire [7:0] carry;

    // Bit 0 sum and carry
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign carry[0] = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);

    // Bit 1 sum and carry
    assign sum[1] = a[1] ^ b[1] ^ carry[0];
    assign carry[1] = (a[1] & b[1]) | (a[1] & carry[0]) | (b[1] & carry[0]);

    // Bit 2 sum and carry
    assign sum[2] = a[2] ^ b[2] ^ carry[1];
    assign carry[2] = (a[2] & b[2]) | (a[2] & carry[1]) | (b[2] & carry[1]);

    // Bit 3 sum and carry
    assign sum[3] = a[3] ^ b[3] ^ carry[2];
    assign carry[3] = (a[3] & b[3]) | (a[3] & carry[2]) | (b[3] & carry[2]);

    // Bit 4 sum and carry
    assign sum[4] = a[4] ^ b[4] ^ carry[3];
    assign carry[4] = (a[4] & b[4]) | (a[4] & carry[3]) | (b[4] & carry[3]);

    // Bit 5 sum and carry
    assign sum[5] = a[5] ^ b[5] ^ carry[4];
    assign carry[5] = (a[5] & b[5]) | (a[5] & carry[4]) | (b[5] & carry[4]);

    // Bit 6 sum and carry
    assign sum[6] = a[6] ^ b[6] ^ carry[5];
    assign carry[6] = (a[6] & b[6]) | (a[6] & carry[5]) | (b[6] & carry[5]);

    // Bit 7 sum and carry-out
    assign sum[7] = a[7] ^ b[7] ^ carry[6];
    assign cout = (a[7] & b[7]) | (a[7] & carry[6]) | (b[7] & carry[6]);

endmodule
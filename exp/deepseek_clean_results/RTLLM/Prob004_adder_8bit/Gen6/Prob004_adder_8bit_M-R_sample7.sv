module adder_8bit #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input cin,
    output [WIDTH-1:0] sum,
    output cout
);

    // Explicit carry signals between bits
    wire carry_bit0_bit1;
    wire carry_bit1_bit2;
    wire carry_bit2_bit3;
    wire carry_bit3_bit4;
    wire carry_bit4_bit5;
    wire carry_bit5_bit6;
    wire carry_bit6_bit7;
    wire carry_bit7_cout;

    // Bit 0 adder
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign carry_bit0_bit1 = (a[0] & b[0]) | (cin & (a[0] | b[0]));

    // Bit 1 adder
    assign sum[1] = a[1] ^ b[1] ^ carry_bit0_bit1;
    assign carry_bit1_bit2 = (a[1] & b[1]) | (carry_bit0_bit1 & (a[1] | b[1]));

    // Bit 2 adder
    assign sum[2] = a[2] ^ b[2] ^ carry_bit1_bit2;
    assign carry_bit2_bit3 = (a[2] & b[2]) | (carry_bit1_bit2 & (a[2] | b[2]));

    // Bit 3 adder
    assign sum[3] = a[3] ^ b[3] ^ carry_bit2_bit3;
    assign carry_bit3_bit4 = (a[3] & b[3]) | (carry_bit2_bit3 & (a[3] | b[3]));

    // Bit 4 adder
    assign sum[4] = a[4] ^ b[4] ^ carry_bit3_bit4;
    assign carry_bit4_bit5 = (a[4] & b[4]) | (carry_bit3_bit4 & (a[4] | b[4]));

    // Bit 5 adder
    assign sum[5] = a[5] ^ b[5] ^ carry_bit4_bit5;
    assign carry_bit5_bit6 = (a[5] & b[5]) | (carry_bit4_bit5 & (a[5] | b[5]));

    // Bit 6 adder
    assign sum[6] = a[6] ^ b[6] ^ carry_bit5_bit6;
    assign carry_bit6_bit7 = (a[6] & b[6]) | (carry_bit5_bit6 & (a[6] | b[6]));

    // Bit 7 adder
    assign sum[7] = a[7] ^ b[7] ^ carry_bit6_bit7;
    assign carry_bit7_cout = (a[7] & b[7]) | (carry_bit6_bit7 & (a[7] | b[7]));

    // Final carry out
    assign cout = carry_bit7_cout;

endmodule
module adder_8bit(a, b, Cin, y, Co);
    input [7:0] a;
    input [7:0] b;
    input Cin;
    output [7:0] y;
    output Co;

    wire [7:0] sum;
    wire C1, C2, C3, C4, C5, C6, C7;

    // Calculate sum and carry for each bit
    full_adder fa0(a[0], b[0], Cin, sum[0], C1);
    full_adder fa1(a[1], b[1], C1, sum[1], C2);
    full_adder fa2(a[2], b[2], C2, sum[2], C3);
    full_adder fa3(a[3], b[3], C3, sum[3], C4);
    full_adder fa4(a[4], b[4], C4, sum[4], C5);
    full_adder fa5(a[5], b[5], C5, sum[5], C6);
    full_adder fa6(a[6], b[6], C6, sum[6], C7);
    full_adder fa7(a[7], b[7], C7, sum[7], Co);

    assign y = sum;
endmodule

module full_adder(a, b, Cin, sum, Co);
    input a, b, Cin;
    output sum, Co;

    assign sum = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a;
    input [15:0] b;
    input Cin;
    output [15:0] y;
    output Co;

    wire C8;

    // First 8-bit adder for the least significant 8 bits
    adder_8bit adder0(a[7:0], b[7:0], Cin, y[7:0], C8);

    // Second 8-bit adder for the most significant 8 bits
    adder_8bit adder1(a[15:8], b[15:8], C8, y[15:8], Co);
endmodule
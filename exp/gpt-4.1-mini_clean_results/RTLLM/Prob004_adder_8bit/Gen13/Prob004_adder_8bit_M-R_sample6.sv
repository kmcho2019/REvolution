// Single bit full adder module
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    wire axb;
    assign axb  = a ^ b;
    assign sum  = axb ^ cin;
    assign cout = (a & b) | (axb & cin);
endmodule

// 8-bit adder with explicit propagate/generate and carry signals without generate loops
module adder_8bit (
    input  wire [7:0] a,    // 8-bit operand A
    input  wire [7:0] b,    // 8-bit operand B
    input  wire       cin,  // carry-in input
    output wire [7:0] sum,  // 8-bit sum output
    output wire       cout  // carry-out output
);

    // Explicit propagate signals per bit
    wire p0 = a[0] ^ b[0];
    wire p1 = a[1] ^ b[1];
    wire p2 = a[2] ^ b[2];
    wire p3 = a[3] ^ b[3];
    wire p4 = a[4] ^ b[4];
    wire p5 = a[5] ^ b[5];
    wire p6 = a[6] ^ b[6];
    wire p7 = a[7] ^ b[7];

    // Explicit generate signals per bit
    wire g0 = a[0] & b[0];
    wire g1 = a[1] & b[1];
    wire g2 = a[2] & b[2];
    wire g3 = a[3] & b[3];
    wire g4 = a[4] & b[4];
    wire g5 = a[5] & b[5];
    wire g6 = a[6] & b[6];
    wire g7 = a[7] & b[7];

    // Carry signals as individual wires
    wire carry0 = cin;
    wire carry1 = g0 | (p0 & carry0);
    wire carry2 = g1 | (p1 & carry1);
    wire carry3 = g2 | (p2 & carry2);
    wire carry4 = g3 | (p3 & carry3);
    wire carry5 = g4 | (p4 & carry4);
    wire carry6 = g5 | (p5 & carry5);
    wire carry7 = g6 | (p6 & carry6);
    wire carry8 = g7 | (p7 & carry7);

    // Instantiate full adders for each bit
    bit_full_adder fa0 (.a(a[0]), .b(b[0]), .cin(carry0), .sum(sum[0]), .cout());
    bit_full_adder fa1 (.a(a[1]), .b(b[1]), .cin(carry1), .sum(sum[1]), .cout());
    bit_full_adder fa2 (.a(a[2]), .b(b[2]), .cin(carry2), .sum(sum[2]), .cout());
    bit_full_adder fa3 (.a(a[3]), .b(b[3]), .cin(carry3), .sum(sum[3]), .cout());
    bit_full_adder fa4 (.a(a[4]), .b(b[4]), .cin(carry4), .sum(sum[4]), .cout());
    bit_full_adder fa5 (.a(a[5]), .b(b[5]), .cin(carry5), .sum(sum[5]), .cout());
    bit_full_adder fa6 (.a(a[6]), .b(b[6]), .cin(carry6), .sum(sum[6]), .cout());
    bit_full_adder fa7 (.a(a[7]), .b(b[7]), .cin(carry7), .sum(sum[7]), .cout());

    assign cout = carry8;

endmodule
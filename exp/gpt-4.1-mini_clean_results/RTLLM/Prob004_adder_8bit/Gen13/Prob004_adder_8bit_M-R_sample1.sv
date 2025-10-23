// Single bit full adder module
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));
endmodule

// 8-bit adder with explicit carry lookahead computation (no generate block)
module adder_8bit (
    input  wire [7:0] a,    // Operand A
    input  wire [7:0] b,    // Operand B
    input  wire       cin,  // Carry in
    output wire [7:0] sum,  // Sum output
    output wire       cout  // Carry out
);
    // Propagate and generate signals for each bit (flat style)
    wire p0 = a[0] ^ b[0];
    wire p1 = a[1] ^ b[1];
    wire p2 = a[2] ^ b[2];
    wire p3 = a[3] ^ b[3];
    wire p4 = a[4] ^ b[4];
    wire p5 = a[5] ^ b[5];
    wire p6 = a[6] ^ b[6];
    wire p7 = a[7] ^ b[7];

    wire g0 = a[0] & b[0];
    wire g1 = a[1] & b[1];
    wire g2 = a[2] & b[2];
    wire g3 = a[3] & b[3];
    wire g4 = a[4] & b[4];
    wire g5 = a[5] & b[5];
    wire g6 = a[6] & b[6];
    wire g7 = a[7] & b[7];

    // Carry signals calculated using carry lookahead equations:
    // carry[0] = cin
    wire c0 = cin;

    wire c1 = g0 | (p0 & c0);
    wire c2 = g1 | (p1 & c1);
    wire c3 = g2 | (p2 & c2);
    wire c4 = g3 | (p3 & c3);
    wire c5 = g4 | (p4 & c4);
    wire c6 = g5 | (p5 & c5);
    wire c7 = g6 | (p6 & c6);
    wire c8 = g7 | (p7 & c7);

    // Instantiate full adders bitwise with precomputed carries
    bit_full_adder fa0 (.a(a[0]), .b(b[0]), .cin(c0), .sum(sum[0]), .cout());
    bit_full_adder fa1 (.a(a[1]), .b(b[1]), .cin(c1), .sum(sum[1]), .cout());
    bit_full_adder fa2 (.a(a[2]), .b(b[2]), .cin(c2), .sum(sum[2]), .cout());
    bit_full_adder fa3 (.a(a[3]), .b(b[3]), .cin(c3), .sum(sum[3]), .cout());
    bit_full_adder fa4 (.a(a[4]), .b(b[4]), .cin(c4), .sum(sum[4]), .cout());
    bit_full_adder fa5 (.a(a[5]), .b(b[5]), .cin(c5), .sum(sum[5]), .cout());
    bit_full_adder fa6 (.a(a[6]), .b(b[6]), .cin(c6), .sum(sum[6]), .cout());
    bit_full_adder fa7 (.a(a[7]), .b(b[7]), .cin(c7), .sum(sum[7]), .cout());

    assign cout = c8;

endmodule
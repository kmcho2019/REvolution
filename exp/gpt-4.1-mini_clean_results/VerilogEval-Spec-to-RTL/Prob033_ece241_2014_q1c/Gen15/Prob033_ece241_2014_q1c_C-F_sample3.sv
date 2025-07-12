module FourBitCLA (
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout,
    output       group_p,
    output       group_g,
    output       carry_into_msb
);
    // Internal propagate and generate
    wire [3:0] p = a ^ b;
    wire [3:0] g = a & b;

    // Carries inside the 4-bit block
    wire c1, c2, c3;

    assign c1 = g[0] | (p[0] & cin);
    assign c2 = g[1] | (p[1] & c1);
    assign c3 = g[2] | (p[2] & c2);
    assign cout = g[3] | (p[3] & c3);

    assign sum = p ^ {c3,c2,c1,cin};

    // Group propagate and generate signals
    assign group_p = &p;             // AND of all propagate signals
    assign group_g = g[3] | (p[3] & g[2]) | (p[3]&p[2]&g[1]) | (p[3]&p[2]&p[1]&g[0]);
    assign carry_into_msb = c3; // carry into MSB of this 4-bit block

endmodule

module EightBitHierCLA (
    input  [7:0] a,
    input  [7:0] b,
    input        cin,
    output [7:0] sum,
    output       cout,
    output       carry_into_msb
);
    // Split inputs into two 4-bit groups
    wire [3:0] a_low = a[3:0];
    wire [3:0] a_high = a[7:4];
    wire [3:0] b_low = b[3:0];
    wire [3:0] b_high = b[7:4];

    // Wires for group propagate and generate for low and high groups
    wire p_low, g_low, p_high, g_high;
    wire c4; // carry from low group to high group
    wire c_high_into_msb;

    // Instantiate low 4-bit CLA block
    wire carry_into_msb_low;
    FourBitCLA low_block (
        .a(a_low),
        .b(b_low),
        .cin(cin),
        .sum(sum[3:0]),
        .cout(),            // unused here
        .group_p(p_low),
        .group_g(g_low),
        .carry_into_msb(carry_into_msb_low)
    );

    // Compute carry into high 4-bit block using group propagate and generate of low group
    assign c4 = g_low | (p_low & cin);

    // Instantiate high 4-bit CLA block
    FourBitCLA high_block (
        .a(a_high),
        .b(b_high),
        .cin(c4),
        .sum(sum[7:4]),
        .cout(cout),
        .group_p(p_high),
        .group_g(g_high),
        .carry_into_msb(c_high_into_msb)
    );

    assign carry_into_msb = c_high_into_msb;

endmodule

module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire cout, carry_into_msb;

    EightBitHierCLA adder (
        .a(a),
        .b(b),
        .cin(1'b0),
        .sum(s),
        .cout(cout),
        .carry_into_msb(carry_into_msb)
    );

    // Signed overflow occurs when carry into MSB xor carry out of MSB
    assign overflow = carry_into_msb ^ cout;

endmodule
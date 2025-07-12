module FourBitCLA (
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout,
    output       carry_into_msb
);
    wire [3:0] p;  // propagate signals
    wire [3:0] g;  // generate signals
    wire [4:0] c;  // carry signals: c[0]=cin, c[4]=cout

    assign p = a ^ b;
    assign g = a & b;

    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);

    assign sum = p ^ c[3:0];
    assign cout = c[4];
    assign carry_into_msb = c[3];  // carry into MSB (bit 3 of this block)
endmodule

module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire c4;          // carry out from lower 4-bit block
    wire carry7_in;   // carry into bit 7 (MSB) from upper 4-bit block
    wire cout_upper;  // carry out from upper 4-bit block (final carry out)

    // Instantiate lower 4-bit CLA
    FourBitCLA lower4 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(1'b0),
        .sum(s[3:0]),
        .cout(c4),
        .carry_into_msb() // unused here
    );

    // Instantiate upper 4-bit CLA
    FourBitCLA upper4 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(c4),
        .sum(s[7:4]),
        .cout(cout_upper),
        .carry_into_msb(carry7_in)
    );

    // Overflow detection: XOR of carry into and carry out of MSB (bit 7)
    assign overflow = carry7_in ^ cout_upper;
endmodule
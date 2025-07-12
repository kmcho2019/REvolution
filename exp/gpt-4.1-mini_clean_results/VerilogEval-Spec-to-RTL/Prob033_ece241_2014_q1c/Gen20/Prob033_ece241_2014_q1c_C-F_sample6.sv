module FourBitCLA (
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout,
    output       carry_into_msb
);
    wire [3:0] p;  // propagate
    wire [3:0] g;  // generate
    wire [4:0] c;  // carry signals

    assign p = a ^ b;
    assign g = a & b;
    assign c[0] = cin;

    // Carry lookahead logic within 4-bit block:
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);

    assign sum = p ^ c[3:0];
    assign cout = c[4];
    assign carry_into_msb = c[3];  // carry into MSB of this 4-bit block (bit 3)
endmodule

module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire cout_lower, cout_upper;
    wire carry_into_msb_lower, carry_into_msb_upper;

    // Lower 4-bit CLA block
    FourBitCLA lower (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(1'b0),
        .sum(s[3:0]),
        .cout(cout_lower),
        .carry_into_msb(carry_into_msb_lower)
    );

    // Upper 4-bit CLA block, carry-in from lower block cout
    FourBitCLA upper (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(cout_lower),
        .sum(s[7:4]),
        .cout(cout_upper),
        .carry_into_msb(carry_into_msb_upper)
    );

    // Overflow detection: XOR carry into MSB (bit 7) and carry out of MSB (bit 7)
    // carry_into_msb_upper is carry into bit 7 of the 8-bit adder
    // cout_upper is carry out of bit 7
    assign overflow = carry_into_msb_upper ^ cout_upper;
endmodule
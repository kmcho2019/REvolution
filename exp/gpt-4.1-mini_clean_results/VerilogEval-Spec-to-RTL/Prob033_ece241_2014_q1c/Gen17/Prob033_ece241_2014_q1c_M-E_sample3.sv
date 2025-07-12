module FourBitCLAAdder (
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout,
    output       carry_into_msb
);
    wire [3:0] p; // propagate
    wire [3:0] g; // generate
    wire [4:0] c; // carry signals

    assign p = a ^ b;
    assign g = a & b;
    assign c[0] = cin;

    // Compute carries in parallel with CLA logic:
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);

    assign sum = p ^ c[3:0];
    assign cout = c[4];
    assign carry_into_msb = c[3]; // carry into MSB (bit 3 of this 4-bit block)
endmodule

module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire       c4;        // carry out from lower 4-bit adder
    wire       carry6;    // carry into bit 7 (MSB) inside upper 4-bit adder
    wire       cout;      // carry out of upper 4-bit adder (final carry out)

    // Lower 4 bits
    FourBitCLAAdder lower4 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(1'b0),
        .sum(s[3:0]),
        .cout(c4),
        .carry_into_msb() // not used here
    );

    // Upper 4 bits
    FourBitCLAAdder upper4 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(c4),
        .sum(s[7:4]),
        .cout(cout),
        .carry_into_msb(carry6)
    );

    // Overflow detection: XOR of carry into MSB (bit 7) and carry out of MSB
    assign overflow = carry6 ^ cout;

endmodule
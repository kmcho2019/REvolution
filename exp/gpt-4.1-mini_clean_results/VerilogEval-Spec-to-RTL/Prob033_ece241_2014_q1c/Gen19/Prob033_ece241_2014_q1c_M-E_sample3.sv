module FourBitRCA (
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout,
    output       carry_into_msb
);
    wire c1, c2, c3;

    // Bit 0
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign c1     = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);

    // Bit 1
    assign sum[1] = a[1] ^ b[1] ^ c1;
    assign c2     = (a[1] & b[1]) | (a[1] & c1) | (b[1] & c1);

    // Bit 2
    assign sum[2] = a[2] ^ b[2] ^ c2;
    assign c3     = (a[2] & b[2]) | (a[2] & c2) | (b[2] & c2);

    // Bit 3 (MSB of this 4-bit block)
    assign sum[3] = a[3] ^ b[3] ^ c3;
    assign cout   = (a[3] & b[3]) | (a[3] & c3) | (b[3] & c3);
    assign carry_into_msb = c3; // Carry into the MSB bit of this block
endmodule

module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire cout_lower, cout_upper;
    wire carry_into_msb_lower, carry_into_msb_upper;

    // Lower 4-bit RCA
    FourBitRCA lower_4bit (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(1'b0),
        .sum(s[3:0]),
        .cout(cout_lower),
        .carry_into_msb(carry_into_msb_lower)
    );

    // Upper 4-bit RCA, carry-in from lower 4-bit cout
    FourBitRCA upper_4bit (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(cout_lower),
        .sum(s[7:4]),
        .cout(cout_upper),
        .carry_into_msb(carry_into_msb_upper)
    );

    // For overflow detection in 8-bit signed add:
    // Overflow = carry into MSB (bit 7) XOR carry out MSB (bit 7)
    // carry_into_msb_upper = carry into bit 7
    // cout_upper = carry out of bit 7
    assign overflow = carry_into_msb_upper ^ cout_upper;
endmodule
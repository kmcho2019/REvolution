module FourBitCLAAdder (
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout,
    output       carry_into_msb // carry into bit 3 (MSB of this 4-bit block)
);
    wire [3:0] p;    // propagate signals
    wire [3:0] g;    // generate signals
    wire [4:0] c;    // carry signals: c[0]=cin, c[4]=cout

    assign p = a ^ b;
    assign g = a & b;

    assign c[0] = cin;

    // Carry-lookahead logic for 4 bits:
    // c[i+1] = g[i] | (p[i] & c[i])
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);

    assign sum = p ^ c[3:0];
    assign cout = c[4];

    // carry_into_msb is carry into bit 3 (the MSB of the block)
    assign carry_into_msb = c[3];

endmodule


module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire lower_cout, upper_cout;
    wire lower_carry_into_msb, upper_carry_into_msb;
    wire [3:0] lower_sum, upper_sum;

    // Lower 4-bit adder (bits 3 downto 0)
    FourBitCLAAdder lower_adder (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(1'b0),
        .sum(lower_sum),
        .cout(lower_cout),
        .carry_into_msb(lower_carry_into_msb)
    );

    // Upper 4-bit adder (bits 7 downto 4)
    FourBitCLAAdder upper_adder (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(lower_cout),
        .sum(upper_sum),
        .cout(upper_cout),
        .carry_into_msb(upper_carry_into_msb)
    );

    assign s = {upper_sum, lower_sum};

    // Overflow occurs if carry into MSB bit (bit 7) differs from carry out of MSB bit (bit 7)
    // carry into MSB is upper_carry_into_msb (carry into bit 7)
    // carry out of MSB is upper_cout (carry out of bit 7)
    assign overflow = upper_carry_into_msb ^ upper_cout;

endmodule
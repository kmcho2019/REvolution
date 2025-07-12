module FourBitAdder (
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout
);
    wire c1, c2, c3;

    // bit 0
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign c1 = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);

    // bit 1
    assign sum[1] = a[1] ^ b[1] ^ c1;
    assign c2 = (a[1] & b[1]) | (a[1] & c1) | (b[1] & c1);

    // bit 2
    assign sum[2] = a[2] ^ b[2] ^ c2;
    assign c3 = (a[2] & b[2]) | (a[2] & c2) | (b[2] & c2);

    // bit 3
    assign sum[3] = a[3] ^ b[3] ^ c3;
    assign cout = (a[3] & b[3]) | (a[3] & c3) | (b[3] & c3);
endmodule


module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire lower_cout;
    wire [3:0] lower_sum, upper_sum;

    // Instantiate lower 4-bit adder (bits 3 downto 0)
    FourBitAdder lower_adder (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(1'b0),
        .sum(lower_sum),
        .cout(lower_cout)
    );

    // Instantiate upper 4-bit adder (bits 7 downto 4)
    wire upper_cout;
    FourBitAdder upper_adder (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(lower_cout),
        .sum(upper_sum),
        .cout(upper_cout)
    );

    assign s = {upper_sum, lower_sum};

    // Overflow detection:
    // Overflow occurs if carry into MSB differs from carry out of MSB
    // Carry into MSB = carry out from bit 6 to 7 = carry out from lower 4-bit adder's carry chain at bit 3 plus 3 bits in upper adder
    // Here, since upper_adder is a ripple-carry, carry into MSB = carry propagated inside upper_adder at bit 3,
    // but for simplicity, overflow can be detected as:
    // overflow = carry into MSB (bit 7) XOR carry out MSB (bit 7)
    // carry into MSB = carry out from bit 6 which is carry from bit 2 to 3 inside upper_adder.
    // To avoid exposing internal carries, use an alternative formula for overflow on two's complement:
    // overflow = (a[7] & b[7] & ~s[7]) | (~a[7] & ~b[7] & s[7])
    assign overflow = (a[7] & b[7] & ~s[7]) | (~a[7] & ~b[7] & s[7]);

endmodule
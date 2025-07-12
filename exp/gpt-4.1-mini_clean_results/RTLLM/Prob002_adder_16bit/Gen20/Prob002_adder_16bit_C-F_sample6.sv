module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire c1, c2, c3, c4, c5, c6, c7;

    // bit 0
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign c1   = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);

    // bit 1
    assign y[1] = a[1] ^ b[1] ^ c1;
    assign c2   = (a[1] & b[1]) | (a[1] & c1) | (b[1] & c1);

    // bit 2
    assign y[2] = a[2] ^ b[2] ^ c2;
    assign c3   = (a[2] & b[2]) | (a[2] & c2) | (b[2] & c2);

    // bit 3
    assign y[3] = a[3] ^ b[3] ^ c3;
    assign c4   = (a[3] & b[3]) | (a[3] & c3) | (b[3] & c3);

    // bit 4
    assign y[4] = a[4] ^ b[4] ^ c4;
    assign c5   = (a[4] & b[4]) | (a[4] & c4) | (b[4] & c4);

    // bit 5
    assign y[5] = a[5] ^ b[5] ^ c5;
    assign c6   = (a[5] & b[5]) | (a[5] & c5) | (b[5] & c5);

    // bit 6
    assign y[6] = a[6] ^ b[6] ^ c6;
    assign c7   = (a[6] & b[6]) | (a[6] & c6) | (b[6] & c6);

    // bit 7
    assign y[7] = a[7] ^ b[7] ^ c7;
    assign Co   = (a[7] & b[7]) | (a[7] & c7) | (b[7] & c7);

endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_mid;

    // Instantiate lower 8-bit adder
    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_mid)
    );

    // Instantiate upper 8-bit adder
    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule
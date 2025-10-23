module adder_8bit_cla (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire [7:0] p;  // propagate signals
    wire [7:0] g;  // generate signals
    wire [7:1] c;  // internal carries

    // Generate and propagate signals for each bit
    assign p = a ^ b;
    assign g = a & b;

    // Carry lookahead logic
    assign c[1] = g[0] | (p[0] & Cin);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & c[5]);
    assign c[7] = g[6] | (p[6] & c[6]);

    // Sum bits
    assign y[0] = p[0] ^ Cin;
    assign y[1] = p[1] ^ c[1];
    assign y[2] = p[2] ^ c[2];
    assign y[3] = p[3] ^ c[3];
    assign y[4] = p[4] ^ c[4];
    assign y[5] = p[5] ^ c[5];
    assign y[6] = p[6] ^ c[6];
    assign y[7] = p[7] ^ c[7];

    // Carry-out
    assign Co = g[7] | (p[7] & c[7]);
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_mid;

    adder_8bit_cla lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_mid)
    );

    adder_8bit_cla upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule
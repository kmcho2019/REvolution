module adder_4bit_cla (
    input  [3:0] a,
    input  [3:0] b,
    input        Cin,
    output [3:0] y,
    output       Co
);
    wire [3:0] p;  // propagate
    wire [3:0] g;  // generate
    wire [3:1] c;  // internal carries

    // Propagate and generate signals
    assign p = a ^ b;
    assign g = a & b;

    // Carry look-ahead logic
    assign c[1] = g[0] | (p[0] & Cin);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & Cin);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & Cin);

    // Sum bits
    assign y[0] = p[0] ^ Cin;
    assign y[1] = p[1] ^ c[1];
    assign y[2] = p[2] ^ c[2];
    assign y[3] = p[3] ^ c[3];

    // Final carry out
    assign Co = g[3] | (p[3] & c[3]);
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire c1, c2, c3;
    wire [3:0] sum0, sum1, sum2, sum3;

    // Instantiate four 4-bit CLA adders in ripple carry fashion
    adder_4bit_cla u0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(sum0),
        .Co(c1)
    );

    adder_4bit_cla u1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(c1),
        .y(sum1),
        .Co(c2)
    );

    adder_4bit_cla u2 (
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(c2),
        .y(sum2),
        .Co(c3)
    );

    adder_4bit_cla u3 (
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(c3),
        .y(sum3),
        .Co(Co)
    );

    // Concatenate results
    assign y = {sum3, sum2, sum1, sum0};
endmodule
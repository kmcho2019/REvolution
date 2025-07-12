module adder_4bit_cla (
    input  [3:0] a,
    input  [3:0] b,
    input        Cin,
    output [3:0] y,
    output       Co
);
    wire [3:0] p;   // propagate
    wire [3:0] g;   // generate
    wire [4:1] c;   // carry signals internal

    // Generate and propagate signals
    assign p = a ^ b;
    assign g = a & b;

    // Carry lookahead logic
    assign c[1] = g[0] | (p[0] & Cin);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);

    // Sum bits
    assign y = p ^ {c[3:1], Cin};

    // Carry-out
    assign Co = c[4];

endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire c1, c2, c3;

    // First 4-bit CLA block (bits 3:0)
    adder_4bit_cla cla0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(c1)
    );

    // Second 4-bit CLA block (bits 7:4)
    adder_4bit_cla cla1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(c1),
        .y(y[7:4]),
        .Co(c2)
    );

    // Third 4-bit CLA block (bits 11:8)
    adder_4bit_cla cla2 (
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(c2),
        .y(y[11:8]),
        .Co(c3)
    );

    // Fourth 4-bit CLA block (bits 15:12)
    adder_4bit_cla cla3 (
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(c3),
        .y(y[15:12]),
        .Co(Co)
    );

endmodule
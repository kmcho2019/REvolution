module adder_4bit (
    input  [3:0] a,
    input  [3:0] b,
    input        Cin,
    output [3:0] y,
    output       Co,
    output       Pg, // group propagate
    output       Gg  // group generate
);
    wire [3:0] p, g;
    wire c1, c2, c3;

    assign p = a ^ b;
    assign g = a & b;

    // Carry signals within 4-bit block
    assign c1 = g[0] | (p[0] & Cin);
    assign c2 = g[1] | (p[1] & c1);
    assign c3 = g[2] | (p[2] & c2);

    assign y[0] = p[0] ^ Cin;
    assign y[1] = p[1] ^ c1;
    assign y[2] = p[2] ^ c2;
    assign y[3] = p[3] ^ c3;

    // Group propagate and generate for 4-bit block
    assign Pg = &p; // p0&p1&p2&p3
    assign Gg = g[3] | (p[3] & g[2]) | (p[3]&p[2]&g[1]) | (p[3]&p[2]&p[1]&g[0]);

    assign Co = Gg | (Pg & Cin);
endmodule

module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire Pg0, Gg0, Pg1, Gg1;
    wire c4;

    // Lower 4 bits
    adder_4bit lower_4 (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(),
        .Pg(Pg0),
        .Gg(Gg0)
    );

    // Upper 4 bits
    adder_4bit upper_4 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(c4),
        .y(y[7:4]),
        .Co(Co),
        .Pg(Pg1),
        .Gg(Gg1)
    );

    // Carry to upper 4-bit block
    assign c4 = Gg0 | (Pg0 & Cin);
endmodule

module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_8;

    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_8)
    );

    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_8),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule
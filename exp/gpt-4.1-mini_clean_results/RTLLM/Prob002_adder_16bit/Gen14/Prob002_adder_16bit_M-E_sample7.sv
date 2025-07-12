module cla_4bit (
    input  [3:0] a,
    input  [3:0] b,
    input        Cin,
    output [3:0] y,
    output       Co
);
    wire [3:0] p; // propagate signals
    wire [3:0] g; // generate signals
    wire [4:0] c; // carries

    assign p = a ^ b;
    assign g = a & b;

    assign c[0] = Cin;
    // Carry lookahead logic:
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);

    assign y = p ^ c[3:0];
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

    cla_4bit cla0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(c1)
    );

    cla_4bit cla1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(c1),
        .y(y[7:4]),
        .Co(c2)
    );

    cla_4bit cla2 (
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(c2),
        .y(y[11:8]),
        .Co(c3)
    );

    cla_4bit cla3 (
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(c3),
        .y(y[15:12]),
        .Co(Co)
    );
endmodule